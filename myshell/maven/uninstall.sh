#!/bin/bash

dir=`pwd`

rm -f /etc/profile.d/maven.sh

cd /usr/local
rm -fr maven

cd $dir
source ../config.sh
cd $SOFTWARE_CONTEXT
rm -fr $SOURCE_MAVEN
