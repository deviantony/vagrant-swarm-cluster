#!/bin/bash

# Create a new overlay network
docker -H 10.0.7.11:4000 network create my-shared-network

# Create a new shared volume
docker -H 10.0.7.11:4000 volume create -d local-persist -o mountpoint=/var/nfs/volumes/nginx --name shared-vol-nginx

# Start a Nginx container in the Swarm cluster
docker -H 10.0.7.11:4000 run -d --restart always -p 80:80 --net my-shared-network -v shared-vol-nginx:/usr/share/nginx/html --name nginx1 nginx

# Copy our index.html file to be served by the Nginx container
docker -H 10.0.7.11:4000 cp index.html nginx1:/usr/share/nginx/html/

# Start another Nginx container
docker -H 10.0.7.11:4000 run -d --restart always -p 80:80 --net my-shared-network -v shared-vol-nginx:/usr/share/nginx/html --name nginx2 nginx
