#!/bin/bash
#author:yfliqiang
#tomcat实例增加

#set -x
source ../config.sh

domain=$1
instanceCount=$2

NGINX_HOME=/usr/local/nginx
DOMAIN_HOME=$CONTEXT/Domains/$domain


#检查域名是否已经存在
checkIfDomainExist(){
	if [ -d $CONTEXT/Domains/$domain ]
	then
		echo "此域名$domain已添加，请更换域名"
		exit 1
	fi
}

#创建实例运行所需的目录
createDomainContext()
{
	mkdir -p $DOMAIN_HOME
	mkdir -p $CONTEXT/Data/${domain}
	mkdir -p $CONTEXT/App/${domain}
	mkdir -p $CONTEXT/Logs/${domain}
	mkdir -p $CONTEXT/Config/${domain}
	mkdir -p $CONTEXT/.Recycled/$domain
}

addInstance()
{
#添加实例
	local INSTANCE_NUMBER=`awk 'BEGIN{nu=('${instanceCount}'+0);print nu}'`

	for (( i=1; i<=$INSTANCE_NUMBER; i++)) 
	do
		SERVER=server$i
		source ./count_port.sh

		cp -r server_default ${DOMAIN_HOME}/$SERVER

		sed -i 's/server1/'${domain}\\/${SERVER}'/g'                ${DOMAIN_HOME}/$SERVER/bin/start.sh
		sed -i 's/context/'\\${CONTEXT}'/g'                ${DOMAIN_HOME}/$SERVER/bin/start.sh
		sed -i '/catalinaHome/c\'CATALINA_HOME=${CATALINA_HOME}''                ${DOMAIN_HOME}/$SERVER/bin/start.sh

		sed -i 's/server1/'${domain}\\/${SERVER}'/g'                ${DOMAIN_HOME}/$SERVER/bin/stop.sh
		sed -i 's/context/'\\${CONTEXT}'/g'                ${DOMAIN_HOME}/$SERVER/bin/stop.sh
		#sed -i 's/catalinaHome/'\\${CATALINA_HOME}'/g'                ${DOMAIN_HOME}/$SERVER/bin/stop.sh
		sed -i '/catalinaHome/c\'CATALINA_HOME=${CATALINA_HOME}''                ${DOMAIN_HOME}/$SERVER/bin/stop.sh

		sed -i 's/8100/'${httpPort}'/g'               ${DOMAIN_HOME}/$SERVER/conf/server.xml
		sed -i 's/8001/'${shutdownPort}'/g'                 ${DOMAIN_HOME}/$SERVER/conf/server.xml

		sed -i "s/server1/${domain}/g"                  ${DOMAIN_HOME}/$SERVER/conf/Catalina/localhost/ROOT.xml
		sed -i "s/context/\\${CONTEXT}/g"                  ${DOMAIN_HOME}/$SERVER/conf/Catalina/localhost/ROOT.xml

		#创建日志目录
		mkdir -p $CONTEXT/Logs/$domain/$SERVER

		#nignx upstream
		if [[ $i == 1 ]];then
			sed -i 's/#server1/#server1\n    #'${domain}'\n    upstream '${domain}'{\n      server 127.0.0.1:'${httpPort}'; #'$domain' server'$i' shutdown port '$shutdownPort'\n    }/' $NGINX_HOME/conf/nginx.conf
		else
			PRE=`awk 'BEGIN{nu=('$i'-1);print nu}'` 
			sed -i '/'$domain' server'$PRE'/a\      server 127.0.0.1:'${httpPort}'; \#'${domain}' server'$i' shutdown port '${shutdownPort}'' $NGINX_HOME/conf/nginx.conf
		fi
	done
}

addInstanceScript()
{
	#tomcat控制脚本

	if [ ! -d $CONTEXT/Shell ]
	then
		mkdir -p $CONTEXT/Shell
	fi

	local domainScriptContext=$CONTEXT/Shell/$domain
	cp -r script_default $domainScriptContext

	#sed -i 's/server1/'\\${CONTEXT}\\/Domains\\/${domain}'/g'                $domainScriptContext/tomcat-ctrl.sh
	sed -i 's/server1/'${domain}'/'                $domainScriptContext/tomcat-ctrl.sh
	sed -i 's/context/'\\${CONTEXT}'/'             $domainScriptContext/tomcat-ctrl.sh

	#sed -i 's/server1/'\\${CONTEXT}\\/Domains\\/${domain}'/g'                $domainScriptContext/catalinaout.sh
	sed -i 's/server1/'${domain}'/'                $domainScriptContext/catalinaout.sh
	sed -i 's/context/'\\${CONTEXT}'/'             $domainScriptContext/catalinaout.sh

	#sed -i 's/server1/'\\${CONTEXT}\\/Domains\\/${domain}'/g'                $domainScriptContext/checkout.sh
	sed -i 's/server1/'${domain}'/'                $domainScriptContext/checkout.sh
	sed -i 's/context/'\\${CONTEXT}'/'             $domainScriptContext/checkout.sh

	sed -i 's/server1/'${domain}'/'                $domainScriptContext/build.sh
	sed -i 's/context/'\\${CONTEXT}'/'             $domainScriptContext/build.sh

	sed -i 's/context/'\\${CONTEXT}'/'             $domainScriptContext/.tomcat.sh
	sed -i 's/server1/'${domain}'/'                $domainScriptContext/.tomcat.sh

	sed -i 's/context/'\\${CONTEXT}'/'             $domainScriptContext/taillog.sh
	sed -i 's/server1/'${domain}'/'                $domainScriptContext/taillog.sh

	sed -i 's/server1/'${domain}'/g'                $domainScriptContext/config.sh

	#移动脚本执行所需的配置文件到Config目录
	mv $domainScriptContext/config.sh $CONTEXT/Config/$domain/
}


addTestPage()
{
#加入测试页面
	#cp index.jsp $CONTEXT/App/$domain/
	cp -r testapp/* $CONTEXT/App/$domain/
}

#启动tomcat第一个实例
startInstance()
{
	$CONTEXT/Shell/${domain}/tomcat-ctrl.sh start 1
	#$CONTEXT/Shell/${domain}/tomcat-ctrl.sh start all
} 


#添加ningx配置
addNginxConfigration()
{
	#cp -r nginxconf_default nginxconf
	#sed -i 's/server1/'${domain}'/g'                nginxconf/server1.conf
	#mv nginxconf/server1.conf $NGINX_HOME/conf/vhost/${domain}.conf
	#rmdir nginxconf
	cat > $NGINX_HOME/conf/vhost/$domain.conf << EOF
server {

        listen 80;
        client_max_body_size 100M;
        server_name $domain;
        charset utf-8;
        index index.html index.htm index.jsp;
        location / {
                proxy_pass http://$domain/;
                proxy_connect_timeout 500s;
                proxy_read_timeout 500s;
                proxy_send_timeout 500s;
        }
}

EOF

	#重启nginx
	service nginx reload
}

#删除零时文件
deleteTempFiles()
{
	echo
}


if [[ $1 == "" ]];then
        echo "./add.sh domainName instanceNumber"
        exit 0
fi

if [[ $2 == "" ]];then
	instanceCount=1
fi

echo "域名：$domain 实例数量：$instanceCount"

checkIfDomainExist
if [ "$?" != "0" ]
then
	exit 1
fi

#创建目录
createDomainContext
#添加tomcat实例
addInstance
#添加实例运行脚本
addInstanceScript
#添加nginx配置
addNginxConfigration
#添加测试页面
addTestPage

#启动实例
#startInstance
