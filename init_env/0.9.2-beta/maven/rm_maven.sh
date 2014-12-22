#!/bin/sh
rm -f /etc/profile.d/maven.sh

source /etc/profile

cd /usr/local
rm -fr maven

cd -
source ../config.sh
cd $SOFTWARE_CONTEXT
rm -fr $SOURCE_MAVEN
