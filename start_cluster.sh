#!/bin/bash

# Run a Consul container
echo "Starting Consul container..."
docker -H 10.0.7.10:2375 run -d --restart always --net host -p 8500:8500 --name consul consul agent -bind 10.0.7.10 -client 10.0.7.10 -server -bootstrap-expect 1

# Run a Swarm manager node (HA enabled)
echo "Starting Swarm manager..."
docker -H 10.0.7.11:2375 run -d --restart always -p 4000:4000 --name swarm_manager swarm manage -H :4000 --replication --advertise 10.0.7.11:2375 consul://10.0.7.10:8500

# Run the first and second Swarm nodes
echo "Starting Swarm node #1..."
docker -H 10.0.7.12:2375 run -d --restart always --name swarm_node1 swarm join --heartbeat 20s --ttl 30s --advertise 10.0.7.12:2375 consul://10.0.7.10:8500
echo "Starting Swarm node #2..."
docker -H 10.0.7.13:2375 run -d --restart always --name swarm_node2 swarm join --heartbeat 20s --ttl 30s --advertise 10.0.7.13:2375 consul://10.0.7.10:8500

echo "Waiting for the nodes to join the cluster..."
# Wait for the nodes to join the cluster
sleep 20

# Swarm cluster status
docker -H 10.0.7.11:4000 info
