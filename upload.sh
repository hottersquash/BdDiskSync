#!/bin/bash

# baiduPcs-go路径
pcsPath="PCS-go路径"
# 设置webhook，目前只支持飞书
webhook_key="xxxxxx"
# 目录配置
upload_map="/root/mongo/data/db/backup_file:/apps/wky/mydisk/software/mongo"
# 校验baiduPCS配置
exec_file=${pcsPath}
if [ "${exec_file}" = "" ] || ! [ -e "${exec_file}" ]; then
    echo "BaiduPcs路径有误"
fi

# 上传任务
IFS=',' read -r -a upload_map <<< "$upload_map"
if [ ${#upload_map[@]} -eq 0 ]; then
    echo "------------upload_task is empty, end upload----------------"
else
    echo "------------start upload, upload tasks num:${#upload_map[@]}----------"
fi

for (( i=0; i<${#upload_map[@]}; i++ ));
do
    mapStr=${upload_map[$i]}
    # 本地路径
    fromStr=$(echo "$mapStr" | cut -d":" -f1)
    # 云端文件夹
    toStr=$(echo "$mapStr" | cut -d":" -f2)
    filename="$(basename "${fromStr}")"
    echo "start upload task: ${fromStr}------>${toStr}/${filename}"
    # 具体的上传操作
    ${exec_file} upload "${fromStr}" "${toStr}"
    echo "end upload task: ${fromStr}------>${toStr}/${filename}"
done
echo "------------end upload, upload tasks num:${#upload_map[@]}----------"
./app_backup_file/webhoook.sh ${webhook_key} "备份成功" "备份成功"