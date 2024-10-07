# BdDiskSync

 个人有个小服务器，但是硬盘不太稳定，需要备份，考虑成本，采用百度网盘作为免费同步盘。

 PCS-GO + Cron定时实现

 项目基于大佬的BaiduPCS-Go实现

## 安装

git克隆即可使用


## 使用
1. 先安装BaiduPCS-Go，并登录，具体步骤见地址：https://github.com/qjfoidnh/BaiduPCS-Go
2. 配置upload.sh的参数
```bash
pcsPath - pcs-go的执行文件路径
webhook_key - 飞书机器人的key,可不配
upload_map - 上传路径, ":" 做分割, 不要有空格
```
3. 给予脚本执行权限，upload.sh  webhook.sh可配置飞书回调
```bash
chmod +x upload.sh; chmod +x ./app_back_sh/webhook.sh; 
```
4. 配置定时
```bash
# 每天9点上传
0 9 * * * cd {你克隆项目的路径};./upload.sh >> /root/baidu/exec.log 
```
