#!/bin/echo Warining,this library should be sourced!
#脚本配置文件


#软件安装位置
CONTEXT=/export
#程序运行目录
SHELL_CONTEXT=/root/init_env/myshell
#软件包所在路径
SOFTWARE_CONTEXT=$CONTEXT/servers



#==========nginx=========
NGINX_CONFIGURE_PARAM="--with-pcre=/export/servers/pcre-8.36 --with-pcre-jit"




SOURCE_IP=192.168.147.32
USER=root
SOURCE_NGINX=nginx-1.2.3
SOURCE_MAVEN=apache-maven-3.0.4
SOURCE_JDK=jdk1.6.0_25
SOURCE_TOMCAT=tomcat6.0.33


#==========tomcat==========
TOMCAT_HTTP_BEGIN_PORT=8500
TOMCAT_SHUTDOWN_BEGIN_PORT=8000
CATALINA_HOME=$SOFTWARE_CONTEXT/tomcat6.0.33

#=========log=============
LOG_FILE=$SHELL_CONTEXT/temp.log
