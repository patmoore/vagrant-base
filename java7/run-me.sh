#!/bin/sh
vagrant up
box_name=java.box
vagrant package --output ${box_name}
vagrant box add java7box ${box_name}
