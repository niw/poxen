# See https://github.com/rodjek/librarian-puppet

# Declare modules from Boxen Github repository.
def boxen(name, *args)
  args << {} unless Hash === args.last
  args.last[:github_tarball] ||= "boxen/puppet-#{name}"
  mod name, *args
end

mod "stdlib", "4.1.0", :github_tarball => "puppetlabs/puppetlabs-stdlib"

boxen "repository", "2.2.0"
boxen "osx", "2.2.0"
