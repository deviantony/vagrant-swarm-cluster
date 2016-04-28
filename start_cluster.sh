#!/bin/bash

# Run a Consul container
docker -H 10.0.7.10:2375 run -d --restart always -p 8500:8500 --name consul progrium/consul -server -bootstrap

# Run a Swarm manager node (HA enabled)
docker -H 10.0.7.11:2375 run -d --restart always -p 4000:4000 --name swarm_manager swarm manage -H :4000 --replication --advertise 10.0.7.11:2375 consul://10.0.7.10:8500

# Run the first and second Swarm nodes
docker -H 10.0.7.12:2375 run -d --restart always --name swarm_node1 swarm join --advertise 10.0.7.12:2375 consul://10.0.7.10:8500
docker -H 10.0.7.13:2375 run -d --restart always --name swarm_node2 swarm join --advertise 10.0.7.13:2375 consul://10.0.7.10:8500

# Swarm cluster status
docker -H 10.0.7.11:4000 info
