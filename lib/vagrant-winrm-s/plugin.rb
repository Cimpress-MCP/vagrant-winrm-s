begin
  require "vagrant"
rescue LoadError
  raise "vagrant-winrm-s must be run from within vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.6.0"
  fail "vagrant-winrm-s has only been tested with Vagrant 1.6+"
end

require "vagrant/../../plugins/communicators/winrm/plugin"

module VagrantPlugins
  module CommunicatorWinRM
    class WinrmSPlugin < Plugin
      name "winrms communicator"
      description <<-DESC
      This plugin allows Vagrant to communicate with remote machines using
      SSPINegotiate when run from Windows Hosts.
      DESC

      communicator("winrm") do
        require File.expand_path("../communicator", __FILE__)
        init!
        WinrmSCommunicator
      end

      config("winrm") do
        require_relative "config"
        WinrmSConfig
      end
    end
  end
end
