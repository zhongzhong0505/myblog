---
title: windows下生成https证书
date: 2017-10-14 20:29:40
tags: [https,ssl]
---
1.下载openssl
下载地址http://gnuwin32.sourceforge.net/packages/openssl.htm

2.安装好openssl之后进入到openssl的安装目录下的bin目录
<!-- more -->

3.运行一下命令，生成密钥key

```
openssl genrsa -des3 -out f:/work/server.key 2048
```

f:/work/server.key:这个是生成的文件路径
这个命令执行的时候，会提示你输入密码，输入简单的123456或者别的都行

![输入图片说明](https://static.oschina.net/uploads/img/201710/13090221_3BNn.png "在这里输入图片标题")


生成完成之后，可以使用下面的命令去掉密码：

```
openssl rsa -in f:/work/server.key -out f:/work/server.key
```


3.创建证书的申请文件
```js
openssl req -new -key f:/work/server.key -out f:/work/server.csr
```

如果在执行上面的命令的时候出现以下错误：
Unable to load config info from /usr/local/ssl/openssl.cnf

这是因为openssl找不到对应配置文件，那么我们就需要弄到这个配置文件，如果你电脑安装了git的话，那么恭喜你，在git里面有这个文件，我们可以使用git下面的这个文件来执行上面的命令，修改一下，变成下面这样“

```
openssl req -new -key f:/work/server.key -out f:/work/server.csr -config "C:\Program Files\Git\mingw64\ssl\openssl.cnf"
```

注意，-config参数后面跟的路径要用引号引起来，什么原因你自己想。
运行上面的命令之后，根据提示输入国家简称，省市等信息，一直到最后就行。

4.创建一个CA证书

```
openssl req -new -x509 -key f:/work/server.key -out f:/work/ca.crt -days 3650 -config "C:\Program Files\Git\mingw64\ssl\openssl.cnf"
```

注意，上面的命令也需要加-config参数，不然也会报上面说的错误。


5.使用上面的证书申请文件和CA证书，来创建自己的证书

```
openssl x509 -req -days 3650 -in f:/work/server.csr -CA f:/work/ca.crt -CAkey server.key -CAcreateserial -out f:/work/server.crt
```

到这样证书才算创建好了，至于你要用到tomcat，nginx，随便你了。

参考：http://www.jianshu.com/p/9523d888cf77