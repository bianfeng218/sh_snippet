#!/bin/sh
source context/Config/server1/config.sh

_appHome="$CONTEXT/App/${DOMAIN}"
_codePath="$_appHome/code/"
_shellHome="$CONTEXT/Shell/$DOMAIN"

echo '---delete and check out codes---'
sh checkout.sh

echo '---build project---'
cd $_codePath
mvn -Dfile.encoding=UTF-8 -DskipTests=true clean package -P $MVN_profile -U
if [ $? != 0 ]; then
    echo "error build"
    exit 1
fi

echo 
echo 'build success.'
echo 
echo '----------------------------------------------'


echo '---replace data and startup tomcat---'
cd $_codePath/$WAR_PARENT_DIR
cp -f *.war $CONTEXT/aa.war

#清空程序部署目录
cd $_appHome
rm -fr *

mv $CONTEXT/aa.war .
jar xvf aa.war 
rm -fr aa.war

echo 'restart all tomcat instances....'
$_shellHome/tomcat-ctrl.sh restart
$_shellHome/catalinaout.sh
