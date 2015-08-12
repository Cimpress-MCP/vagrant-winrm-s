require "timeout"
require "log4r"
require "vagrant/util/retryable"
require "vagrant/util/silence_warnings"

Vagrant::Util::SilenceWarnings.silence! do
  require "winrm-s"
end

require "vagrant/../../plugins/communicators/winrm/file_manager"
require "vagrant/../../plugins/communicators/winrm/shell"

module VagrantPlugins
  module CommunicatorWinRM
    class WinRMSShell < WinRMShell
      include Vagrant::Util::Retryable

      attr_reader :transport
      attr_reader :protocol

      def initialize(host, username, password, options = {})
        super(host, username, password, options)

        @logger = Log4r::Logger.new("vagrant::communication::winrmsshell")
        @transport =  options[:transport] || :plaintext
        @protocol = (options[:transport] == :ssl) ? "https" : "http"
      end

      protected

      def new_session
        @logger.info("Attempting to connect to WinRM...")
        @logger.info("  - Host: #{@host}")
        @logger.info("  - Port: #{@port}")
        @logger.info("  - Username: #{@username}")
        @logger.info("  - Transport: #{@transport}")
        @logger.info("  - Endpoint: #{endpoint}")

        client = ::WinRM::WinRMWebService.new(endpoint, @transport, endpoint_options)
        client.set_timeout(@timeout_in_seconds)
        client.toggle_nori_type_casting(:off)
        client
      end

      def endpoint
        "#{@protocol}://#{@host}:#{@port}/wsman"
      end

      def endpoint_options
        { user: @username,
          pass: @password,
          host: @host,
          port: @port,
          operation_timeout: @timeout_in_seconds,
          basic_auth_only: (@transport == :plaintext) }
      end
    end # WinShell class
  end
end
