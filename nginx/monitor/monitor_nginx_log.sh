#!/bin/bash
# $1 为https://sct.ftqq.com/的SENDKEY
# urlencode2() {
#     # urlencode <string>

#     old_lc_collate=$LC_COLLATE
#     LC_COLLATE=C

#     local length="${#1}"
#     for (( i = 0; i < length; i++ )); do
#         local c="${1:$i:1}"
#         case $c in
#             [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
#             *) printf '%%%02X' "'$c" ;;
#         esac
#     done

#     LC_COLLATE=$old_lc_collate
# }

#日志文件路径
logfile=/usr/local/openresty/nginx/logs/
filename=test.error.log

#当天日期,年月日
cur_date=`date +"%Y/%m/%d"`

#开始时间（3分钟前）,时分秒
start_time=`date -d"3 minutes ago" +"%H:%M:%S"`

#结束时间,时分秒
stop_time=`date +"%H:%M:%S"`

#新增的错误日志
error=`tac $logfile/$filename | awk -v st="$start_time" -v et="$stop_time" -v dt="$cur_date" '{t=$2;t1=$1; if(dt==t1 && t>=st && t<=et) {print $0}}'`
if [ ! -n "$error" ]; then  
  exit 0 
fi    

error=`urlencode $error`

# echo $error
curl -G https://sctapi.ftqq.com/{$1}.send --data-urlencode title=$error --data-urlencode desp=$error
