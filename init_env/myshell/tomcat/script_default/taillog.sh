#!/bin/bash
#author: bianfeng218@163.com
#desc: tail -f 应用日志

source context/Config/server1/config.sh

_domainHome=$CONTEXT/Domains/$DOMAIN
_logHome=$CONTEXT/Logs/$DOMAIN
_instanceNumber=$2
_total=`ls $_domainHome|wc -l`

help() {
        echo "Usage: ./`basename $0` filename instanceNumber"
	echo "Example: ./`basename $0` error.log 1"
}

if [ -z "$1" ];then
	help
fi

if [ ${_instanceNumber:=1} -gt $_total -o ${_instanceNumber:=1} -lt 1 ];then
	echo "实例编号不正确"
	help
	exit 1
fi

if [ -f "$_logHome/server$_instanceNumber/$1" ]; then
        tail -100f $_logHome/server$_instanceNumber/$1
else
        echo "================================"
        echo "暂时没有日志输出"
        echo "================================"
fi
