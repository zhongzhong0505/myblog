## 安装openresty
### mac
```js
    brew install homebrew/nginx/openresty
```
### linux
```js
tar -xzvf openresty-VERSION.tar.gz
cd openresty-VERSION/
./configure
make
```

## 创建工作目录
```js
cd
mkdir -p workspace/openresty
cd workspace/openresty
mkdir conf/ logs/
```
conf目录主要用来存储配置文件
logs目录主要用来存放日志文件

## 创建nginx.conf配置文件，内容如下：
```js
worker_processes  1;
error_log logs/error.log;
events {
    worker_connections 1024;
}
http {
    server {
        listen 8080;
        location / {
            default_type text/html;
            content_by_lua '
                ngx.say("<p>hello, world</p>")
            ';
        }
    }
}
```

## 测试启动nginx

```
/usr/local/Cellar/openresty/1.11.2.3/nginx/sbin/nginx -p ~/workspace/openresty/ -c conf/nginx.conf
```

以上的命令正常执行之后，打开浏览器访问：http://localhost:8080
应该可以看到hello, world输出。

到此，环境搭建完成。

## 将openresty中的nginx启动，重新加载的命令写成shell脚本，方便使用,在openresty目录下创建nginx.sh文件，内容如下：

```js
#!/bin/bash
if [ $1 == 'start' ]
then
    /usr/local/Cellar/openresty/1.11.2.3/nginx/sbin/nginx -p ~/workspace/openresty/ -c conf/nginx.conf
elif [ $1 == 'reload' ]
then
    /usr/local/Cellar/openresty/1.11.2.3/nginx/sbin/nginx -p ~/workspace/openresty/ -c conf/nginx.conf -s reload
fi
 
```

使用：
./nginx.sh start 启动
./nginx.sh reload 重新加载


