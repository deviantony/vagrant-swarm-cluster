# Vagrant Swarm cluster

Run a Swarm cluster locally using Vagrant.

This will create and setup 4 Vagrant machines in a private network (10.0.7.0/24):

* Swarm manager: 10.0.7.10
* Swarm replica: 10.0.7.11
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

## Hands-on

You can also execute the following commands to start the cluster.

### Service discovery

We'll start a Consul container on each node, we will create 3 consul servers and one consul agent.

Start a Consul *server* on the `swarm_manager` node:

```shell
docker -H 10.0.7.10:2375 run -d --restart always --name consul1 --net host \
-e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-e 'CONSUL_CLIENT_INTERFACE=eth1' -e 'CONSUL_BIND_INTERFACE=eth1' \
consul agent -server -ui -bootstrap-expect 3
```

Start a Consul *server* on the `swarm_replica` node:

```shell
docker -H 10.0.7.11:2375 run -d --restart always --name consul2 --net host \
-e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-e 'CONSUL_CLIENT_INTERFACE=eth1' -e 'CONSUL_BIND_INTERFACE=eth1' \
consul agent -server -retry-join 10.0.7.10
```

Start a Consul *server* on the `swarm_node1` node:

```shell
docker -H 10.0.7.12:2375 run -d --restart always --name consul3 --net host \
-e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-e 'CONSUL_CLIENT_INTERFACE=eth1' -e 'CONSUL_BIND_INTERFACE=eth1' \
consul agent -server -retry-join 10.0.7.10
```

Start a Consul *agent* on the `swarm_node2` node:

```shell
docker -H 10.0.7.13:2375 run -d --restart always --name consul4 --net host \
-e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' \
-e 'CONSUL_CLIENT_INTERFACE=eth1' -e 'CONSUL_BIND_INTERFACE=eth1' \
consul agent -retry-join 10.0.7.10
```

### Swarm

Start a Swarm manager on the `swarm_manager` node:

```shell
docker -H 10.0.7.10:2375 run -d --restart always -p 4000:4000 --name swarm_manager \
swarm:${SWARM_VERSION} manage -H :4000 --replication --advertise 10.0.7.10:4000 consul://10.0.7.10:8500
```

And one of the `swarm_replica` node:

```shell
docker -H 10.0.7.11:2375 run -d --restart always -p 4000:4000 --name swarm_replica \
swarm:${SWARM_VERSION} manage -H :4000 --replication --advertise 10.0.7.11:4000 consul://10.0.7.11:8500
```

And after that, start two Swarm nodes on `swarm_node1` and `swarm_node2` nodes respectively:

```shell
docker -H 10.0.7.12:2375 run -d --restart always --name swarm_node1 \
swarm:${SWARM_VERSION} join --heartbeat 20s --ttl 30s --advertise 10.0.7.12:2375 consul://10.0.7.12:8500

docker -H 10.0.7.13:2375 run -d --restart always --name swarm_node2 \
swarm:${SWARM_VERSION} join --heartbeat 20s --ttl 30s --advertise 10.0.7.13:2375 consul://10.0.7.13:8500
```

Finally, after a few time, check Swarm cluster status:

```shell
$ docker -H 10.0.7.10:4000 info
```

# Go further

Play !

## Networking

Create an overlay network in your Swarm cluster to allow communication between your containers in the cluster:

```shell
$ docker -H 10.0.7.10:4000 network create cluster-net
```

[vagranthome]: https://www.vagrantup.com/docs/installation/  "Vagrant installation"
[vagrantprovider]: https://www.vagrantup.com/docs/providers/ "Vagrant providers"
[dockerhome]: https://docs.docker.com/engine/installation/  "Docker installation"
