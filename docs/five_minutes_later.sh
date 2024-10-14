#!/bin/bash

# 获取当前时间的时间戳
current_timestamp=$(date +%s)

# 加上5分钟（300秒）
five_minutes_later=$((current_timestamp + 300))

# 将时间戳转换回日期格式
formatted_date=$(date -d @"$five_minutes_later" +"%Y-%m-%d %H:%M:%S")

echo "五分钟后的时间是: $formatted_date"