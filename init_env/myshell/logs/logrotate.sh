#!/bin/bash
LOG_DIR="/export/servers/nginx/logs"
BACK_DIR=`date +%Y/%m/`  
DATE_NAME=`date +%Y%m%d `
for log in `ls -l /export/servers/nginx/logs/|grep "^d"|awk '{print $9}'`
do
for logs in `ls /export/servers/nginx/logs/$log/|grep -v "[0-9]$"`
do
mv ${LOG_DIR}/$log/$logs ${LOG_DIR}/$log/$logs${DATE_NAME}
done
done
kill -USR1 `cat  /export/servers/nginx/logs/nginx.pid`
