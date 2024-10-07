#!/bin/bash


function notify {
    webhook_url="https://open.feishu.cn/open-apis/bot/v2/hook/${1}"
    curl -X POST  $webhook_url \
        -H 'Content-Type: application/json' \
        -d '{
            "msg_type": "post",
            "content": {
                "post": {
                    "zh_cn": {
                        "title": "同步完成-'"$2"'",
                        "content": [
                            [
                                {
                                    "tag": "text",
                                    "text": "'"${3}"'"
                                }
                            ]
                                    ]
                            }
                        }
                }
            }'
}
# key, title, content
notify $1 $2 $3