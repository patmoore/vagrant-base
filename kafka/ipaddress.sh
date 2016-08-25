#!/bin/sh
# determine own ipaddress
ifconfig eth1 | sed -n -r "s/^.*inet addr:([0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}).*$/\1/p"
