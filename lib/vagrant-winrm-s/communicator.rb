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

      def ready?
        @logger.info("Checking if WinRM is ready...")

        Timeout.timeout(@machine.config.winrm.timeout) do
          shell(true).powershell("hostname")
        end

        @logger.info("WinRM is ready!")
        return true
      rescue Vagrant::Errors::VagrantError => e
        @logger.info("Problem communicating with WinRM: #{e.inspect}")

        @shell = nil
        return false
      end

      def execute(command, opts = {}, &block)
        command = @cmd_filter.filter(command)
        return 0 if command.empty?

        opts = {
          command: command,
          elevated: false,
          error_check: true,
          error_class: Errors::ExecutionError,
          error_key: :execution_error,
          good_exit: 0,
          shell: :powershell
        }.merge(opts || {})

        opts[:good_exit] = Array(opts[:good_exit])

        if opts[:elevated]
          guest_script_path = create_elevated_shell_script(command)
          command = "powershell -executionpolicy bypass -file #{guest_script_path}"
        end

        output = shell.send(opts[:shell], command, &block)
        execution_output(output, opts)
      end
      alias_method :sudo, :execute

      protected

      def create_shell
        winrm_info = Helper.winrm_info(@machine)

        WinRMSShell.new(
          winrm_info[:host],
          @machine.config.winrm.username,
          @machine.config.winrm.password,
          transport: @machine.config.winrm.transport,
          port: @machine.config.winrm.port,
          timeout_in_seconds: @machine.config.winrm.timeout,
          max_tries: @machine.config.winrm.max_tries
        )
      end

    end
  end
end
