require 'rspec/core/rake_task'

spec_tasks = Dir.glob(File.expand_path("../modules/*", __FILE__)).map do |path|
  name = File.basename(path)
  task_name = :"spec:#{name}"

  desc "Run #{name} RSpec examples"
  RSpec::Core::RakeTask.new(task_name) do |task|
    task.pattern = "#{path}/spec/{,*/**/}*_spec.rb"
    task.ruby_opts = "-I#{path}/lib:#{path}/spec"
  end

  task_name
end

desc "Run all RSpec examples"
task :spec => spec_tasks

task :default => :spec
