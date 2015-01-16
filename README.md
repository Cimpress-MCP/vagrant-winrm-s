# Vagrant-WinRM-S

A Vagrant communicator that uses the `winrm-s` gem to communicate over winrm. Notably, allows for SSPI authentication of domain accounts when using a Windows host.

## Installation

```bash
$ vagrant plugin install vagrant-winrm-s
```

Or, to install and test a locally-developed version:
```bash
$ rake install
```

## Use

Vargrant-WinRM-S uses the `:winrm` communicator built in to vagrant as
its base, so existing Vagrantfiles should continue to work with this plugin.

The extra configuration value that gets exposed is `config.winrm.transport`.
The default transport is `:plaintext`. This is for basic authentication of
local accounts over HTTP. The plugin exposes the `:sspinegotiate`
transport from the `winrm-s` gem in order to do Negotiate authentication
of domain accounts (still only over HTTP).

An example Vagrant communicator block for `:sspinegotiate` would look something
like:

```ruby
config.vm.provision "shell", inline: "echo Hello, World!"
config.vm.communicator = :winrm
config.winrm.username = "domain\\auser"
config.winrm.password = "It5@p455w0rd!"
config.winrm.transport = :sspinegotiate
```

### What about the SSL transport?

The `:ssl` transport is available and can be used to authenticate local accounts.
However, the versions of `WinRM` and `HTTPClient` bundled with Vagrant make it
difficult to ignore untrusted/self-signed certificates. But users with proper
certificates should have no problem.

## Setting up your server

For authentication of local accounts over HTTP, the `winrm quickconfig`
command should suffice. This will enable the HTTP listener for basic authentication.

In order to connect via the `:plaintext` transport, you should ensure that
`winrm/config/service/auth/Basic` and `winrm/config/service/AllowUnencrypted` are enabled.

```
winrm set winrm/config/service/auth @{Basic="true"}
winrm set winrm/config/service @{AllowUnencrypted="true"}
```

For the `:sspinegotiate` transport, ensure `winrm/config/service/auth/Negotiate` is true and `winrm/config/service/AllowUnencrypted` is false.

```
winrm set winrm/config/service/auth @{Negotiate="true"}
winrm set winrm/config/service @{AllowUnencrypted="false"}
```

See also:
* [MSDN article about configuring WinRM](http://msdn.microsoft.com/en-us/library/aa384372\(v=vs.85\).aspx)
* [WinRM gem](https://github.com/WinRb/WinRM/blob/master/README.md#troubleshooting)
* [WinRM-S gem](https://github.com/opscode/winrm-s/blob/master/README.md)

## Contributing

1. Fork it ( https://github.com/Cimpress-MCP/vagrant-winrm-s/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
