begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant Orchestrate plugin must be run within Vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.6.0"
  fail "The Vagrant Orchestrate plugin is only compatible with Vagrant 1.6+"
end

module VagrantPlugins
  module CommunicatorWinRM
    autoload :Errors, File.expand_path("../errors", __FILE__)

    class Plugin < Vagrant.plugin("2")
      name "winrms communicator"
      description <<-DESC
      This plugin allows Vagrant to communicate with remote machines using
      WinRM over SSL.
      DESC

      communicator("winrm") do
        require File.expand_path("../communicator", __FILE__)
        init!
        Communicator
      end

      config("winrm") do
        require_relative "config"
        Config
      end

      def self.init!
        retrn if defined?(@_init)
        @init = true

        I18n.load_path << File.expand_path(
          "locales/en.yml", CommunicatorWinRM.source_root)
        I18n.reload!

        require "vagrant/util/silence_warnings"
        Vagrant::Util::SilenceWarnings.silence! do
          require "winrm-s"
        end
      end
    end
  end
end
