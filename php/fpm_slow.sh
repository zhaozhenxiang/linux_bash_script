#!/bin/bash
# $1 为文件路径，/var/log/www.log.slow
# $2 为https://sct.ftqq.com/的SENDKEY 或者 tui.doit.am的key
# 该脚本检查前一分钟的数据，建议crontab每10分钟运行一次

if [ $# != 2 ] ; then
echo 'param count must be 2'
exit 1;
fi

#日志文件路径
logfile=$1
sendkey=$2
hostname=`hostname`

#开始时间（1分钟前）,时分秒
start_time=`date -d"10 minutes ago" +"%d-%b-%Y %H:%M"`
# start_time="14-Apr-2022 12:27"
start_time=${start_time: 0: 16}
echo $start_time
error=`tail -n1000 $logfile|grep "$start_time" -A3|grep -v public/index.php`
echo $error

if [ ! -n "$error" ]; then  
  exit 0 
fi
#echo $error
error=`urlencode $error`
# echo $error
# curl -G https://sctapi.ftqq.com/{$sendkey}.send --data-urlencode title=$hostname --data-urlencode desp=$error
curl -G http://tui.doit.am/dmp/html/tui_send_interface.php --data-urlencode sckey=$sendkey --data-urlencode title=$hostname --data-urlencode content=$error --data-urlencode url="http://api-cn.doiting.com/echo.html?echo="$error