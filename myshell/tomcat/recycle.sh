#!/bin/bash
source ../config.sh
NGINX_HOME=/usr/local/nginx
###############tomcat的server自动删除脚本##################################

help() {
	#echo "Usage:$0 domainName instanceNumber|all"
	echo "Usage: ./`basename $0` domainName instanceNumber|all"
	echo "Example: ./`basename $0` www.jd.com 1|all"
	exit 1
}



if [ $# -lt 2 ];then
	help
        exit 1
fi

instanceNumber=$2
domainName=$1



checkIfDomainExist() {
	if [ -d $CONTEXT/Domains/$domainName ]
	then
		echo "域名$domainName将被删除"
	else
		echo "不存在此域名$domainName"
		exit 1
	fi
}


checkIfDomainExist
if [ $? = 1 ]
then
	exit 0
fi

currentExistInstanceCount=`ls $CONTEXT/Domains/$domainName|wc -l`

if [ "$currentExistInstanceCount" = "1" ]
then
	instanceNumber="all"
fi
#算出最初添加了多少个实例
recycledInstanceNumber=`ls -d $CONTEXT/.Recycled/$domainName|wc -l`
let initialInstanceCount=$currentExistInstanceCount+$recycledInstanceNumber
echo "instancCount:$initialInstanceCount"

if [ "$instanceNumber" = "all" ];then
	#nginx配置#
	DNUM=`awk 'BEGIN{nu=('$currentExistInstanceCount'+2);print nu}'`
	sed -i '/'${domainName}'/,+'$DNUM'd' $NGINX_HOME/conf/nginx.conf
	touch $NGINX_HOME/conf/vhost/$domainName.conf&&rm $NGINX_HOME/conf/vhost/${domainName}.conf
	
	$CONTEXT/Shell/$domainName/tomcat-ctrl.sh stop all	

	rm -fr $CONTEXT/App/${domainName}
	if [ -d $CONTEXT/.Recycled/$domainName ]
	then
		if [ -d "$CONTEXT/Domains/$domainName/server1" -a -d "$CONTEXT/.Recycled/$domainName/server1" ]
		then
			recycledDomainCount=`ls -d $CONTEXT/.Recycled/${domainName}*|wc -l`
			let recycledDomainCount+=1
			mv $CONTEXT/Domains/${domainName} $CONTEXT/.Recycled/${domainName}$recycledDomainCount
		else
			mv $CONTEXT/Domains/$domainName/* $CONTEXT/.Recycled/$domainName/
			rmdir $CONTEXT/Domains/$domainName
		fi
	else
		mv $CONTEXT/Domains/${domainName} $CONTEXT/.Recycled/$domainName
	fi
	rm -fr $CONTEXT/Shell/${domainName}
	rm -fr $CONTEXT/Data/${domainName}
	rm -fr $CONTEXT/Config/${domainName}
	rm -fr $CONTEXT/Logs/${domainName}
else
	echo "initialInstanceCount:$initialInstanceCount"
	if [ "$instanceNumber" -gt "$initialInstanceCount" -o "$instanceNumber" -lt "1" ];then
        	echo "实例编号不正确1-$initialInstanceCount"
        	exit 1
	fi

	$CONTEXT/Shell/$domainName/tomcat-ctrl.sh stop $instanceNumber	
	if [ -d $CONTEXT/.Recycled/$domainName ]
	then
		if [ -d "$CONTEXT/Domains/$domainName/server1" -a -d "$CONTEXT/.Recycled/$domainName/server1" -a -d "$CONTEXT/.Recycled/$domainName/server$instanceNumber" ]
		then
			recycledDomainCount=`ls -d $CONTEXT/.Recycled/${domainName}*|wc -l`
			let recycledDomainCount+=1
			mv $CONTEXT/.Recycled/${domainName} $CONTEXT/.Recycled/${domainName}$recycledDomainCount
			
			mkdir $CONTEXT/.Recycled/$domainName
			mv $CONTEXT/Domains/$domainName/server$instanceNumber $CONTEXT/.Recycled/$domainName
		else
			mv $CONTEXT/Domains/$domainName/server$instanceNumber $CONTEXT/.Recycled/$domainName/
		fi
	else
		mkdir $CONTEXT/.Recycled/$domainName
		mv $CONTEXT/Domains/$domainName/server$instanceNumber $CONTEXT/.Recycled/$domainName/
	fi

	sed -i '/'$domainName' server'$instanceNumber'/d' $NGINX_HOME/conf/nginx.conf
fi

#重启nginx
service nginx reload
