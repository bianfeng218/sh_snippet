#!/bin/sh
rm -f /etc/profile.d/java.sh

source /etc/profile

cd /usr/local
rm -fr java 

cd -
source ../config.sh
cd $SOFTWARE_CONTEXT
rm -fr $SOURCE_JDK
