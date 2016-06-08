# Vagrant Swarm cluster

Run a Swarm cluster locally using Vagrant.

This will create and setup 4 Vagrant machines in a private network (10.0.7.0/24):

* Consul: 10.0.7.10
* Swarm manager: 10.0.7.11
* Swarm node 1: 10.0.7.12
* Swarm node 2: 10.0.7.13

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

## Commands

Or execute the following commands to start the cluster.

Start the Consul container:

```shell
$ docker -H 10.0.7.10:2375 run -d --restart always --net host -p 8500:8500 --name consul consul agent -bind 10.0.7.10 -client 10.0.7.10 -server -bootstrap-expect 1
```

Start a Swarm manager node:

```shell
$ docker -H 10.0.7.11:2375 run -d --restart always -p 4000:4000 --name swarm_manager swarm manage -H :4000 --replication --advertise 10.0.7.11:2375 consul://10.0.7.10:8500
```

Start two Swarm nodes:

```shell
$ docker -H 10.0.7.12:2375 run -d --restart always --name swarm_node1 swarm join --heartbeat 20s --ttl 30s --advertise 10.0.7.12:2375 consul://10.0.7.10:8500
$ docker -H 10.0.7.13:2375 run -d --restart always --name swarm_node2 swarm join --heartbeat 20s --ttl 30s --advertise 10.0.7.13:2375 consul://10.0.7.10:8500
```

Check Swarm cluster status:

```shell
$ docker -H 10.0.7.11:4000 info
```

# Go further

Play !

## Networking

Create an overlay network in your Swarm cluster to allow communication between your containers in the cluster:

```shell
$ docker -H 10.0.7.11:4000 network create cluster-network
```

[vagranthome]: https://www.vagrantup.com/docs/installation/  "Vagrant installation"
[vagrantprovider]: https://www.vagrantup.com/docs/providers/ "Vagrant providers"
[dockerhome]: https://docs.docker.com/engine/installation/  "Docker installation"
