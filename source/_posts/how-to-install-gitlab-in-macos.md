---
title: 如何在mac上安装gitlab
date: 2017-12-02 17:43:00
tags: [gitlab,mac]
---

## 安装docker
下载地址：
  https://docs.docker.com/docker-for-mac/install/
<!-- more -->
下载下来是一个dmg的安装包，直接安装就可以了。

## 网络问题

嗯，在国内做开发必须谈网络问题，安装好docker之后，建议使用国内的docker镜像源，我用的是aliyun的。
- 首先你得有aliyun的账号：
- 然后进去到https://dev.aliyun.com/search.html页面
- 如果你登录了，进入到上面的页面，点击上面页面的【管理中心】
- 然后点击【镜像加速器】就可以按照提示配置了

## 安装portainer

portainer是一个Docker的可视化的管理工具。
使用下面的命名安装portainer：
```js
docker run -d -v "/var/run/docker.sock:/var/run/docker.sock" -p 9000:9000 portainer/portainer
```

上面的命令执行完成之后，打开浏览器访问：

localhost:9000

一开始会让你设置管理员密码，设置完成之后，进入系统，界面应该是下面这个样式的：

![](1.png)

在portainer可以很方便的管理你的Docker。推荐安装。

## 安装gitlab-ce

使用下面的命令安装gitlab-ce

```js
sudo docker run --detach \
    --hostname mygitlab.com \
    --publish 443:443 --publish 81:80 --publish 22:22 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```

上面的参数请自行查看docker文档，这里不解释。

安装完成之后，可以在portainer中的【containers】中查看所有的容器状态。


![](2.png)

如果gitlab的状态是created的话，那么你可以选中，点击【start】启动，启动成功之后应该是上图的状态。

然后打开浏览器访问：

localhost:81
或者
mygitlab.com:81


这个时候会要求你修改root账户的密码，输入2次密码确定就可以了。注意这个root账户是gitlab的账户不是你mac系统的root账户，不要搞错了。

到这里，在macos中搭建gitlab系统就算完成了。下一篇讲如何在gitlab中配置ci/cd。

