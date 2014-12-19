#!/bin/sh
source ./config.sh

APP_PATH="$CONTEXT/App/${DOMAIN_NAME}"
SOURCE_PATH="$CONTEXT/App/$DOMAIN_NAME/code/"
SHELL_PATH="$CONTEXT/Shell/$DOMAIN_NAME"

echo '---delete and check out codes---'
sh checkout.sh

echo '---build project---'
cd $SOURCE_PATH
#mvn -Dfile.encoding=UTF-8 -DskipTests=true clean package -P development -U
mvn -Dfile.encoding=UTF-8 -DskipTests=true clean package -P development 
if [ $? != 0 ]; then
    echo "error build"
    exit 1
fi

echo 
echo 'build success.'
echo 
echo '----------------------------------------------'


echo '---replace data and startup tomcat---'
cd $SOURCE_PATH/$WAR_PARENT_DIR
cp -f *.war $CONTEXT/aa.war

#清空程序部署目录
cd $APP_PATH
rm -fr *

mv $CONTEXT/aa.war .

jar xvf aa.war 


echo 'restart tomcat....'
$SHELL_PATH/tomcat_ctrl.sh restart
$SHELL_PATH/catalina.out.sh
