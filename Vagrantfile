Vagrant.configure("2") do |config|
  config.vm.box = "mbrush/centos7-puppet"
  config.vm.network "private_network", ip: "192.168.50.11"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.provision "shell" do |s|
    s.inline = "yum install -y rsync curl tar wget iproute initscripts && ln -s /vagrant/ /etc/puppet/modules/gogs && ln -s /vagrant/examples/ /etc/puppet/manifests && puppet module install puppetlabs/stdlib && puppet apply --verbose /etc/puppet/manifests/init.pp"
  end
end