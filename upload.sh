#!/bin/bash

# 读取配置文件
. config.cfg

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
    echo "------------start upload, upload mode:$upload_mode, upload tasks num:${#upload_map[@]}----------"
fi

for (( i=0; i<${#upload_map[@]}; i++ ));
do
    mapStr=${upload_map[$i]}
    # 本地路径
    fromStr=$(echo $mapStr | cut -d":" -f1)
    # 云端文件夹
    toStr=$(echo $mapStr | cut -d":" -f2)
    filename="$(basename ${fromStr})"
    echo "start upload task: ${fromStr}------>${toStr}/${filename}"
    # 具体的上传操作
    ${exec_file} upload ${fromStr} ${toStr}
    echo "end upload task: ${fromStr}------>${toStr}/${filename}"
done
echo "------------end upload, upload mode:$upload_mode, upload tasks num:${#upload_map[@]}----------"