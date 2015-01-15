# Vagrant-WinRM-S

A Vagrant communicator that uses `winrm-s` to communicate over winrm. Notably, allows for SSPI authentication of domain accounts when using a Windows host.

## Installation

```ruby
vagrant plugin install vagrant-winrm-s
```

Or, to install and test a locally-developed version:
```ruby
$ rake install
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vagrant-winrm-s/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
