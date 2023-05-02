#!/bin/bash

# 读取配置文件
. config.cfg

# 上传文件
now_path="$(pwd)"

# 校验baiduPCS配置
exec_file=${pcsPath}
if [ "${exec_file}" = "" ] || ! [ -e "${exec_file}" ]; then
    echo "BaiduPcs路径有误"
fi

# 初始化cron配置
cronPath=/var/spool/cron/crontabs/root
if grep -q "centos" /etc/*-release; then
    cronPath=/var/spool/cron/root
fi
touch ${cronPath}

upload_command="${now_path}/main.sh upload"

if [ "${upload_map}" != "" ]; then
    if [ "${upload_frequercy}" = "" ]; then
        # 只执行一次
        ${upload_command}
    else
        # 周期执行
        # 检查定时任务是否已经存在
        if crontab -l | grep -q "${upload_command}"; then
            echo "上传定时任务已经存在，删除中"
            (crontab -l | grep -v "$upload_command") | crontab -r
        fi
        # 添加新的定时任务
        echo "${upload_frequercy} ${upload_command}" >> ${cronPath}
        echo "上传定时任务添加成功"
    fi
fi


# 下载文件
download_command="${now_path}/main.sh download"
if [ "${download_map}" != "" ]; then
    if [ "${download_frequency}" = "" ]; then
        # 只执行一次
        ${download_command}
    else
        echo "hello"
        # 周期执行
        # 检查定时任务是否已经存在
        if crontab -l | grep -q "$download_command"; then
            echo "下载定时任务已经存在，删除中"
            (crontab -l | grep -v "$download_command") | crontab -r
        fi
         # 添加新的定时任务
        echo "${download_frequency} ${download_command}" >> ${cronPath}
        echo "下载定时任务添加成功"
    fi
fi


