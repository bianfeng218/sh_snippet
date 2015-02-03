#!/bin/sh
cd /export/servers/
scp root@192.168.147.32:/export/servers/nginx-1.2.3.tar.gz .
tar zxvf nginx-1.2.3.tar.gz
cd nginx-1.2.3

yum install gcc
yum install pcre-devel
yum install zlib-devel
yum install openssl-devel

#./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/nginx/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-http_ssl_module 
./configure --prefix=/usr/local/nginx  

yum install make

make
make install

cd /usr/local/nginx/
#配置nginx参数
sed -i 's/worker_processes 1/worker_processes 4/' /conf/nginx.conf


#打开防火墙
sed -i '/-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT/a\-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT' /etc/sysconfig/iptables



#启动nginx
./sbin/nginx

#test
curl 127.0.0.1
