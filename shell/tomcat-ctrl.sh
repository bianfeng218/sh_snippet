#!/bin/sh


if [ "$1" = "start" ] ; then
	/export/Domains/user.vsp.jd.com/bin/start.sh
elif [ "$1" = "stop" ] ; then
	/export/Domains/user.vsp.jd.com/bin/stop.sh
elif [ "$1" = "restart" ] ; then
	/export/Domains/user.vsp.jd.com/bin/stop.sh
	echo 'sleep 5s.'
	sleep 5
	
	/export/Domains/user.vsp.jd.com/bin/start.sh
fi
