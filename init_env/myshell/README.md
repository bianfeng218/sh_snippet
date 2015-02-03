#进度
1.2015-01-05，完成java,maven,nginx基本调试，后期需要优化代码
2.15-01-18, 完成tomcat脚本重构./add.sh;count_port.sh重构完成
recycle.sh调试完毕，暂未重构。遗留一个bug
	1.添加test.jd.com 3;recycle.sh test.jd.com 2;recycle.sh test.jd.com 2;打印出来说实例编号不正确的提示。但是脚本却执行成功了
3.2015-01-26,catalinaout.sh无参数时默认为1，已经实现，通过:=语法实现
4.2015-01-27,mvn -p参数化
5.2015-01-27,svn username password参数化，但是是可选的
6.2015-01-27,tomcat-ctrl脚本重构完成，支持操作前检查实例运行情况，根据情况决定是否进行启动或者停止操作
7.2015-01-27,新增tomcat/script_default/taillog.sh


#计划
2015-01-22
1.编写统计当前机器部署应用列表的脚本，需要列出已经存在的域名以及已经删除的脚本，表头展示以下信息：
当前机器部署域名：
域名		实例：http端口：shutdown端口		当前状态		创建时间
test.jd.com	server1:8095:8193			running			2012-09-18


当前机器被删除的域名：
域名		实例；http端口：shutdown端口			删除时间
test.jd.com	server2:8094:7834				2012-10-03

6.支持检测本机是否安装已经安装nginx。使用原生nginx，不再绑定专有的nginx
7.tomcat的配置放到config.sh中去

