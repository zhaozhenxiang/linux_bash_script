#!/bin/bash

# $1 为文件路径，/usr/local/openresty/nginx/logs/test.error.log
# $2 为https://sct.ftqq.com/的SENDKEY

#日志文件路径
logfile=$1
sendkey=$2
hostname=`hostname`

#当天日期,年月日
cur_date=`date +"%Y/%m/%d"`

#开始时间（3分钟前）,时分秒
start_time=`date -d"3 minutes ago" +"%H:%M:%S"`

#结束时间,时分秒
stop_time=`date +"%H:%M:%S"`

#新增的错误日志
error=`tac $logfile | awk -v st="$start_time" -v et="$stop_time" -v dt="$cur_date" '{t=$2;t1=$1; if(dt==t1 && t>=st && t<=et) {print $0}}'`
if [ ! -n "$error" ]; then  
  exit 0 
fi    

error=`urlencode $hostname $error`
# echo $error
curl -G https://sctapi.ftqq.com/{$sendkey}.send --data-urlencode title=$error --data-urlencode desp=$error
