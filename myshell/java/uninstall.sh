#!/bin/bash
#清除本机java环境

rm -f /etc/profile.d/java.sh
rm -fr /usr/local/java 

source ../config.sh
rm -fr $SOFTWARE_CONTEXT/$SOURCE_JDK

java -version

echo "java执行环境清除完毕"|tee -a $LOG_FILE
