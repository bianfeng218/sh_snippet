#!/bin/sh
source ../config.sh
cd $SOFTWARE_CONTEXT
scp $USER@$SOURCE_IP:/export/servers/$SOURCE_MAVEN.tar.gz .
scp $USER@$SOURCE_IP:/export/servers/$SOURCE_NGINX.tar.gz .
scp $USER@$SOURCE_IP:/export/servers/$SOURCE_JDK.tar.gz .
scp $USER@$SOURCE_IP:/export/servers/$SOURCE_TOMCAT.tar.gz .
echo "软件安装包初始化完毕"|tee -a $LOG_FILE
ls $SOFTWARE_CONTEXT|tee -a $LOG_FILE
