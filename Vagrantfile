$prepare_docker_engine_script = <<SCRIPT
apt-get update;
apt-get install -y apt-transport-https ca-certificates;
curl -fsSL https://apt.dockerproject.org/gpg | apt-key add -
add-apt-repository "deb https://apt.dockerproject.org/repo/ ubuntu-$(lsb_release -cs) main"
apt-get update && apt-get install -y docker-engine;
service docker stop;
rm -rf /etc/docker/key.json
echo 'DOCKER_OPTS="-H 0.0.0.0:2375 -H unix:///var/run/docker.sock"' | tee -a /etc/default/docker;
service docker start;
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.define "swarm_manager_113" do |config|
    config.vm.box = "deviantony/ubuntu-14.04-docker"
    config.vm.hostname = "swarm-manager-113"
    config.vm.network "private_network", ip: "10.0.7.10"
    config.vm.provision "shell", inline: $prepare_docker_engine_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "swarm_node1_113" do |config|
    config.vm.box = "deviantony/ubuntu-14.04-docker"
    config.vm.hostname = "swarm-node1-113"
    config.vm.network "private_network", ip: "10.0.7.11"
    config.vm.provision "shell", inline: $prepare_docker_engine_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "swarm_node2_113" do |config|
    config.vm.box = "deviantony/ubuntu-14.04-docker"
    config.vm.hostname = "swarm-node2-113"
    config.vm.network "private_network", ip: "10.0.7.12"
    config.vm.provision "shell", inline: $prepare_docker_engine_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end
end
