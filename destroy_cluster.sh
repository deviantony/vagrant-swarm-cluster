#!/bin/bash

echo "Destroying Swarm cluster..."
docker -H 10.0.7.10:2375 swarm leave --force
docker -H 10.0.7.11:2375 swarm leave --force
docker -H 10.0.7.12:2375 swarm leave --force
