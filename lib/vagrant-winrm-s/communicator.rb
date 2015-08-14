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
          winrm_info[:port],
          @machine.config.winrm
        )
      end

    end
  end
end
