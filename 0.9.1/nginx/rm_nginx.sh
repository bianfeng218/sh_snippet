#!/bin/sh

service nginx stop
chkconfig --del nginx
rm -f /etc/init.d/nginx

source ../config.sh
rm -fr /usr/local/nginx
rm -fr $SOFTWARE_CONTEXT/$SOURCE_NGINX
rm -fr $SOFTWARE_CONTEXT/nginx
