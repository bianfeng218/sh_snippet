#!/bin/bash
###############tomcat的server自动增加脚本##################################
if [[ $1 == "" ]];then
        echo "请输入域名"
        exit 0
fi
DOMAIN=$1
DOMAIN_HOME=/export/Domains/
COUNT=`ls ${DOMAIN_HOME}|wc -l`
NUMBER=`awk 'BEGIN{nu=('${COUNT}'+1);print nu}'`


###############set tomcat server##################################
SERVER=$1

SERVERPORT=`awk 'BEGIN{nu=('${NUMBER}'+8100);print nu}'`
HTTPPORT=`awk 'BEGIN{nu=('${NUMBER}'+8000);print nu}'`
echo "$SERVERPORT"
tar zxvf server1.tar.gz  >>/dev/null
mv server1 ${DOMAIN_HOME}${SERVER}

sed -i 's/server1/'${SERVER}'/g'                ${DOMAIN_HOME}${SERVER}/bin/start.sh
sed -i 's/server1/'${SERVER}'/g'                ${DOMAIN_HOME}${SERVER}/bin/stop.sh
sed -i 's/8100/'${SERVERPORT}'/g'               ${DOMAIN_HOME}${SERVER}/conf/server.xml
sed -i 's/8001/'${HTTPPORT}'/g'                 ${DOMAIN_HOME}${SERVER}/conf/server.xml
sed -i "s/server1/${DOMAIN}/g"                  ${DOMAIN_HOME}${SERVER}/conf/Catalina/localhost/ROOT.xml


mkdir -p /export/Data/${DOMAIN}
mkdir -p /export/App/${DOMAIN}
mkdir -p /export/Logs/${DOMAIN}
mkdir -p /export/Config/${DOMAIN}

####辅助脚本######
tar zxvf script.tar.gz >>/dev/null
sed -i 's/server1/'${SERVER}'/g'                script/tomcat-ctrl.sh
sed -i 's/server1/'${SERVER}'/g'                script/catalina.out.sh
sed -i 's/server1/'${SERVER}'/g'                script/build.sh
sed -i 's/server1/'${SERVER}'/g'                script/checkout.sh
mv script /export/Shell/${DOMAIN}

#nginx配置#
sed -i 's/#server1/#server1\n    #'${DOMAIN}'shutdown port '${SERVERPORT}'\n    upstream '${DOMAIN}'{\n      server 127.0.0.1:'${HTTPPORT}';\n    }/' /usr/local/nginx/conf/nginx.conf
tar zxvf nginxconf.tar.gz >>/dev/null
sed -i 's/server1/'${SERVER}'/g'                nginxconf/server1.conf
mv nginxconf/server1.conf /usr/local/nginx/conf/vhost/${DOMAIN}.conf
rmdir nginxconf
#重启nginx
/usr/local/nginx/sbin/nginx -s reload
#加入测试页面
cp index.html index.jsp /export/App/${DOMAIN}/
#启动tomcat
/export/Shell/${DOMAIN}/tomcat-ctrl.sh start
