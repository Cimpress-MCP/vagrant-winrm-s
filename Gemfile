source "https://rubygems.org"

# Specify your gem's dependencies in vagrant-winrm-s.gemspec
gemspec

group :development do
  gem "vagrant", git: "https://github.com/mitchellh/vagrant.git"
  gem "vagrant-spec", git: "https://github.com/mitchellh/vagrant-spec.git"
end

group :plugins do
  gem "vagrant-winrm-s", path: "."
  gem "vagrant-managed-servers"
  gem "vagrant-orchestrate"
  # gem "vagrant-librarian-puppet"
end
