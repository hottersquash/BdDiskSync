#!/bin/bash

dbHome=/data/db

today=$(date +'%Y-%m-%d %H:%M:%S')

logFile=backup.log

cd ${dbHome}

if ! [ -f ${logFile} ]; then
    touch ${logFile}
fi

# 备份文件路径
newDirName="leanoteDB"
newTarFile="leanoteDB.tar.gz"
# 旧文件路径
oldTarFile="leanoteDB.tar.gz.bak"


echo "${today}：开始备份" >> ${logFile}
mv ${newTarFile} ${oldTarFile}
mongodump -h localhost -d leanote -o ${newDirName}
# 备份脚本
#cp backup.sh ${newDirName}
#cp crontab.txt ${newDirName}
tar -czvf ${newTarFile} ${newDirName} > /dev/null
# 删除文件夹
rm -rf ${newDirName}
echo "${today}：备份完成\n\n" >> ${logFile}
