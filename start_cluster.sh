#!/bin/bash

echo "Starting manager..."
docker -H 10.0.7.10:2375 swarm init --advertise-addr 10.0.7.10

echo "Retrieve manager token..."
TOKEN=$(docker -H 10.0.7.10:2375 swarm join-token -q manager)

echo "Starting nodes..."
docker -H 10.0.7.11:2375 swarm join --token "${TOKEN}" 10.0.7.10:2377
docker -H 10.0.7.12:2375 swarm join --token "${TOKEN}" 10.0.7.10:2377


docker -H 10.0.7.10:2375 info
