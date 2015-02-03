#!/bin/bash

if [ -z $CATALINA_HOME ]
then
  export CATALINA_HOME=catalinaHome
fi

export CATALINA_BASE=context/Domains/server1
export JAVA_OPTS="-Djava.library.path=/usr/local/lib -server -Xms512m -Xmx1024m -XX:MaxPermSize=256m -Djava.awt.headless=true -Dsun.net.client.defaultConnectTimeout=60000 -Dsun.net.client.defaultReadTimeout=60000 -Djmagick.systemclassloader=no -Dnetworkaddress.cache.ttl=300 -Dsun.net.inetaddr.ttl=300"

$CATALINA_HOME/bin/startup.sh -config $CATALINA_BASE/conf/server.xml
