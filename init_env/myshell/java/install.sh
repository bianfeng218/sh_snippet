#!/bin/bash
#安装java运行环境

source ../config.sh
cd $SOFTWARE_CONTEXT
tar zxvf $SOURCE_JDK.tar.gz
cd /usr/local

if [[ -e java ]] ; then
  rm -fr java
fi

ln -s $SOFTWARE_CONTEXT/$SOURCE_JDK java

cd $SHELL_CONTEXT/java
cp ./java.sh /etc/profile.d/java.sh

source /etc/profile
java -version
