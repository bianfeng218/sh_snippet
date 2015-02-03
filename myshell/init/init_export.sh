#!/bin/sh
#初始化目录结构

source ../config.sh

mkdir -p $CONTEXT/App
mkdir -p $CONTEXT/Logs
mkdir -p $CONTEXT/Data
mkdir -p $CONTEXT/Domains
mkdir -p $CONTEXT/Shell
mkdir -p $CONTEXT/Config
mkdir -p $CONTEXT/.Recycled

#mkdir -p $CONTEXT/{App,Logs,Data,Domains,Shell,Config,.Recycled}

echo "目录初始化完毕"|tee -a $LOG_FILE

ls $CONTEXT |tee -a $LOG_FILE
