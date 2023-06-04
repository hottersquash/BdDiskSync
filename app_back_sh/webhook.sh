#!/bin/bash

today=$(date +'%Y-%m-%d %H:%M:%S')

function notify {
    webhook_url="https://open.feishu.cn/open-apis/bot/v2/hook/3a5f4598-e603-4a12-991d-c059a0fe9c37"
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