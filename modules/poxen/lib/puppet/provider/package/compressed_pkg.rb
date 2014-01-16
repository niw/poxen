require "puppet/provider/package"

Puppet::Type.type(:package).provide(:compressed_pkg, :parent => Puppet::Provider::Package) do
  desc "Installs a compressed .pkg or .mpkg. Supports zip, tar.gz, tar.bz2"

  confine  :operatingsystem => :darwin

  has_command :installer, "/usr/sbin/installer" do
    # Set USER environment value to Facter[:boxen_user] lazily.
    #
    # NOTE At this moment, it's unclear how we can tell /usr/sbin/installer to create an install
    # request with login user id instead of root for installd, which what GUI installer does.
    # Some package may run preinstall or postinstall scripts which assume USER is login user,
    # so giving USER environment to /usr/sbin/installer solves this specific issue.
    # See /var/log/install.log to understand how GUI installer works.
    #
    # NOTE CommandDefiner eventually gives :custom_environment option for Puppet::Util::Execution#execute
    # but the value itself is evaluated at the time has_command called.
    # the Facter value is not set at this moment while testing, so we need to lazy evaluate the value.
    # :custom_environment are set to ENV hash and ENV hash converts the value into String implicitly
    # using to_str so this works.
    # See lib/puppet/provider.rb, lib/puppet/util/execution.rb, hash.c and string.c.
    environment :USER => Class.new {
      def to_str
        Facter[:boxen_user].value
      end
    }.new
  end

  commands :curl => "/usr/bin/curl",
           :unzip => "/usr/bin/unzip",
           :tar => "/usr/bin/tar"

  def self.pkg_source_types
    @pkg_source_types ||= %w(zip tar.gz tar.bz2 tgz tbz)
  end

  def self.cookie_file(name)
    "/var/db/.puppet_compressed_pkg_installed_#{name}"
  end

  def self.instances
    Dir.glob(cookie_file("*")).map do |path|
      name = File.basename(path).sub(".puppet_compressed_pkg_installed_", "")
      new(:name => name, :provider => :compressed_pkg, :ensure => :installed)
    end
  end

  def query
    if File.exists?(self.class.cookie_file(@resource[:name]))
      {
        :name   => @resource[:name],
        :ensure => :installed
      }
    end
  end

  def install
    unless source = @resource[:source]
      self.fail "OS X compressed apps must specify a package source"
    end

    unless name = @resource[:name]
      self.fail "OS X compressed apps must specify a package name"
    end

    if flavor = @resource[:flavor]
      self.fail "Unsupported flavor" unless self.class.pkg_source_types.include?(flavor)
    end

    install_compressed_pkg(name, source, flavor)
  end

  private

  def install_compressed_pkg(name, source, flavor = nil)
    source_type = flavor || source_type_for(source)

    tmpdir = Dir.mktmpdir
    cached_source = File.join(tmpdir, "#{name}.pkg#{source_type ? ".#{source_type}" : ""}")

    curl "-o", cached_source, "-C", "-", "-L", "-s", source

    case source_type
    when 'zip'
      unzip "-o", cached_source, "-d", tmpdir
    when 'tar.gz', 'tgz'
      tar "-zxf", cached_source, "-C", tmpdir
    when 'tar.bz2', 'tbz'
      tar "-jxf", cached_source, "-C", tmpdir
    end

    packages = list_packages(tmpdir)
    if packages.empty?
      # Some archive file has a single top directory contains all contents,
      # which prevents us to find the install packages.
      # Check if the archive has an only top directory, then use packages in it.
      enclosure = Dir.glob(File.join(tmpdir, "*")).select do |path|
        !%w(__MACOSX).include?(File.basename(path)) && File.directory?(path)
      end
      if enclosure.size == 1
        packages = list_packages(enclosure.first)
      else
        self.fail "Source must contain at least one package file."
      end
    end

    packages.each do |path|
      install_pkg(path, name, source)
    end
  end

  def source_type_for(source)
    self.class.pkg_source_types.find do |source_type|
      source.downcase.end_with?(".#{source_type}")
    end
  end

  def list_packages(path)
    Dir.glob(File.join(path, "*.{pkg,mpkg}"))
  end

  def install_pkg(path, name, source)
    # Non-zero exit status will throw an exception.
    installer "-verbose", "-pkg", path, "-target", "/"

    File.open(self.class.cookie_file(name), "w") do |t|
      t.print "name: '#{name}'\n"
      t.print "source: '#{source}'\n"
    end
  end
end
