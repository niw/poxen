require "rspec-puppet"

fixture_path = File.expand_path("../fixtures", __FILE__)

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, "modules")
  c.manifest_dir = File.join(fixture_path, "manifests")
  c.default_facts = {
    :boxen_user => "testuser",
    :boxen_home => "/Users/testuser"
  }
end
