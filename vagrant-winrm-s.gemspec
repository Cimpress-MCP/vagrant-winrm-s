# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-winrm-s/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-winrm-s"
  spec.version       = VagrantPlugins::CommunicatorWinRMS::VERSION
  spec.authors       = ["Norm MacLennan"]
  spec.email         = ["nmaclennan@cimpress.com"]
  spec.summary       = "Secure WinRM vagrant communicator"
  spec.description   = "A Vagrant plugin that allows for secure communication over WinRM"
  spec.homepage      = "https://github.com/Cimpress-MCP/vagrant-winrm-s"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "winrm-s", "~>0.1.0"
  spec.add_dependency "httpclient", "~>2.4.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 2.99"
  spec.add_development_dependency "rubocop", "~> 0.28"
end
