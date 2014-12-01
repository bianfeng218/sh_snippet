#!/bin/sh
dbs=$(mysql -u -h -p -e"show databases"|sed '1d'|sed '/\w*_schema/'d|sed '/test/'d|sed '/mysql/'d)

echo "=============查询出来需要迁移的数据库："
echo $dbs
for db in $dbs
do
        echo "dump $db 到本地..."
        mysqldump -uroot -h192.168.216.52 -p123456 -B $db > $db.sql
        echo "Done!"
done
echo "全部dump到本地完成！"
ls -l

for db in $dbs
do
        echo "正在导入$db..."
        mysql -uroot -p123456 < $db.sql
        echo "Done!"
done



