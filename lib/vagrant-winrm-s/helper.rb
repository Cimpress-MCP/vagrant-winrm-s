module VagrantPlugins
  module CommunicatorWinRM
    # This is a helper module that provides some functions to the
    # communicator. This is extracted into a module so that we can
    # easily unit test these methods.
    module Helper
      # Returns the host and port to access WinRM.
      #
      # This asks the provider via the `winrm_info` capability if it
      # exists, otherwise defaulting to its own heuristics.
      #
      # @param [Vagrant::Machine] machine
      # @return [Hash]
      def self.winrm_info(machine)
        info = {}
        if machine.provider.capability?(:winrm_info)
          info = machine.provider.capability(:winrm_info)
          fail Errors::WinRMNotReady unless info
        end

        info[:host] ||= winrm_address(machine)
        info[:port] ||= 5985

        info
      end

      # Returns the address to access WinRM. This does not contain
      # the port.
      #
      # @param [Vagrant::Machine] machine
      # @return [String]
      def self.winrm_address(machine)
        addr = machine.config.winrm.host
        return addr if addr

        ssh_info = machine.ssh_info
        fail Errors::WinRMNotReady unless ssh_info
        ssh_info[:host]
      end

      # Returns the port to access WinRM.
      #
      # @param [Vagrant::Machine] machine
      # @return [Integer]
      def self.winrm_port(machine, local = true)
        host_port = machine.config.winrm.port
        if machine.config.winrm.guest_port
          # If we're not requesting a local port, return
          # the guest port directly.
          return machine.config.winrm.guest_port unless local

          # Search by guest port if we can. We use a provider capability
          # if we have it. Otherwise, we just scan the Vagrantfile defined
          # ports.
          port = nil
          if machine.provider.capability?(:forwarded_ports)
            port = winrm_port_by_capability(machine)
            # break
          end

          port = winrm_port_by_vagrantfile(machine) unless port

          # Set it if we found it
          host_port = port if port
        end

        host_port
      end

      def self.winrm_port_by_capability(machine)
        machine.provider.capability(:forwarded_ports).each do |host, guest|
          return host if guest == machine.config.winrm.guest_port
        end
      end

      def self.winrm_port_by_vagrantfile(machine)
        machine.config.vm.networks.each do |type, netopts|
          next unless type == :forwarded_port
          next unless netopts[:host]
          return netopts[:host] if netopts[:guest] == machine.config.winrm.guest_port
        end
      end
    end
  end
end