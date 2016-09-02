#!/bin/sh
scripts_dir=/vagrant
ip_address=$($scripts_dir/ipaddress.sh)
. $scripts_dir/versions.sh
current_dir=`pwd`
vagrant_downloads=/vagrant/downloads

KAFKA_BASE=kafka_2.11-${KAFKA_VER}
if [ ! -d "${KAFKA_BASE}" ] ; then
  if [ ! -f "${vagrant_downloads}/${KAFKA_BASE}.tgz" ] ; then 
    (mkdir -p ${vagrant_downloads}; cd ${vagrant_downloads} ; curl -O https://archive.apache.org/dist/kafka/${KAFKA_VER}/${KAFKA_BASE}.tgz )
  fi
  tar -zxf ${vagrant_downloads}/${KAFKA_BASE}.tgz 
fi
rm -rf /usr/local/kafka
ln -s `pwd`/${KAFKA_BASE} /usr/local/kafka
mkdir -p ${KAFKA_BASE}/logs
chmod a+rwx ${KAFKA_BASE}/logs
zookeeper_connect=localhost:2181
export KAFKA_HOME=/usr/local/kafka

kafka_server_properties=/usr/local/kafka/config/local.server.properties
cp /usr/local/kafka/config/server.properties ${kafka_server_properties}
cat<<EOM >> /usr/local/kafka/config/local.server.properties
host.name=${ip_address}
advertised.host.name=${ip_address}
listeners=PLAINTEXT://${ip_address}:9092
EOM

# TODO need to change the host.name, advertised.host.name and listeners
# http://davidssysadminnotes.blogspot.com/2016/05/network-access-kafka.html
# http://stackoverflow.com/questions/38260091/kafka-0-10-java-client-timeoutexception-batch-containing-1-records-expired

#sed \
#  -e "s/^#host.name=.*$/host.name=${ip_address}/" \
#  -e "s/^host.name=.*$/host.name=${ip_address}/" \
#  -e "s/^zookeeper.connect=.*/zookeeper.connect=${zookeeper_connect}/" \
# /usr/local/kafka/config/server.properties.orig > /usr/local/kafka/config/server.properties
#

ln -s /vagrant/kafka-reboot-start.sh /etc/init.d/kafka-reboot-start.sh
update-rc.d kafka-reboot-start.sh defaults

echo "export KAFKA_HOME=/usr/local/kafka" > .bashrc.x.sh
echo 'export PATH=$KAFKA_HOME/bin:$PATH' >> .bashrc.x.sh
echo 'export zookeeper_connect=localhost:2181' >> .bashrc.x.sh
echo "alias zk-start='\$KAFKA_HOME/bin/zookeeper-server-start.sh \$KAFKA_HOME/config/zookeeper.properties &' " >> .bashrc.x.sh
echo "alias kf-start='\$KAFKA_HOME/bin/kafka-server-start.sh ${kafka_server_properties} &'" >> .bashrc.x.sh
echo "alias kf-stop='\$KAFKA_HOME/bin/kafka-server-stop.sh ${kafka_server_properties} &'" >> .bashrc.x.sh
echo "alias kf-list='\$KAFKA_HOME/bin/kafka-topics.sh --list --zookeeper ${zookeeper_connect}'" >> .bashrc.x.sh
echo "alias kf-create-topic='\$KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper ${zookeeper_connect} --replication-factor 1 --partition 1 --topic '" >> .bashrc.x.sh
echo ". .bashrc.x.sh" >> .bashrc
mkdir $KAFKA_HOME/logs
chmod a+rwx $KAFKA_HOME/logs
