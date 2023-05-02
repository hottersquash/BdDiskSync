#!/bin/bash

# 读取配置文件
. config.cfg

exec_file=${pcsPath}

# 定义上传函数
function upload_manager {
    # 上传任务
    IFS=',' read -r -a upload_map <<< "$upload_map"
    if [ ${#upload_map[@]} -eq 0 ]; then
        echo "------------upload_task is empty, end upload----------------"
    else
        echo "------------start upload, upload mode:$upload_mode, upload tasks num:${#upload_map[@]}----------"
    fi

    # 创建云端默认文件夹
    if [ "$(${exec_file} ls ${upload_to_default} | grep "错误")" != "" ]; then
        ${exec_file} mdkir ${upload_to_default}
    fi

    for (( i=0; i<${#upload_map[@]}; i++ )); 
    do
        mapStr=${upload_map[$i]}
        # 本地路径
        fromStr=$(echo $mapStr | cut -d":" -f1)
        # 云端文件夹
        toStr=$(echo $mapStr | cut -d":" -f2)
        if [ "$mapStr" = "$fromStr" ]; then
            toStr=$upload_to_default
        fi
        filename="$(basename ${fromStr})"
        echo "start upload task: ${fromStr}------>${toStr}/${filename}"
        # 具体的上传操作
        upload ${fromStr} ${toStr}
        echo "end upload task: ${fromStr}------>${toStr}/${filename}"
    done
    echo "------------end upload, upload mode:$upload_mode, upload tasks num:${#upload_map[@]}----------"
}


# 上传具体实现
function upload {
    fromStr=$1
    toStr=$2
    filename="$(basename ${fromStr})"
    # overwrite模式：检查目标文件是否存在，存在即删除
    # increment模式：不进行删除
    if [ "$(${exec_file} ls ${toStr}/${filename} | grep "错误")" = "" ] && [ ${upload_mode} = 'overWrite' ]; then
        echo ${toStr}/${filename}"云端文件存在，删除中"
        ${exec_file} rm ${toStr}/${filename} >/dev/null
    fi
    # 开始上传
    ${exec_file} upload ${fromStr} ${toStr}
}


# 下载操作
function download_manager {
    # 上传任务
    IFS=',' read -r -a download_map <<< "$download_map"
    if [ ${#download_map[@]} -eq 0 ]; then
        echo "------------download task is empty, end download----------------"
    else
        echo "------------start download, download mode:$download_mode, download tasks num:${#download_map[@]}----------"
    fi

    # 创建默认文件夹
    if ! [ -e ${download_to_default} ]; then
        mkdir -p ${download_to_default}
    fi

    for (( i=0; i<${#download_map[@]}; i++ )); 
    do
        mapStr=${download_map[$i]}
        # 云端文件
        fromStr=$(echo $mapStr | cut -d":" -f1)
        # 本地路径
        toStr=$(echo $mapStr | cut -d":" -f2)
        if [ "$mapStr" = "$fromStr" ]; then
            toStr=$download_to_default
        fi
        filename="$(basename ${fromStr})"
        echo "start download task: ${fromStr}------>${toStr}/${filename}"
        # 具体的上传操作
        download ${fromStr} ${toStr}
        echo "end download task: ${fromStr}------>${toStr}/${filename}"
    done
    echo "------------end download, download mode:$download_mode, download tasks num:${#download_map[@]}----------"
}


# 下载具体实现
function download {
    fromStr=$1
    toStr=$2
    filename="$(basename ${fromStr})"
    # overwrite模式：检查目标文件是否存在，存在即删除
    # increment模式：不进行删除
    if [ ${download_mode} = 'overWrite' ]; then
        ${exec_file} download --ow -p ${download_thread_num} -l ${download_concurent_file_num} --retry ${download_retry} ${fromStr} --saveto ${toStr} >/dev/null
    else
        ${exec_file} download -p ${download_thread_num} -l ${download_concurent_file_num} --retry ${download_retry} ${fromStr} --saveto ${toStr} >/dev/null
    fi
}


# 选择执行
if [ $1 = "upload" ]; then
    upload_manager
elif [ $1 = "download" ]; then
    download_manager
fi