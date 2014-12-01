#!/bin/bash
source ../config.sh
NGINX_HOME=/usr/local/nginx
###############tomcat的server自动删除脚本##################################
if [[ "$1" = "" || "$2" = "" ]];then
        echo "sh recycle.sh domain instanceid|all"
        echo "sh recycle.sh www.jd.com 1   or sh recycle.sh www.jd.com all"
        exit 0
fi

INSTANCE=$2
DOMAIN=$1
DOMAIN_HOME=$CONTEXT/Domains/$DOMAIN
INSTANCE_COUNT=`ls $DOMAIN_HOME|wc -l`

if [[ $INSTANCE == "all" ]];then
	#nginx配置#
	echo "$INSTANCE_COUNT"
	DNUM=`awk 'BEGIN{nu=('$INSTANCE_COUNT'+2);print nu}'`
	sed -i '/'${DOMAIN}'/,+'$DNUM'd' $NGINX_HOME/conf/nginx.conf
	rm $NGINX_HOME/conf/vhost/${DOMAIN}.conf
	
	$CONTEXT/Shell/$DOMAIN/tomcat-ctrl.sh stop all	

	rm -fr $CONTEXT/App/${DOMAIN}
	rm -fr $CONTEXT/Domains/${DOMAIN}
	rm -fr $CONTEXT/Shell/${DOMAIN}
	rm -fr $CONTEXT/Data/${DOMAIN}
	rm -fr $CONTEXT/Config/${DOMAIN}
	rm -fr $CONTEXT/Logs/${DOMAIN}
else
	if [[ $INSTANCE > $INSTANCE_COUNT || $INSTANCE<1 ]];then
        	echo "实例编号不正确1-$INSTANCE_COUNT"
        	exit 0
	fi

	rm -fr $DOMAIN_HOME/server$INSTANCE
	$CONTEXT/Shell/$DOMAIN/tomcat-ctrl.sh stop $INSTANCE	
	sed -i '/'$DOMAIN' server'$INSTANCE'/d' $NGINX_HOME/conf/nginx.conf
fi

#重启nginx
service nginx reload
