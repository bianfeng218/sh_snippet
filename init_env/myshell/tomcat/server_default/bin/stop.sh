#!/bin/bash

if [ -z $CATALINA_HOME ]
then
  export CATALINA_HOME=catalinaHome
fi

export CATALINA_BASE=context/Domains/server1
###JAVA
#export JAVA_HOME=context/servers/jdk1.6.0_25
#export JAVA_BIN=context/servers/jdk1.6.0_25/bin
#export PATH=/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/bin
#export CLASSPATH=.:/lib/dt.jar:/lib/tools.jar
#export  JAVA_OPTS="-Djava.library.path=/usr/local/lib -server -Xms512m -Xmx1200m -XX:MaxPermSize=256m -Djava.awt.headless=true -Dsun.net.client.defaultConnectTimeout=60000 -Dsun.net.client.defaultReadTimeout=60000 -Djmagick.systemclassloader=no -Dnetworkaddress.cache.ttl=300 -Dsun.net.inetaddr.ttl=300"
#export JAVA_HOME JAVA_BIN PATH CLASSPATH JAVA_OPTS
#export JAVA_OPTS

$CATALINA_HOME/bin/shutdown.sh -config $CATALINA_BASE/conf/server.xml
#ps -aef | grep java|grep server1| grep -v grep | sed 's/ [ ]*/:/g' |cut -d: -f2|kill -9 `cat`
