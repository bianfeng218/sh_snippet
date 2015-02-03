#!/bin/bash
#author: bianfeng218@163.com
#desc: tail -f tomcat实例catalina.out日志
#脚本没有参数的时候默认为第一个实例,一次只能查看某一个实例的日志，不支持查看所有实例的日志

source context/Config/server1/config.sh

_domainHome=$CONTEXT/Domains/$DOMAIN
_instanceNumber=$1
_total=`ls $_domainHome|wc -l`

help() {
        echo "Usage: ./`basename $0` instanceNumber[1-$_total]"
}

if [ -z "$1" ];then
	help
fi

if [ ${_instanceNumber:=1} -gt $_total -o ${_instanceNumber:=1} -lt 1 ];then
	echo "实例编号不正确"
	help
	exit 1
fi

if [ -f "$_domainHome/server$_instanceNumber/logs/catalina.out" ]; then
        tail -100f $_domainHome/server$_instanceNumber/logs/catalina.out
else
        echo "================================"
        echo "暂时没有日志输出"
        echo "================================"
fi
