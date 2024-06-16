#!/bin/bash

set -e

counter=0
log_file="sensors_log.txt"

# 获取系统信息
kernel_version=$(uname -r)
os_version=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d'"' -f2)
cpu_info=$(grep "model name" /proc/cpuinfo | head -n1 | cut -d':' -f2-)

while true; do
    clear
    counter=$((counter + 1))
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    
    # 获取处理器温度和网卡温度
    sensors_output=$(sensors)
    
    # 提取处理器核心温度
    proc_temps=$(echo "$sensors_output" | grep -i 'core' | awk '{print $1, $2, $3, $4}')
    
    # 提取网卡温度，排除包含 'temp1' 的行
    net_temps=$(echo "$sensors_output" | grep -i 'temp' | grep -v 'core' | grep -v 'temp1' | awk '{print $1, $2, $3, $4}')
    
    # 获取处理器实时频率
    cpu_freq=$(grep "cpu MHz" /proc/cpuinfo | awk '{printf "%.2fMHz ", $4}')
    
    # 在屏幕上显示结果
    echo "第 $counter 秒测试结果，时间：$timestamp"
    echo "=============================================="
    echo "操作系统版本: $os_version"
    echo "内核版本: $kernel_version"
    echo "CPU信息: $cpu_info"
    echo "----------------------------------------------"
    echo "处理器实时频率: $cpu_freq"
    echo "----------------------------------------------"
    echo "处理器核心温度:"
    echo "$proc_temps"
    echo "----------------------------------------------"
    echo "网卡温度:"
    echo "$net_temps"
    echo "=============================================="
    
    # 将结果写入日志文件
    {
        echo "第 $counter 秒测试结果，时间：$timestamp"
        echo "=============================================="
        echo "操作系统版本: $os_version"
        echo "内核版本: $kernel_version"
        echo "CPU信息: $cpu_info"
        echo "----------------------------------------------"
        echo "处理器实时频率: $cpu_freq"
        echo "----------------------------------------------"
        echo "处理器核心温度:"
        echo "$proc_temps"
        echo "----------------------------------------------"
        echo "网卡温度:"
        echo "$net_temps"
        echo "=============================================="
        echo ""
    } >> "$log_file"
    
    sleep 1
done
