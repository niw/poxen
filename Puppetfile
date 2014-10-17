# See https://github.com/rodjek/librarian-puppet

# Declare modules from Boxen Github repository.
def boxen(name, *args)
  args << {} unless Hash === args.last
  args.last[:github_tarball] ||= "boxen/puppet-#{name}"
  mod name, *args
end

mod "stdlib", "4.3.2", :github_tarball => "puppetlabs/puppetlabs-stdlib"

boxen "repository", "2.3.0"
boxen "osx", "2.7.1"
