#!/bin/bash

source ../config.sh

COUNT=0
for domain in $CONTEXT/Domains/*
do
  INSTANCE_COUNT=`ls $domain|wc -l`
  COUNT=$COUNT+$INSTANCE_COUNT
done
NUMBER=`awk 'BEGIN{nu=('${COUNT}'+1);print nu}'`


SERVERPORT=`awk 'BEGIN{nu=('${NUMBER}'+'${TOMCAT_HTTP_BEGIN_PORT}');print nu}'`
HTTPPORT=`awk 'BEGIN{nu=('${NUMBER}'+'${TOMCAT_SHUTDOWN_BEGIN_PORT}');print nu}'`
