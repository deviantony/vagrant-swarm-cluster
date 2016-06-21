#!/bin/bash

echo "Destroying Consul containers..."
docker -H 10.0.7.10:2375 rm -f consul1
docker -H 10.0.7.11:2375 rm -f consul2

echo "Destroying Swarm manager..."
docker -H 10.0.7.10:2375 rm -f swarm_manager

echo "Destroying Swarm node..."
docker -H 10.0.7.11:2375 rm -f swarm_node
