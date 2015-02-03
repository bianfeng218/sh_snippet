#!/bin/bash

# Author: yfliqiang@jd.com
# Date  : 2015.01.26
# Desc  : Restart all tomcat instances
#

RUNNING=12
STOPPED=13

source context/Config/server1/config.sh

_domain=$CONTEXT/Domains/$DOMAIN
_servers=${SERVERS:=" domain"}

# Tomcat Settings
LANG=$LANG

WHO=`whoami`


checkRunning() {
ps -ef|grep -v "grep"|grep $_domain/$1 >> /dev/null
if [ $? -eq 0 ];then
	return $RUNNING
else
	return $STOPPED
fi
}

startSingle() {
	local server=$1
    sleep 1
    tput smso
        echo "*****************************************"
        echo "***       tomcat starting action      ***"
        echo "*****************************************"
    tput rmso
        #if [[ $WHO == root ]];then
        #        su - admin -c   $_domain/$server/bin/start.sh|awk '{printf "..."}END{print "Finished"}'
        #elif [[ $WHO == admin ]];then
        #        $_domain/$server/bin/start.sh|awk '{printf "..."}END{print "Finished"}'
        #fi
	
	$_domain/$server/bin/start.sh|awk '{printf "..."}END{print "Finished"}'

        if [[ $? == 0 ]];then
                echo "##############################################"
                echo "#tomcat $_domain - $server started succeed!! #"
                echo "##############################################"
	fi
}
#########################starting#############
start() {
for server in $_servers
do
	checkRunning $server
	if [ $? == $RUNNING ]
	then
		echo "tomcat $_domain/$server is running now."
		continue
	fi	
	startSingle $server
done
}

#########################stoping####################
stopSingle() {
	local server=$1
    tput smso
        echo "************************************************************"
        echo "***       tomcat $_domain - $server stoping action       ***"
        echo "************************************************************"
    tput rmso
        #if [[ $WHO == root ]];then
        #        su - admin -c $_domain/$server/bin/stop.sh |awk '{printf "..."}END{print "Finished"}'
        #elif [[ $WHO == admin ]];then
        #        $_domain/$server/bin/stop.sh |awk '{printf "..."}END{print "Finished"}'
        #fi

	$_domain/$server/bin/stop.sh |awk '{printf "..."}END{print "Finished"}'

        if [[ $? == 0 ]];then
                echo "###########################"
                echo "# tomcat stoped succeed!! #"
                echo "###########################"
        fi
}


stop() {
for server in $_servers
do
	checkRunning $server
	if [ $? -eq $STOPPED ]
	then
		echo "tomcat $_domain/$server has stopped now."
		continue
	fi	
	stopSingle $server
done
}

#########################restart####################
restart() {
for server in $_servers
do
	checkRunning $server
	if [ $? == $RUNNING ]
	then
		stopSingle $server
		startSingle $server
	else
		startSingle $server
	fi	
done
}

restart1(){
        stop
        start
	sleep 3
        tail $_domain/$server/logs/catalina.out
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        restart
        ;;
  ?|help)
        echo $"Usage: $0 {start|stop|restart|help|?}"
        ;;
  *)
	echo "参数不正确，默认执行restart操作"
        restart
esac
