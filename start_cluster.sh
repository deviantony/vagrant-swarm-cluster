#!/bin/bash

SWARM_VERSION=1.2.0

# Run a Consul server on the first node
echo "Starting Consul containers..."
docker -H 10.0.7.10:2375 run -d --restart always --name consul1 --net host \
-e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-e 'CONSUL_CLIENT_INTERFACE=eth1' -e 'CONSUL_BIND_INTERFACE=eth1' \
consul agent -server -ui -bootstrap-expect 1

# Run a Consul agent on the second node
docker -H 10.0.7.11:2375 run -d --restart always --name consul3 --net host \
-e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-e 'CONSUL_CLIENT_INTERFACE=eth1' -e 'CONSUL_BIND_INTERFACE=eth1' \
consul agent -retry-join 10.0.7.10

# Run Swarm manager
echo "Starting Swarm manager..."
docker -H 10.0.7.10:2375 run -d --restart always -p 4000:4000 --name swarm_manager \
swarm:${SWARM_VERSION} manage -H :4000 --replication --advertise 10.0.7.10:4000 consul://10.0.7.10:8500

# Run Swarm node
echo "Starting Swarm node..."
docker -H 10.0.7.11:2375 run -d --restart always --name swarm_node1 \
swarm:${SWARM_VERSION} join --heartbeat 20s --ttl 30s --advertise 10.0.7.11:2375 consul://10.0.7.11:8500

# Swarm cluster status
docker -H 10.0.7.10:4000 info
