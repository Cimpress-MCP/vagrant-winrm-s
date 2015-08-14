require "timeout"
require "log4r"
require "vagrant/util/retryable"
require "vagrant/util/silence_warnings"

Vagrant::Util::SilenceWarnings.silence! do
  require "winrm-s"
end

require "winrm-fs/file_manager"
require "vagrant/../../plugins/communicators/winrm/shell"

module VagrantPlugins
  module CommunicatorWinRM
    class WinRMSShell < WinRMShell
      include Vagrant::Util::Retryable

      def initialize(host, port, options = {})
        super(host, port, options)
        @logger = Log4r::Logger.new("vagrant::communication::winrmsshell")
      end

      protected

      def endpoint
        case @config.transport.to_sym
        when :ssl
          "https://#{@host}:#{@port}/wsman"
        when :plaintext
          "http://#{@host}:#{@port}/wsman"
        when :sspinegotiate
          "http://#{@host}:#{@port}/wsman"
        else
          # rubocop:disable SignalException
          # To match base vagrant style
          raise Errors::WinRMInvalidTransport, transport: @config.transport
          # rubocop:enable SignalException
        end
      end

      # The only reason we're overriding this one is to get rid
      # of `toggle_nori_type_casting` which is deprecated in new
      # versions of winrm gem (and the deprecation message seems
      # to have a bug that throws an exception)
      def new_session
        @logger.info("Attempting to connect to WinRM...")
        @logger.info("  - Host: #{@host}")
        @logger.info("  - Port: #{@port}")
        @logger.info("  - Username: #{@username}")
        @logger.info("  - Transport: #{@config.transport}")

        client = ::WinRM::WinRMWebService.new(endpoint, @config.transport.to_sym, endpoint_options)
        client.set_timeout(@config.timeout)
        client
      end

      def endpoint_options
        { user: @username,
          pass: @password,
          host: @host,
          port: @port,
          basic_auth_only: (@config.transport == :plaintext),
          no_ssl_peer_verification: !@config.ssl_peer_verification }
      end
    end
  end
end
