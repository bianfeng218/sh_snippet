#!/bin/sh
source ../config.sh
cd $SOFTWARE_CONTEXT
tar zxvf $SOURCE_MAVEN.tar.gz
cd /usr/local
rm -fr maven
ln -s $SOFTWARE_CONTEXT/$SOURCE_MAVEN maven

cp ./maven.sh /etc/profile.d/maven.sh

source /etc/profile
mvn --version
