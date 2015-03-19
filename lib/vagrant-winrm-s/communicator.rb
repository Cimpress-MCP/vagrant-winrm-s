require "timeout"
require "log4r"

require "vagrant/../../plugins/communicators/winrm/helper"
require_relative "shell"
require "vagrant/../../plugins/communicators/winrm/communicator"

module VagrantPlugins
  module CommunicatorWinRM
    class WinrmSCommunicator < Communicator
      def initialize(machine)
        super(machine)
      end

      protected

      def create_shell
        winrm_info = Helper.winrm_info(@machine)

        WinRMSShell.new(
          winrm_info[:host],
          @machine.config.winrm.username,
          @machine.config.winrm.password,
          transport: @machine.config.winrm.transport,
          port: winrm_info[:port],
          timeout_in_seconds: @machine.config.winrm.timeout,
          max_tries: @machine.config.winrm.max_tries)
      end

    end
  end
end
