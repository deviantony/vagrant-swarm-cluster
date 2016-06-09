#!/bin/bash

SWARM_VERSION=1.2.0

# Run a Consul server on the first three nodes
echo "Starting Consul containers..."
docker -H 10.0.7.10:2375 run -d --restart always --name consul1 --net host \
-e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-e 'CONSUL_CLIENT_INTERFACE=eth1' -e 'CONSUL_BIND_INTERFACE=eth1' \
consul agent -server -ui -bootstrap-expect 3

docker -H 10.0.7.11:2375 run -d --restart always --name consul2 --net host \
-e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-e 'CONSUL_CLIENT_INTERFACE=eth1' -e 'CONSUL_BIND_INTERFACE=eth1' \
consul agent -server -retry-join 10.0.7.10

docker -H 10.0.7.12:2375 run -d --restart always --name consul3 --net host \
-e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
-e 'CONSUL_CLIENT_INTERFACE=eth1' -e 'CONSUL_BIND_INTERFACE=eth1' \
consul agent -server -retry-join 10.0.7.10

# Run a Consul agent on last node
docker -H 10.0.7.13:2375 run -d --restart always --name consul4 --net host \
-e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' \
-e 'CONSUL_CLIENT_INTERFACE=eth1' -e 'CONSUL_BIND_INTERFACE=eth1' \
consul agent -retry-join 10.0.7.10

# Run Swarm managers (HA enabled)
echo "Starting Swarm manager..."
docker -H 10.0.7.10:2375 run -d --restart always -p 4000:4000 --name swarm_manager \
swarm:${SWARM_VERSION} manage -H :4000 --replication --advertise 10.0.7.10:4000 consul://10.0.7.10:8500

echo "Starting Swarm replica..."
docker -H 10.0.7.11:2375 run -d --restart always -p 4000:4000 --name swarm_replica \
swarm:${SWARM_VERSION} manage -H :4000 --replication --advertise 10.0.7.11:4000 consul://10.0.7.11:8500

# Run the first and second Swarm nodes
echo "Starting Swarm node #1..."
docker -H 10.0.7.12:2375 run -d --restart always --name swarm_node1 \
swarm:${SWARM_VERSION} join --heartbeat 20s --ttl 30s --advertise 10.0.7.12:2375 consul://10.0.7.12:8500

echo "Starting Swarm node #2..."
docker -H 10.0.7.13:2375 run -d --restart always --name swarm_node2 \
swarm:${SWARM_VERSION} join --heartbeat 20s --ttl 30s --advertise 10.0.7.13:2375 consul://10.0.7.13:8500

# Swarm cluster status
docker -H 10.0.7.10:4000 info
