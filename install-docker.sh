#!/bin/bash

export PATH=$PATH:/usr/bin
# install docker
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo add-apt-repository 'deb https://apt.dockerproject.org/repo ubuntu-trusty main'
sudo apt-get update
sudo apt-get -y install docker-engine

# Swarm kit directory
mkdir -p /opt/swarmkit/bin
