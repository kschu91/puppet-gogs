Vagrant.configure("2") do |config|
  config.vm.box = "mbrush/centos7-puppet"
  config.vm.network "private_network", ip: "192.168.50.11"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.provision "shell" do |s|
    s.inline = "yum install -y crontabs rsync curl tar wget iproute initscripts"
  end
end