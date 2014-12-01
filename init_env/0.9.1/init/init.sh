#!/bin/sh
source ../config.sh

sh init_export.sh
sh init_software.sh

sh ../java/install_java.sh
sh ../maven/install_maven.sh
sh ../nginx/install_nginx.sh

source /etc/profile
