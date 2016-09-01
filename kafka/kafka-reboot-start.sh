#!/bin/sh
export KAFKA_HOME=/usr/local/kafka
export PATH=$KAFKA_HOME/bin:$PATH
export zookeeper_connect=localhost:2181
kafka_server_properties=/usr/local/kafka/config/local.server.properties
$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties &
sleep 3
$KAFKA_HOME/bin/kafka-server-start.sh ${kafka_server_properties} &

