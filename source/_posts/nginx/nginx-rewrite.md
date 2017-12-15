---
title: nginx重写
date: 2017-10-25 22:30:49
tags: [nginx]
---
## 实例1:将uri匹配/game的，去掉game前缀

例如：/game/abc.html ——>  /abc.html

重写规则如下：
<!-- more -->
location ~* ^/game{
    rewrite (/game/)(.*)$ /$2 break;
    root /Users/zhongzhong/workspace/lean-css;
}

location部分：
第一部分~* 表示其后的第二部分是一个正则表达式，并且不区分大小写。
第一部分的值还可以是以下几种：

* 1.= 表示精确匹配，一旦匹配成功就不会再匹配其它
* 2.～ 表示区分大小写的正则表达式
* 3.^~ 表示字符串匹配
* 4./ 表示匹配所有请求

rewrite部分：

* 第一部分(/game/)(.*)$是一个正则表达式，包含2个分组。

* 第二部分,是重写之后的uri，在第二部分可以通过$1,$2…$n来获取第一部分中的分组的内容，在上面的例子中，通过$2来获取第二个分组的内容，也就是abc.html。

* 第三部分是一个标志位，又以下几个值可选：

    1.last 停止rewrite操作，开始使用重写后的uri重新走一次匹配过程。

    2.break  停止rewrite操作，使用重写后的uri定位文件位置。

    3.redirect 返回一个零时重定向的302状态码。

    4.permanent 返回一个永久重定向的301状态码。



参考：http://unixman.blog.51cto.com/10163040/1711943




