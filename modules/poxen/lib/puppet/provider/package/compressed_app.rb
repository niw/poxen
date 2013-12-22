require "puppet/provider/package"

Puppet::Type.type(:package).provide :compressed_app, :parent => Puppet::Provider::Package do
  desc "Installs a compressed .app. Supports zip, tar.gz, tar.bz2"

  SOURCE_TYPES = %w(zip tar.gz tar.bz2 tgz tbz)

  commands :curl => "/usr/bin/curl"

  confine  :operatingsystem => :darwin

  def self.instances_by_name
    Dir.entries("/var/db").find_all { |f|
      f =~ /^\.puppet_compressed_app_installed_/
    }.collect do |f|
      name = f.sub(/^\.puppet_compressed_app_installed_/, '')
      yield name if block_given?
      name
    end
  end

  def self.instances
    instances_by_name.collect do |name|
      new(:name => name, :provider => :compressed_app, :ensure => :installed)
    end
  end

  def self.install_compressed_app(name, source, flavor = nil)
    source_type = case
    when flavor
      flavor
    when source =~ /\.zip$/i
      'zip'
    when source =~ /\.tar\.gz$/i
      'tar.gz'
    when source =~ /\.tgz$/i
      'tgz'
    when source =~ /\.tar\.bz2$/i
      'tar.bz2'
    when source =~ /\.tbz$/i
      'tbz'
    else
      self.fail "Source must be one of .zip, .tar.gz, .tgz, .tar.bz2, .tbz"
    end

    tmpdir = Dir.mktmpdir
    cached_source = File.join(tmpdir, "#{name}.app.#{source_type}")

    curl "-o", cached_source, "-C", "-", "-L", "-s", source

    case source_type
    when 'zip'
      execute [
        "/usr/bin/unzip",
        "-o",
        cached_source,
        "-d",
        tmpdir
      ]
    when 'tar.gz', 'tgz'
      execute [
        "/usr/bin/tar",
        "-zxf",
        cached_source,
        "-C",
        tmpdir
      ]
    when 'tar.bz2', 'tbz'
      execute [
        "/usr/bin/tar",
        "-jxf",
        cached_source,
        "-C",
        tmpdir
      ]
    end

    Dir.entries(tmpdir).select { |f|
      File.extname(f) == ".app"
    }.each do |app|
      execute ["/bin/mv", "#{tmpdir}/#{app}", "/Applications"]
      execute [
        "/usr/sbin/chown",
        "-R",
        "#{Facter[:boxen_user].value}:admin",
        "/Applications/#{app}"
      ]
    end

    File.open("/var/db/.puppet_compressed_app_installed_#{name}", "w") do |t|
      t.print "name: '#{name}'\n"
      t.print "source: '#{source}'\n"
    end
  end

  def query
    if File.exists?("/var/db/.puppet_compressed_app_installed_#{@resource[:name]}")
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
      unless SOURCE_TYPES.member? flavor
        self.fail "Unsupported flavor"
      end
    end

    self.class.install_compressed_app name, source, flavor
  end
end
