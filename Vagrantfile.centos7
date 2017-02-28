Vagrant.configure("2") do |config|
  config.vm.box = "mbrush/centos7-puppet"
  config.vm.network "private_network", ip: "192.168.50.11"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.provision "shell" do |s|
    s.inline = "yum install -y puppet && ln -sf /vagrant /etc/puppet/modules/gogs && ln -sf /vagrant/examples /etc/puppet/manifests && puppet module install puppetlabs/stdlib --force && puppet apply --strict_variables --order=random --verbose --debug /vagrant/examples/gogs_custom_user.pp"
  end
end