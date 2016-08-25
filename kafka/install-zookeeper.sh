#!/bin/sh
scripts_dir=/vagrant
ip_address=$($scripts_dir/ipaddress.sh)
. $scripts_dir/versions.sh
current_dir=`pwd`
vagrant_downloads=/vagrant/downloads

if [ ! -d "zookeeper-${ZOOKEEPER_VER}" ] ; then
  if [ ! -f "${vagrant_downloads}/zookeeper-${ZOOKEEPER_VER}.tar.gz" ] ; then 
    (cd ${vagrant_downloads}; curl -O http://apache.claz.org/zookeeper/zookeeper-${ZOOKEEPER_VER}/zookeeper-${ZOOKEEPER_VER}.tar.gz )
  fi
  tar -zxf ${vagrant_downloads}/zookeeper-${ZOOKEEPER_VER}.tar.gz
fi
sudo rm -rf /usr/local/zookeeper
sudo ln -s `pwd`/zookeeper-${ZOOKEEPER_VER} /usr/local/zookeeper
#Edit the Zookeeper configuration file, /usr/local/zookeeper/zookeeper-3.4.6/conf/zoo.cfg
dataDir=/var/zookeeper/data
sed -e "s#dataDir=.*#dataDir=${dataDir}#" ./zookeeper-${ZOOKEEPER_VER}/conf/zoo_sample.cfg > ./zookeeper-${ZOOKEEPER_VER}/conf/zoo.cfg
echo "server.1=${ip_address}:2888:3888" >> ./zookeeper-${ZOOKEEPER_VER}/conf/zoo.cfg
sudo mkdir -p ${dataDir} 
sudo chmod a+rwX ${dataDir}
echo "1" > ${dataDir}/myid


echo "export ZK_HOME=/usr/local/zookeeper" > .bashrc.x.sh
echo "export KAFKA_HOME=/usr/local/kafka" >> .bashrc.x.sh
echo 'export PATH=$ZK_HOME/bin:$KAFKA_HOME/bin:$PATH' >> .bashrc.x.sh
echo "alias zk='sudo \$ZK_HOME/bin/zkServer.sh'">> .bashrc.x.sh
echo "alias kf-start='sudo \$KAFKA_HOME/bin/kafka-server-start.sh \$KAFKA_HOME/config/server.properties &'" >> .bashrc.x.sh
echo "alias kf-list='sudo \$KAFKA_HOME/bin/kafka-list-topic.sh --zookeeper ${zookeeper_connect}'" >> .bashrc.x.sh
echo "alias kf-create-topic='kafka-topics.sh --create --zookeeper \${zookeeper_connect} --replication-factor 1 --partition 1 --topic '" >> .bashrc.x.sh
echo ". .bashrc.x.sh" >> .bashrc
. .bashrc
zk start
