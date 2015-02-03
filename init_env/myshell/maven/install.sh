#!/bin/bash
#安装maven运行环境

source ../config.sh
dir=`pwd`

cd $SOFTWARE_CONTEXT
tar zxvf $SOURCE_MAVEN.tar.gz
echo "===================================="

cd /usr/local
rm -fr maven
ln -s $SOFTWARE_CONTEXT/$SOURCE_MAVEN maven

cd $dir
cp ./maven.sh /etc/profile.d/maven.sh

source /etc/profile
mvn --version

echo "==================================="
echo "maven安装完成"|tee -a $LOG_FILE
