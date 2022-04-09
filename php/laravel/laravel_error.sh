#!/bin/bash

# $1 为文件路径，/usr/local/openresty/nginx/logs/test.error.log
# $2 为https://sct.ftqq.com/的SENDKEY 或者 tui.doit.am的key

if [ $# != 2 ] ; then
echo 'param count must be 2'
exit 1;
fi
#日志文件路径
logfile=$1
sendkey=$2
hostname=`hostname`
echo $logfile
#当天日期,年月日
cur_date=`date +"%Y/%m/%d"`

#开始时间（1分钟前）,时分秒
start_time=`date -d"100 minutes ago" +"%H:%M:%S"`

#结束时间,时分秒
stop_time=`date +"%H:%M:%S"`

#新增的错误日志
#error=`tac $logfile | awk -v st="$start_time" -v et="$stop_time" -v dt="$cur_date" '{t=$2;t1=$1; if(dt==t1 && t>=st && t<=et) {{for (i=6;i<=NF;i++)printf("%s ", $i);print ""}}}'|uniq`
#error=`tac $logfile | awk -v st="$start_time" -v et="$stop_time" -v dt="$cur_date" '{t=$2;t1=$1; if(dt==t1 && t>=st && t<=et) {print $0}}'|grep -Eo "request.+?HTTP"|uniq -uc`
#error=`tail -n10000 $logfile | awk -v st="$start_time" -v et="$stop_time" -v dt="$cur_date" '{t=$2;t1=$1; if(dt==t1 && t>=st && t<=et) {print $0}}'|grep -Eo "error:"`
#error=`tail -n10000 $logfile | awk -v st="$start_time" -v et="$stop_time" -v dt="$cur_date" '{print $2}'`
error=`tail -n1000 $logfile |grep -E "production.ERROR:" -A2`
if [ ! -n "$error" ]; then  
  exit 0 
fi    
#echo $error
#exit
error=`urlencode $error`
# echo $error
# curl -G https://sctapi.ftqq.com/{$sendkey}.send --data-urlencode title=$hostname --data-urlencode desp=$error
curl -G http://tui.doit.am/dmp/html/tui_send_interface.php --data-urlencode sckey=$sendkey --data-urlencode title=$hostname --data-urlencode content=$error