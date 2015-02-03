#!/bin/bash
#author:bianfeng218@163.com
#desc:tomcat实例控制脚本，支持单个或者全部实例启动、停止、重启
#直接运行脚本默认操作为重启所有实例


source context/Config/server1/config.sh

_domainHome=$CONTEXT/Domains/$DOMAIN
_total=`ls $_domainHome|wc -l`
_shellHome=$CONTEXT/Shell/$DOMAIN

help() {
        #echo "Usage:$0 domainName instanceNumber|all"
        echo "Usage: ./`basename $0` start|stop|restart instanceNumber[1-$_total]|all"
        echo "Example: ./`basename $0` www.jd.com 2|all"
        return 1
}

ctrlAll() {
	export SERVERS=`ls $_domainHome`
	$_shellHome/.tomcat.sh $1
}


if [ $# -lt 1 ];then
	help
	echo "参数不正确，3秒后执行默认操作..."
	echo
	echo
	
	sleep 3
	ctrlAll restart
	exit 0
fi

case "$2" in
[0-9]*)
	if [[ $2 > $_total || $2<1 ]];then
		help
		exit 0
	fi
	
	#传递给tomcat.sh脚本使用
	export SERVERS=" server$2"
	$_shellHome/.tomcat.sh $1
	;;
all)
	ctrlAll $1
	;;
*)
	if [ -z "$2" ];then
		echo "你没有指定具体实例编号。默认对所有实例进行操作"
		ctrlAll $1
	else
		help
	fi
	;;
esac
