#!/bin/bash
echo "开始获取更新..."
git pull
echo "获取更新完成..."

echo "开始安装node模块..."
cnpm install
echo "开始安装node模块..."

echo "开始生成网站文件..."
hexo generate
echo "生成网站文件完成..."

echo "开始复制文件..."
rm -rf /usr/share/nginx/html/*
cp -r /root/workspace/myblog/public/* /usr/share/nginx/html
echo "复制完成..."
echo "成功将public文件夹中的内容移动到nginx服务器中！"
