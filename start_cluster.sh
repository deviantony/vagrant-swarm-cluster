#!/bin/bash

SWARM_VERSION=1.2.0

# Run Consul server on each node
echo "Starting Consul containers..."
docker -H 10.0.7.11:2375 run -d --restart always --name consul1 --net host consul agent -server -bind 10.0.7.11 -client 10.0.7.11 -retry-join 10.0.7.11 -retry-join 10.0.7.12 -retry-join 10.0.7.13 -bootstrap-expect 3
docker -H 10.0.7.12:2375 run -d --restart always --name consul2 --net host consul agent -server -bind 10.0.7.12 -client 10.0.7.12 -retry-join 10.0.7.11 -retry-join 10.0.7.12 -retry-join 10.0.7.13 -bootstrap-expect 3
docker -H 10.0.7.13:2375 run -d --restart always --name consul3 --net host consul agent -server -bind 10.0.7.13 -client 10.0.7.13 -retry-join 10.0.7.11 -retry-join 10.0.7.12 -retry-join 10.0.7.13 -bootstrap-expect 3

# Run a Swarm manager node (HA enabled)
echo "Starting Swarm manager..."
docker -H 10.0.7.11:2375 run -d --restart always -p 4000:4000 --name swarm_manager swarm:${SWARM_VERSION} manage -H :4000 --replication --advertise 10.0.7.11:2375 consul://10.0.7.11:8500

# Run the first and second Swarm nodes
echo "Starting Swarm node #1..."
docker -H 10.0.7.12:2375 run -d --restart always --name swarm_node1 swarm:${SWARM_VERSION} join --heartbeat 20s --ttl 30s --advertise 10.0.7.12:2375 consul://10.0.7.12:8500
echo "Starting Swarm node #2..."
docker -H 10.0.7.13:2375 run -d --restart always --name swarm_node2 swarm:${SWARM_VERSION} join --heartbeat 20s --ttl 30s --advertise 10.0.7.13:2375 consul://10.0.7.13:8500

echo "Waiting for the nodes to join the cluster..."
# Wait for the nodes to join the cluster
sleep 20

# Swarm cluster status
docker -H 10.0.7.11:4000 info
