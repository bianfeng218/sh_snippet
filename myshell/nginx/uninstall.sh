#!/bin/bash
#清除nginx

#停止nginx进程
service nginx stop
#去掉nginx开机启动项
chkconfig --del nginx
rm -f /etc/init.d/nginx

source ../config.sh
#删除nginx源程序
rm -fr /usr/local/nginx
rm -fr $SOFTWARE_CONTEXT/$SOURCE_NGINX
rm -fr $SOFTWARE_CONTEXT/nginx

echo "==============================="
echo "nginx清除完毕"|tee -a $LOG_FILE
