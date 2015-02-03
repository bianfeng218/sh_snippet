#!/bin/sh
#清除$CONTEXT目录的内容

. ./config.sh

rm -fr $CONTEXT/App
rm -fr $CONTEXT/Logs
rm -fr $CONTEXT/Data
rm -fr $CONTEXT/Domains
rm -fr $CONTEXT/Shell
rm -fr $CONTEXT/Config
rm -fr $CONTEXT/.Recycled

echo "$CONTEXT目录清理完毕"|tee -a $LOG_FILE
ls $CONTEXT|tee -a $LOG_FILE
