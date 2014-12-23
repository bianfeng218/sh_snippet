#author by yfliqiang
#小试牛刀，如有不对，敬请指点
#修改日期：2013-12-04 提炼出pattern_log变量，修改模式，解决误伤文件问题
#修改日期：2013-12-26 解决find命令正则传参错误导致找不到匹配文件的bug


#日志文件
log_file=/home/releasefilelist.txt;
#操作路径
path=/home;
#匹配文件模式
pattern_log=*.log.*;
pattern_out=*.out.*;

ls $log_file || touch $log_file;

#记录操作日期
date | tee -a $log_file;
echo "---------------------------------------------------------------------------"| tee -a $log_file;

echo "当前/home容量："| tee -a $log_file;
df -h $path| tee -a $log_file;
echo "开始释放$path目录磁盘空间...."| tee -a $log_file; 

echo "正在删除一周前被修改过的$pattern_out文件..." | tee -a $log_file; 
find $path -type f -name "$pattern_out" -mtime +6 -exec ls -ahl {} \; -delete | tee -a $log_file;
 
 echo "正在删除一周前被修改过的$pattern_log文件..."| tee -a $log_file; 
find $path -type f -name "$pattern_log" -mtime +6 -exec ls -ahl {} \; -delete | tee -a $log_file;
 
echo "正在清空大于10M的$pattern_log文件...."| tee -a $log_file; 
find $path -type f -name "$pattern_log" -size +10M -exec ls -alh {} \; -exec cp /dev/null {} \; | tee -a $log_file;

echo "正在清空大于10M的$pattern_out文件...."| tee -a $log_file; 
find $path -type f -name "$pattern_out" -size +10M -exec ls -alh {} \; -exec cp /dev/null {} \; | tee -a $log_file;

echo "正在清空nginx的日志"|tee -a $log_file;
> /usr/local/nginx/logs/access.log;
> /usr/local/nginx/logs/error.log;
> /usr/local/nginx/logs/host.access.log;
echo "nginx日志清理完毕"|tee -a $log_file;

echo "执行完毕！...."| tee -a $log_file;
echo "释放后$path容量："| tee -a $log_file;
df -h $path /| tee -a $log_file;

echo "---------------------------------------------------------------------------"| tee -a $log_file;
