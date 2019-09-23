$setup_docker = <<SCRIPT
apt-get update;
DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common;
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -;
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update;
apt-get install -y docker-ce docker-ce-cli containerd.io;

sed -i 's|-H fd://|-H fd:// -H tcp://0.0.0.0:2375|g' /lib/systemd/system/docker.service;
systemctl daemon-reload && systemctl restart docker.service;
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.define "swarmnode1" do |config|
    config.vm.box = "ubuntu/bionic64"
    config.vm.hostname = "swarmnode1"
    config.vm.network "private_network", ip: "10.0.7.10"
    config.vm.provision "shell", inline: $setup_docker
  end

  config.vm.define "swarmnode2" do |config|
    config.vm.box = "ubuntu/bionic64"
    config.vm.hostname = "swarmnode2"
    config.vm.network "private_network", ip: "10.0.7.11"
    config.vm.provision "shell", inline: $setup_docker
  end
end
