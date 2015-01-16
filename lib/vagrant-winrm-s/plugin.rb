begin
  require "vagrant"
rescue LoadError
  raise "vagrant-winrm-s must be run from within vagrant."
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
