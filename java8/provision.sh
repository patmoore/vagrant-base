#!/bin/sh
# see http://stackoverflow.com/a/32944272/20161
sudo add-apt-repository ppa:webupd8team/java
# most happen after the adding of the repo
sudo apt-get update -y
sudo apt-get install software-properties-common
sudo apt-get install -y oracle-java8-installer
sudo update-java-alternatives --set java-8-oracle

