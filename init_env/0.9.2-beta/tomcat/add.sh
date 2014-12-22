#!/bin/bash

source ../config.sh
NGINX_HOME=/usr/local/nginx
###############tomcat的server自动增加脚本##################################
if [[ $1 == "" ]];then
        echo "请输入域名"
        exit 0
fi

DOMAIN=$1
INSTANCE_NUMBER=$2
if [[ $INSTANCE_NUMBER == "" ]];then
	INSTANCE_NUMBER=1
fi
echo "域名：$DOMAIN 实例数量：$INSTANCE_NUMBER"

DOMAIN_HOME=$CONTEXT/Domains/$DOMAIN

mkdir -p $DOMAIN_HOME
mkdir -p $CONTEXT/Data/${DOMAIN}
mkdir -p $CONTEXT/App/${DOMAIN}
mkdir -p $CONTEXT/Logs/${DOMAIN}
mkdir -p $CONTEXT/Config/${DOMAIN}

#添加实例
tar zxvf server1.tar.gz  >>/dev/null

INSTANCE_NUMBER=`awk 'BEGIN{nu=('${INSTANCE_NUMBER}'+0);print nu}'`

for (( i=1; i<=$INSTANCE_NUMBER; i++)) 
do
  SERVER=server$i
  source ./count_port.sh
  echo "$DOMAIN_HOME/$SERVER HTTPPORT:$SERVERPORT SHUTDOWN PORT:${HTTPPORT}"
  cp -r server1 ${DOMAIN_HOME}/$SERVER

  sed -i 's/server1/'${DOMAIN}\\/${SERVER}'/g'                ${DOMAIN_HOME}/$SERVER/bin/start.sh
  sed -i 's/server1/'${DOMAIN}\\/${SERVER}'/g'                ${DOMAIN_HOME}/$SERVER/bin/stop.sh
  sed -i 's/8100/'${SERVERPORT}'/g'               ${DOMAIN_HOME}/$SERVER/conf/server.xml
  sed -i 's/8001/'${HTTPPORT}'/g'                 ${DOMAIN_HOME}/$SERVER/conf/server.xml
  sed -i "s/server1/${DOMAIN}/g"                  ${DOMAIN_HOME}/$SERVER/conf/Catalina/localhost/ROOT.xml

  #nignx upstream
  if [[ $i == 1 ]];then
      sed -i 's/#server1/#server1\n    #'${DOMAIN}'\n    upstream '${DOMAIN}'{\n      server 127.0.0.1:'${HTTPPORT}'; #'$DOMAIN' server'$i' shutdown port '$SERVERPORT'\n    }/' $NGINX_HOME/conf/nginx.conf
  else
      PRE=`awk 'BEGIN{nu=('$i'-1);print nu}'` 
      sed -i '/'$DOMAIN' server'$PRE'/a\      server 127.0.0.1:'${HTTPPORT}'; \#'${DOMAIN}' server'$i' shutdown port '${SERVERPORT}'' $NGINX_HOME/conf/nginx.conf
  fi
done

rm -fr server1

#tomcat控制脚本
tar zxvf script.tar.gz >>/dev/null
sed -i 's/server1/'\\${CONTEXT}\\/Domains\\/${DOMAIN}'/g'                script/tomcat-ctrl.sh
sed -i 's/server1/'\\${CONTEXT}\\/Domains\\/${DOMAIN}'/g'                script/catalinaout.sh
sed -i 's/server1/'\\${CONTEXT}\\/Domains\\/${DOMAIN}'/g'                script/checkout.sh
sed -i 's/server1/'\\${CONTEXT}\\/Domains\\/${DOMAIN}'/g'                script/build.sh

mv script $CONTEXT/Shell/$DOMAIN
#加入测试页面
cp index.html index.jsp $CONTEXT/App/${DOMAIN}/

#启动tomcat第一个实例
#$CONTEXT/Shell/${DOMAIN}/tomcat-ctrl.sh start 1
$CONTEXT/Shell/${DOMAIN}/tomcat-ctrl.sh start all
 

#ningx配置更改====================================================
#server
tar zxvf nginxconf.tar.gz >>/dev/null
sed -i 's/server1/'${DOMAIN}'/g'                nginxconf/server1.conf
mv nginxconf/server1.conf $NGINX_HOME/conf/vhost/${DOMAIN}.conf
rmdir nginxconf

#重启nginx
service nginx reload
