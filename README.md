# Vagrant Swarm cluster

Run a Swarm cluster locally using Vagrant.

This will create and setup 2 Vagrant machines in a private network (10.0.7.0/24):

* Swarm node 1 (manager): 10.0.7.10
* Swarm node 2 (worker): 10.0.7.11

# Requirements

Install [Vagrant][vagranthome] and [Docker][dockerhome] on your machine.

Ensure you have a valid [Vagrant provider][vagrantprovider] installed.

# Setup

## Boot Vagrant machines

The first thing you must do is to start the Vagrant machines using your favorite provider:

```
$ git clone https://github.com/deviantony/vagrant-swarm-cluster.git
$ cd vagrant-swarm-cluster
$ vagrant up --provider virtualbox
```

Supported providers:

* virtualbox

## Bootstrap script

If you're on Unix, you can execute the `start_cluster.sh` script to bootstrap the Swarm cluster:

```shell
$ chmod +x start_cluster.sh
$ ./start_cluster.sh
```

[vagranthome]: https://www.vagrantup.com/docs/installation/  "Vagrant installation"
[vagrantprovider]: https://www.vagrantup.com/docs/providers/ "Vagrant providers"
[dockerhome]: https://docs.docker.com/engine/installation/  "Docker installation"
