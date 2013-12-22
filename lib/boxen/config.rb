# Pseudo Boxen::Config class, but immutable.
# These settings are used from the facter in boxen Puppet modules.
# See /shared/boxen/lib/facter/boxen.rb

module Boxen
  class Config
    def self.load
      new
    end

    def self.save(config)
    end

    def api
    end

    def debug?
      false
    end

    def email
    end

    def envfile
      "#{homedir}/env.sh"
    end

    def fde?
      true
    end

    def homedir
      "/opt/boxen"
    end

    def logfile
      "#{repodir}/log/boxen.log"
    end

    def login
    end

    def name
    end

    def pretend?
      false
    end

    def profile?
      false
    end

    def future_parser?
      false
    end

    def report?
      false
    end

    def projects
      []
    end

    def puppetdir
      # See script/poxen, which creates this temporary directory.
      "/tmp/poxen/puppet"
    end

    def repodir
      File.expand_path "../../..", __FILE__
    end

    def reponame
      "poxen"
    end

    def ghurl
      "https://github.com"
    end

    def repotemplate
      "https://github.com/%s"
    end

    def enterprise?
      false
    end

    def srcdir
      "#{ENV["HOME"]}/src"
    end

    def stealth?
      # Don't auto-create issues on failure? Default was `false` in Boxen.
      true
    end

    def token
    end

    def user
      @user ||= ENV["SUDO_USER"] || ENV["USER"]
    end

    def color?
      true
    end
  end
end
