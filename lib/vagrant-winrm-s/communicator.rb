require "timeout"
require "log4r"

require_relative "helper"
require_relative "shell"
require_relative "command_filter"

module VagrantPlugins
  module CommunicatorWinRM
    class Communicator < Vagrant.plugin("2", :communicator)
      def self.match?(_machine)
        # This is useless, and will likely be removed in the future (this
        # whole method).
        true
      end

      def initialize(machine)
        @cmd_filter = CommandFilter.new
        @logger = Log4r::Logger.new("vagrant::communication::winrms")
        @machine = machine
        @shell = nil

        @logger.info("Initializing WinRMSCommunicator")
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

      def shell(reload = false)
        @shell = nil if reload
        @shell ||= create_shell
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

      def test(command, opts = nil)
        command = @cmd_filter.filter(command)
        return false if command.empty?

        opts = { error_check: false }.merge(opts || {})
        execute(command, opts) == 0
      end

      def upload(from, to)
        @logger.info("Uploading: #{from} to #{to}")
        shell.upload(from, to)
      end

      def download(from, to)
        @logger.info("Downloading: #{from} to #{to}")
        shell.download(from, to)
      end

      protected

      def create_shell
        winrm_info = Helper.winrm_info(@machine)

        WinRMShell.new(
          winrm_info[:host],
          @machine.config.winrm.username,
          @machine.config.winrm.password,
          transport: @machine.config.winrm.transport,
          port: @machine.config.winrm.port,
          timeout_in_seconds: @machine.config.winrm.timeout,
          max_tries: @machine.config.winrm.max_tries
        )
      end

      def create_elevated_shell_script(command)
        path = File.expand_path("../scripts/elevated_shell.ps1", __FILE__)
        script = Vagrant::Util::TemplateRenderer.render(path, options:
        {
          username: shell.username,
          password: shell.password,
          command: command
        })

        guest_script_path = "c:/tmp/vagrant-elevated-shell.ps1"
        file = Tempfile.new(["vagrant-elevated-shell", "ps1"])

        begin
          file.write(script)
          file.fsync
          file.close
          upload(file.path, guest_script_path)
        ensure
          file.close
          file.unlink
        end
        guest_script_path
      end

      def execution_output(output, opts)
        if opts[:shell] == :wql
          return output
        elsif opts[:error_check] && !opts[:good_exit].include?(output[:exitcode])
          raise_execution_error(output, opts)
        end
        output[:exitcode]
      end

      def raise_execution_error(output, opts)
        msg = "command execution failed with an exit code of #{output[:exitcode]}"
        error_opts = opts.merge(_key: opts[:error_key], message: msg)
        fail opts[:error_class], error_opts
      end
    end
  end
end
