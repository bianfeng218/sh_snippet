#!/bin/bash
#计算tomcat实例端口

source ../config.sh

#当前机器tomcat实例数量
instanceNumber=0

count()
{
#计算当前机器存在的实例数量
	local count=0

	for existDomain in $CONTEXT/Domains/*
	do
		if [ -z "$domain" ]
		then
			break
		fi

		count=`ls $existDomain|wc -l`
  		let instanceNumber+=$count
	done
	
	echo "current exist instanceNumber:$instanceNumber"
}

#当前机器被回收的实例数量
recycledInstanceNumber=0

countRecycled()
{
#计算被删除的数量
	local count=0

	for recycledDomain in $CONTEXT/.Recycled/*
	do
		if [ -z "$domain" ]
		then
			break
		fi

		count=`ls $recycledDomain|wc -l`
		let recycledInstanceNumber+=count
	done

	echo "already recycled instanceNumber:$recycledInstanceNumber"
}

httpPort=0
shutdownPort=0

countPort()
{
#计算tomcat启动端口跟shutdown端口
	
	count
	countRecycled
	
	local total
	let total=$instanceNumber+$recycledInstanceNumber
	echo "total:$total"
	local number=`awk 'BEGIN{nu=('${total}'+1);print nu}'`
	
	echo "TOMCAT_HTTP_BENGIN_PORT:$TOMCAT_HTTP_BEGIN_PORT"
	echo "TOMCAT_SHUTDOWN_BEGIN_PORT:$TOMCAT_SHUTDOWN_BEGIN_PORT"

	httpPort=`awk 'BEGIN{nu=('${number}'+'${TOMCAT_HTTP_BEGIN_PORT}');print nu}'`
	shutdownPort=`awk 'BEGIN{nu=('${number}'+'${TOMCAT_SHUTDOWN_BEGIN_PORT}');print nu}'`
}

#计算端口
countPort

echo ""
echo ""
echo "resut:-----------------------------------"
echo -e "httpPort: \033[31m $httpPort \033[m"
echo -e "shutdownPort: \033[31m $shutdownPort \033[m"
echo ""
