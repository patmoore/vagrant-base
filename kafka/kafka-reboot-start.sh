#!/bin/sh
### BEGIN INIT INFO
# Provides:          scriptname
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start zookeeper and kafka at boot time
# Description:       zookeeper and kafka
### END INIT INFO
# see https://wiki.debian.org/LSBInitScripts

export KAFKA_HOME=/usr/local/kafka
export PATH=$KAFKA_HOME/bin:$PATH
export zookeeper_connect=localhost:2181
kafka_server_properties=/usr/local/kafka/config/local.server.properties
$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties &
sleep 3
$KAFKA_HOME/bin/kafka-server-start.sh ${kafka_server_properties} &

