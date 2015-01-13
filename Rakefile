require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new

task :install_local do
  system("rake build")
  system("vagrant plugin install ./pkg/vagrant-winrm-s-0.0.1.gem")
end
