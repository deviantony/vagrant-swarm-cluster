$prepare_swarm_manager_script = <<SCRIPT
apt-get update;
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce;
service docker stop;
rm -rf /etc/docker/key.json
echo '{ "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"], "cluster-store": "consul://10.0.7.10:8500", "cluster-advertise": "eth1:2375" }' | tee -a /etc/docker/daemon.json;
service docker start;
SCRIPT

$prepare_swarm_replica_script = <<SCRIPT
apt-get update;
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce;
service docker stop;
rm -rf /etc/docker/key.json
echo '{ "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"], "cluster-store": "consul://10.0.7.11:8500", "cluster-advertise": "eth1:2375" }' | tee -a /etc/docker/daemon.json;
service docker start;
SCRIPT

$prepare_swarm_node1_script = <<SCRIPT
apt-get update;
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce;
service docker stop;
rm -rf /etc/docker/key.json
echo '{ "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"], "cluster-store": "consul://10.0.7.12:8500", "cluster-advertise": "eth1:2375" }' | tee -a /etc/docker/daemon.json;
service docker start;
SCRIPT

$prepare_swarm_node2_script = <<SCRIPT
apt-get update;
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && apt-get install -y docker-ce;
service docker stop;
rm -rf /etc/docker/key.json
echo '{ "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"], "cluster-store": "consul://10.0.7.13:8500", "cluster-advertise": "eth1:2375" }' | tee -a /etc/docker/daemon.json;
service docker start;
SCRIPT


Vagrant.configure(2) do |config|
  config.vm.define "swarm_ha_manager" do |config|
    config.vm.box = "deviantony/ubuntu-14.04-docker"
    config.vm.hostname = "swarm-manager"
    config.vm.network "private_network", ip: "10.0.7.10"
    config.vm.provision "shell", inline: $prepare_swarm_manager_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "swarm_ha_replica" do |config|
    config.vm.box = "deviantony/ubuntu-14.04-docker"
    config.vm.hostname = "swarm-replica"
    config.vm.network "private_network", ip: "10.0.7.11"
    config.vm.provision "shell", inline: $prepare_swarm_replica_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "swarm_ha_node1" do |config|
    config.vm.box = "deviantony/ubuntu-14.04-docker"
    config.vm.hostname = "swarm-node1"
    config.vm.network "private_network", ip: "10.0.7.12"
    config.vm.provision "shell", inline: $prepare_swarm_node1_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "swarm_ha_node2" do |config|
    config.vm.box = "deviantony/ubuntu-14.04-docker"
    config.vm.hostname = "swarm-node2"
    config.vm.network "private_network", ip: "10.0.7.13"
    config.vm.provision "shell", inline: $prepare_swarm_node2_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end
end
