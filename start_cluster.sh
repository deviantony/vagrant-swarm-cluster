#!/bin/bash

# Run Consul server on each node
echo "Starting Consul containers..."
docker -H 10.0.7.11:2375 run -d --restart always --name consul1 -e CONSUL_BIND_INTERFACE=eth0 --net host consul agent -server -retry-join 10.0.7.11 -retry-join 10.0.7.12 -retry-join 10.0.7.13 -bootstrap-expect 3
docker -H 10.0.7.12:2375 run -d --restart always --name consul2 -e CONSUL_BIND_INTERFACE=eth0 --net host consul agent -server -retry-join 10.0.7.11 -retry-join 10.0.7.12 -retry-join 10.0.7.13 -bootstrap-expect 3
docker -H 10.0.7.13:2375 run -d --restart always --name consul3 -e CONSUL_BIND_INTERFACE=eth0 --net host consul agent -server -retry-join 10.0.7.11 -retry-join 10.0.7.12 -retry-join 10.0.7.13 -bootstrap-expect 3

# Run a Swarm manager node (HA enabled)
echo "Starting Swarm manager..."
docker -H 10.0.7.11:2375 run -d --restart always -p 4000:4000 --name swarm_manager swarm manage -H :4000 --replication --advertise 10.0.7.11:2375 consul://localhost:8500

# Run the first and second Swarm nodes
echo "Starting Swarm node #1..."
docker -H 10.0.7.12:2375 run -d --restart always --name swarm_node1 swarm join --heartbeat 20s --ttl 30s --advertise 10.0.7.12:2375 consul://localhost:8500
echo "Starting Swarm node #2..."
docker -H 10.0.7.13:2375 run -d --restart always --name swarm_node2 swarm join --heartbeat 20s --ttl 30s --advertise 10.0.7.13:2375 consul://localhost:8500

echo "Waiting for the nodes to join the cluster..."
# Wait for the nodes to join the cluster
sleep 20

# Swarm cluster status
docker -H 10.0.7.11:4000 info
