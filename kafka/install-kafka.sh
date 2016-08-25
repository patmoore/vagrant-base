#!/bin/sh
scripts_dir=/vagrant
ip_address=$($scripts_dir/ipaddress.sh)
. $scripts_dir/versions.sh
current_dir=`pwd`
vagrant_downloads=/vagrant/downloads

KAFKA_BASE=kafka_2.11-${KAFKA_VER}
if [ ! -d "${KAFKA_BASE}" ] ; then
  if [ ! -f "${vagrant_downloads}/${KAFKA_BASE}.tgz" ] ; then 
    (cd ${vagrant_downloads} ; curl -O https://archive.apache.org/dist/kafka/${KAFKA_VER}/${KAFKA_BASE}.tgz )
  fi
  tar -zxf ${vagrant_downloads}/${KAFKA_BASE}.tgz 
fi
sudo rm -rf /usr/local/kafka
sudo ln -s `pwd`/${KAFKA_BASE} /usr/local/kafka
zookeeper_connect=localhost:2181
#mv /usr/local/kafka/config/server.properties /usr/local/kafka/config/server.properties.orig
#sed \
#  -e "s/^#host.name=.*$/host.name=${ip_address}/" \
#  -e "s/^host.name=.*$/host.name=${ip_address}/" \
#  -e "s/^zookeeper.connect=.*/zookeeper.connect=${zookeeper_connect}/" \
# /usr/local/kafka/config/server.properties.orig > /usr/local/kafka/config/server.properties
#

echo "export KAFKA_HOME=/usr/local/kafka" >> .bashrc.x.sh
echo 'export PATH=$KAFKA_HOME/bin:$PATH' >> .bashrc.x.sh
echo "alias zk-start=\$KAFKA_HOME/bin/zookeeper-server-start.sh \$KAFKA_HOME/config/zookeeper.properties"
echo "alias kf-start='\$KAFKA_HOME/bin/kafka-server-start.sh \$KAFKA_HOME/config/server.properties &'" >> .bashrc.x.sh
echo "alias kf-stop='\$KAFKA_HOME/bin/kafka-server-stop.sh \$KAFKA_HOME/config/server.properties &'" >> .bashrc.x.sh
echo "alias kf-list='\$KAFKA_HOME/bin/kafka-topics.sh --list --zookeeper ${zookeeper_connect}'" >> .bashrc.x.sh
echo "alias kf-create-topic='\$KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper \${zookeeper_connect} --replication-factor 1 --partition 1 --topic '" >> .bashrc.x.sh
echo ". .bashrc.x.sh" >> .bashrc