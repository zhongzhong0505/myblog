---
title: gitlab配置ci/cd
date: 2017-12-02 18:56:26
tags: [gitlab]
---

## 安装gitlab-runner

官方文档地址： https://docs.gitlab.com/runner/install/

注意，这里我们选择install as a Docker service。

1. 首先使用下面的命令来安装gitlab-runner

```js
docker run -d --name gitlab-runner --restart always \
  --link gitlab \ 
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest
```

如果你是用的是docker来运行gitlab和gitlab-runner的话，注意上面的--link参数，这里必须加上--link gitlab，其中gitlab是之前我们运行gitlab的时候指定的容器名称。这样之后，等于是让gitlab-runner连接上了gitlab这个容器，这样在gitlab-runner容器中就可以访问到gitlab这个容器了。更多内容，请自行查看docker文档。

安装完成之后，在portainer中就可以看到这个容器了。
![](1.png)

## 配置gitlab-runner

如果要使gitlab-runner工作的话，需要让gitlab
-runner知道你的gitlab安装在哪个地址，以及注册用的token。

使用下面的步骤来在gitlab中注册runner。

1. 运行下面的命令
```js
docker exec -it gitlab-runner gitlab-runner register
```

2. 输入gitlab的url地址
Please enter the gitlab-ci coordinator URL (e.g. https://gitlab.com/):
```
http://gitlab
```

注意这里的url地址，是http://容器的名称。

3. 输入token
Please enter the gitlab-ci token for this runner:
后面的步骤根据提示输入即可。

token查看地址： http://localhost:81/admin/runners

4. 接下来的2步输入描述，输入标签，自己输入即可。

5. 是否运行在没有tag的build上面。在配置gitlab-ci的时候，会有很多job，每个job可以通过tags属性来选择runner。这里为true表示如果job没有配置tags，也执行。
Whether to run untagged builds [true/false]:
```
true
```
6. 是否锁定runner到当前项目。
Whether to lock the Runner to current project [true/false]:

```
true
```

7. 选择executor，这里列出了很多executor，具体区别可以看这里：https://docs.gitlab.com/runner/executors/README.html

Please enter the executor: parallels, ssh, virtualbox, docker-ssh+machine, kubernetes, docker, docker-ssh, shell, docker+machine:
```
docker
```
8. 执行的默认docker image，上面一步选择了docker，所有这里是docker的配置。
Please enter the default Docker image (e.g. ruby:2.1):
```
alpine:latest
```
这里设置的是alpine，这是一个基于Alpine Linux的最小的Docker镜像。

## 在项目中启用runner
使用管理员账户登录gitlab，访问 http://mygitlab.com:81/admin/runners 这个地址，
在页面的底部可以看到已经注册成功的runner。
在这里可以点击runner进入配置，可以给runner指派项目。指派的项目就可以使用该runner了。

## 在项目中添加.gitlab-ci.yml
在gitlab中创建一个测试项目，然后添加.gitlab-ci文件
添加以下内容：
```
test:
  script:
    - ls
```
上面test表示一个job的名称，script是这个job要执行的命令。
还可以设置tags，only等参数，具体可以参考： https://docs.gitlab.com/ee/ci/yaml/#shallow-cloning

提交之后，就会在Pipelines中看到正在执行job。

## 问题记录
fatal: unable to access
http://gitlab-ci-token:xxxxxxxxxxxxxxx@mygitlab.com/zhongzhong/cicd-test.git/
failed to connect to mygitlab port 80 : connetion refused

解决：出现这个问题的原因好像是gitlab-runner在拉取代码的时候，没有解析到
mygitlab.com，查看gitlab-runner的host文件，里面有mygitlab的映射。暂时通过将gitlab中的extenar_url修改为gitlab容器在docker中的ip地址。

```
docker exec -it gitlab vi /etc/gitlab/gitlab.rb
```

```
external_url 'http://172.17.0.3'
```

这样之后，就不会在出现上面的错误了。

