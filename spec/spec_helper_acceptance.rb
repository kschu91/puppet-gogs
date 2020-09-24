require 'beaker-puppet'
require 'beaker-rspec'
require 'beaker/puppet_install_helper'

install_puppet_agent_on hosts, {}

RSpec.configure do |c|
  # Project root
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  module_name = module_root.split('-').last

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => module_root, :module_name => module_name)

    pp = <<-EOS
      package { "git": ensure => "latest", }
    EOS

    apply_manifest_on(hosts, pp, :catch_failures => false)

    hosts.each do |host|
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','kschu91-puppetstats'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
