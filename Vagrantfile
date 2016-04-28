 $enable_docker_tcp_script = <<SCRIPT
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"' | tee -a /etc/default/docker;
service docker restart;
SCRIPT

$prepare_swarm_node_script = <<SCRIPT
rm -rf /etc/docker/key.json
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://10.0.7.10:8500 --cluster-advertise=eth1:2375"' | tee -a /etc/default/docker;
service docker restart;
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.define "consul" do |config|
    config.vm.box = "box-cutter/ubuntu1404-docker"
    config.vm.hostname = "consul"
    config.vm.network "private_network", ip: "10.0.7.10"
    config.vm.provision "shell", inline: $enable_docker_tcp_script
  end
  config.vm.define "swarm_manager" do |config|
    config.vm.box = "box-cutter/ubuntu1404-docker"
    config.vm.hostname = "swarm-manager"
    config.vm.network "private_network", ip: "10.0.7.11"
    config.vm.provision "shell", inline: $prepare_swarm_node_script
  end

  config.vm.define "swarm_node1" do |config|
    config.vm.box = "box-cutter/ubuntu1404-docker"
    config.vm.hostname = "swarm-node1"
    config.vm.network "private_network", ip: "10.0.7.12"
    config.vm.provision "shell", inline: $prepare_swarm_node_script
  end

  config.vm.define "swarm_node2" do |config|
    config.vm.box = "box-cutter/ubuntu1404-docker"
    config.vm.hostname = "swarm-node2"
    config.vm.network "private_network", ip: "10.0.7.13"
    config.vm.provision "shell", inline: $prepare_swarm_node_script
  end
end
