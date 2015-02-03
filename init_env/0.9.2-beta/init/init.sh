#!/bin/sh
source ../config.sh

sh init_export.sh
sh init_software.sh

sh ../java/install.sh
sh ../maven/install.sh
sh ../nginx/install.sh

source /etc/profile
