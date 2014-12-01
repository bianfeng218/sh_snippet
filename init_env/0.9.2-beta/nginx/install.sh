#!/bin/sh
source ../config.sh
cd $SOFTWARE_CONTEXT

tar zxvf $SOURCE_NGINX.tar.gz
cd $SOURCE_NGINX

#安装依赖
yum install gcc
yum install pcre-devel
yum install zlib-devel
yum install openssl-devel

#./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/nginx/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-http_ssl_module 
NGINX_HOME=$SOFTWARE_CONTEXT/nginx

./configure --prefix=$NGINX_HOME --with-http_stub_status_module $NGINX_CONFIGURE_PARAM

yum install make

make
make install

cd /usr/local
rm -fr nginx
ln -s $NGINX_HOME nginx

cd $NGINX_HOME/conf
mkdir vhost

cd $SHELL_CONTEXT/nginx
#配置nginx参数
sed -i 's/#user  nobody/user  root/' $NGINX_HOME/conf/nginx.conf
sed -i 's/worker_processes  1/worker_processes  4/' $NGINX_HOME/conf/nginx.conf
sed -i '/#gzip/r ./nginx_extra.conf' $NGINX_HOME/conf/nginx.conf 

#配置nginx_status
IP=`/sbin/ifconfig eth0  | sed -n '/inet addr:/ s/inet addr://pg' | awk -F" " '{print $1}'`
cp ./nginx_status_default.conf nginx_status.conf
sed -i "s/server_name/server_name $IP;/" ./nginx_status.conf

sed -i '/include/,+6 d' $NGINX_HOME/conf/nginx.conf
sed -i '/#server1/r ./nginx_status.conf' $NGINX_HOME/conf/nginx.conf

rm -f ./nginx_status.conf

#打开防火墙
sh ../open_iptables.sh

#添加nginx 的service脚本
cp nginx /etc/init.d/

#开机启动
chkconfig --add nginx
chkconfig nginx on

#启动nginx
service nginx start

#test
curl 127.0.0.1
#关闭nginx
#service nginx stop

#删除源码
rm -fr $SOFTWARE_CONTEXT/$SOURCE_NGINX
