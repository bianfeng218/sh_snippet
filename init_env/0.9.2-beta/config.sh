

CONTEXT=/export
SHELL_CONTEXT=/root/init_env/0.9.2-beta
SOFTWARE_CONTEXT=$CONTEXT/servers

NGINX_CONFIGURE_PARAM="--with-pcre=/root/pcre-8.36 --with-pcre-jit"

SOURCE_IP=192.168.147.32
USER=root
SOURCE_NGINX=nginx-1.2.3
SOURCE_MAVEN=apache-maven-3.0.4
SOURCE_JDK=jdk1.6.0_25
SOURCE_TOMCAT=tomcat6.0.33

TOMCAT_HTTP_BEGIN_PORT=8500
TOMCAT_SHUTDOWN_BEGIN_PORT=8000

LOG_FILE=/root/temp.log