$prepare_nfs_server_script = <<SCRIPT
apt-get update && apt-get install -y nfs-kernel-server;
mkdir /var/nfs;
echo '/var/nfs 10.0.7.12(rw,sync,no_subtree_check,no_root_squash)' | tee -a /etc/exports;
echo '/var/nfs 10.0.7.13(rw,sync,no_subtree_check,no_root_squash)' | tee -a /etc/exports;
exportfs -a && service nfs-kernel-server start;
SCRIPT

$prepare_consul_server_script = <<SCRIPT
apt-get update && apt-get upgrade -y docker-engine;
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"' | tee -a /etc/default/docker;
service docker restart;
SCRIPT

$prepare_swarm_manager_script = <<SCRIPT
apt-get update && apt-get upgrade -y docker-engine;
rm -rf /etc/docker/key.json
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://10.0.7.10:8500 --cluster-advertise=eth1:2375"' | tee -a /etc/default/docker;
service docker restart;
SCRIPT

$prepare_swarm_node_script = <<SCRIPT
apt-get update && apt-get upgrade -y docker-engine nfs-kernel-server nfs-common;
service docker stop;
mkdir -pv /var/nfs/volumes && mount 10.0.7.9:/var/nfs /var/nfs/volumes;
echo '10.0.7.9:/var/nfs /var/nfs/volumes nfs rw,defaults 0 2' | tee -a /etc/fstab;
rm -rf /etc/docker/key.json
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://10.0.7.10:8500 --cluster-advertise=eth1:2375"' | tee -a /etc/default/docker;
wget https://github.com/rancher/convoy/releases/download/v0.4.3/convoy.tar.gz -P /tmp/;
tar xvf /tmp/convoy.tar.gz -C /tmp;
cp /tmp/convoy/convoy /tmp/convoy/convoy-pdata_tools /usr/local/bin/;
mkdir -p /etc/docker/plugins/;
echo 'unix:///var/run/convoy/convoy.sock' | tee -a /etc/docker/plugins/convoy.spec;
mkdir /opt/convoy;
wget -O /etc/init.d/convoy https://gist.githubusercontent.com/deviantony/557984d62e867e6f505577b207db6ffc/raw/72d1f5406960ee1c7a63a7af24b075f3bbac3220/convoy;
chmod 755 /etc/init.d/convoy;
update-rc.d convoy defaults;
service convoy start;
service docker start;
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.define "nfs-server" do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "nfs-server"
    config.vm.network "private_network", ip: "10.0.7.9"
    config.vm.provision "shell", inline: $prepare_nfs_server_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end
  config.vm.define "consul" do |config|
    config.vm.box = "box-cutter/ubuntu1404-docker"
    config.vm.hostname = "consul"
    config.vm.network "private_network", ip: "10.0.7.10"
    config.vm.provision "shell", inline: $prepare_consul_server_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end
  config.vm.define "swarm_manager" do |config|
    config.vm.box = "box-cutter/ubuntu1404-docker"
    config.vm.hostname = "swarm-manager"
    config.vm.network "private_network", ip: "10.0.7.11"
    config.vm.provision "shell", inline: $prepare_swarm_manager_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "swarm_node1" do |config|
    config.vm.box = "box-cutter/ubuntu1404-docker"
    config.vm.hostname = "swarm-node1"
    config.vm.network "private_network", ip: "10.0.7.12"
    config.vm.provision "shell", inline: $prepare_swarm_node_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "swarm_node2" do |config|
    config.vm.box = "box-cutter/ubuntu1404-docker"
    config.vm.hostname = "swarm-node2"
    config.vm.network "private_network", ip: "10.0.7.13"
    config.vm.provision "shell", inline: $prepare_swarm_node_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end
end
