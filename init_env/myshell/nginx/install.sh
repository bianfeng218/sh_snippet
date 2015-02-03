#!/bin/bash
#nginx编译安装
#适用环境：centos6系列

source ../config.sh

NGINX_HOME=$SOFTWARE_CONTEXT/nginx

makeinstall () {
	if [ -e $NGINX_HOME/sbin/nginx ]
		then
			echo "nginx已安装"
		exit 1
	fi

	tar zxvf $SOURCE_NGINX.tar.gz
	cd $SOURCE_NGINX

	#安装依赖
	yum -y install gcc
	yum -y install pcre-devel
	yum -y install zlib-devel
	yum -y install openssl-devel
	yum -y install make

#./configure --prefix=/usr/local/nginx --sbin-path=/usr/local/nginx/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-http_ssl_module 
	#编译安装
	./configure --prefix=$NGINX_HOME --with-http_stub_status_module $NGINX_CONFIGURE_PARAM
	make & make install

	cd /usr/local
	rm -fr nginx
	ln -s $NGINX_HOME nginx

	cd /usr/local/nginx
	mkdir -p conf/vhost
}

config() {
	#配置nginx参数
	cd $SHELL_CONTEXT/nginx
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
}


cd $SOFTWARE_CONTEXT

makeinstall
config

cd $SHELL_CONTEXT/nginx
#打开防火墙
sh ./open_iptables.sh

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
