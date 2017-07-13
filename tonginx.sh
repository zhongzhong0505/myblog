#!/bin/bash
git pull
cnpm install
hexo generate
rm -rf /usr/share/nginx/html/*
cp -r /root/workspace/myblog/public/* /usr/share/nginx/html
echo "成功将public文件夹中的内容移动到nginx服务器中！"
