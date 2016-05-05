#!/bin/bash

# Create a new overlay network
docker -H 10.0.7.11:4000 network create my_shared_network

# Create a new shared volume
docker -H 10.0.7.11:4000 volume create --name shared-vol

# Start a Nginx container in the Swarm cluster
docker -H 10.0.7.11:4000 run -d -p 80:80 --net my_shared_network -v shared-vol:/usr/share/nginx/html --name nginx1 nginx

# Copy our index.html file to be served by the Nginx container
docker -H 10.0.7.11:4000 cp index.html nginx1:/usr/share/nginx/html/

# Start another Nginx container
docker -H 10.0.7.11:4000 run -d -p 80:80 --net my_shared_network -v shared-vol:/usr/share/nginx/html --name nginx2 nginx
