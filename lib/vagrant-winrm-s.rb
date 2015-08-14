require "vagrant-winrm-s/version"
require "vagrant-winrm-s/plugin"

module VagrantPlugins
  module CommunicatorWinRM
    lib_path = Pathname.new(File.expand_path("../vagrant-winrm-s", __FILE__))
    autoload :Communicator, lib_path.join("communicator")

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end
