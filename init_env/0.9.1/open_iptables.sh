#!/bin/sh
#打开防火墙80端口
sed -i '/-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT/, 1d' /etc/sysconfig/iptables
sed -i '/-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT/a\-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT' /etc/sysconfig/iptables

service iptables restart
