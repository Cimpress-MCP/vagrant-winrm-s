require "vagrant/../../plugins/communicators/winrm/config"

module VagrantPlugins
  module CommunicatorWinRM
    class WinrmSConfig < Config

      attr_accessor :transport

      def initialize
        super
        @transport = UNSET_VALUE
      end

      def finalize!
        @username = "vagrant"   if @username == UNSET_VALUE
        @password = "vagrant"   if @password == UNSET_VALUE
        @host = nil             if @host == UNSET_VALUE
        @port = 5985            if @port == UNSET_VALUE
        @guest_port = 5985      if @guest_port == UNSET_VALUE
        @max_tries = 20         if @max_tries == UNSET_VALUE
        @timeout = 1800         if @timeout == UNSET_VALUE
        @transport = :plaintext if @transport == UNSET_VALUE
      end

      def validate(_machine)
        errors = []

        errors << "winrm.username cannot be nil."   if @username.nil?
        errors << "winrm.password cannot be nil."   if @password.nil?
        errors << "winrm.port cannot be nil."       if @port.nil?
        errors << "winrm.guest_port cannot be nil." if @guest_port.nil?
        errors << "winrm.max_tries cannot be nil."  if @max_tries.nil?
        errors << "winrm.timeout cannot be nil."    if @timeout.nil?
        errors << "winrm.transport cannot be nil."  if @transport.nil?

        { "WinRM" => errors }
      end
    end
  end
end
