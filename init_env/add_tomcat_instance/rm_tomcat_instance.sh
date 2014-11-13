#!/bin/bash
###############tomcat的server自动删除脚本##################################
if [[ $1 == "" ]];then
        echo "请输入域名"
        exit 0
fi
DOMAIN=$1

rm -fr /export/App/${DOMAIN}
rm -fr /export/Domains/${DOMAIN}
rm -fr /export/Shell/${DOMAIN}
rm -fr /export/Data/${DOMAIN}
rm -fr /export/Config/${DOMAIN}
rm -fr /export/Logs/${DOMAIN}

#nginx配置#
sed -i '/'${DOMAIN}'shutdown/,+3 d' /usr/local/nginx/conf/nginx.conf
rm /usr/local/nginx/conf/vhost/${DOMAIN}.conf
#重启nginx
/usr/local/nginx/sbin/nginx -s reload
