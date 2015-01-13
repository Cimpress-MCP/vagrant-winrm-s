module VagrantPlugins
  module CommunicatorWinRM
    module Errors
      # A convenient superclass for all our errors.
      class WinRMSError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_winrm.errors")
      end

      class AuthError < WinRMSError
        error_key(:auth_error)
      end

      class ExecutionError < WinRMSError
        error_key(:execution_error)
      end

      class InvalidShell < WinRMSError
        error_key(:invalid_shell)
      end

      class WinRMNotReady < WinRMSError
        error_key(:winrm_not_ready)
      end

      class WinRMFileTransferError < WinRMSError
        error_key(:winrm_file_transfer_error)
      end
    end
  end
end
