#!/bin/bash
source ../config.sh
###############tomcat的server自动删除脚本##################################
if [[ $1 == "" ]];then
        echo "请输入域名"
        exit 0
fi
DOMAIN=$1

rm -fr $CONTEXT/App/${DOMAIN}
rm -fr $CONTEXT/Domains/${DOMAIN}
rm -fr $CONTEXT/Shell/${DOMAIN}
rm -fr $CONTEXT/Data/${DOMAIN}
rm -fr $CONTEXT/Config/${DOMAIN}
rm -fr $CONTEXT/Logs/${DOMAIN}

#nginx配置#
sed -i '/'${DOMAIN}'shutdown/,+3 d' /usr/local/nginx/conf/nginx.conf
rm /usr/local/nginx/conf/vhost/${DOMAIN}.conf
#重启nginx
/usr/local/nginx/sbin/nginx -s reload
