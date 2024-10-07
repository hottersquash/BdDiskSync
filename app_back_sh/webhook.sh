#!/bin/bash

today=$(date +'%Y-%m-%d %H:%M:%S')

function notify {
    webhook_url="https://open.feishu.cn/open-apis/bot/v2/hook/{飞书机器人密钥}"
    curl -X POST  $webhook_url \
        -H 'Content-Type: application/json' \
        -d '{
            "msg_type": "post",
            "content": {
                "post": {
                    "zh_cn": {
                        "title": "同步完成-'"$1"'",
                        "content": [
                            [
                                {
                                    "tag": "text",
                                    "text": "'"${today}"'"
                                }
                            ]
                                    ]
                            }
                        }
                }
            }'
}

notify $1