#!/bin/sh
cd /export/servers
scp root@192.168.147.32:/export/servers/apache-maven-3.0.4-bin.tar.gz .

tar zxvf apache-maven-3.0.4-bin.tar.gz
cd /usr/local
ln -s /export/servers/apache-maven-3.0.4 maven

scp root@192.168.147.32:/etc/profile.d/maven.sh /etc/profile.d/maven.sh

source /etc/profile
mvn
