---
title: 【Extjs】grid的store配置autoLoad=false无效的问题
date: 2017-07-18 22:51:27
tags: [extjs,js]
---

今天在使用Ext的grid的组件的时候，发现在grid的store中配置了autoLoad为false的时候，grid在渲染完成之后store还是自动加载了数据。找了许久，才发现原来是Ext的一个bug，所以在此记录一下，并把找到的问题的解决方法记录下来。

<!-- more -->

## 自定义组件

```js
    Ext.define('MyGrid',{
        extend:'Ext.grid.Panel',
        title:'MyGrid',
        layout:'fit'
    });
```

定义好自己的组件之后，页面打开之后，发现数据已经加载出来了。

## 解决方法

在网上搜索了之后，最后发现是如果在store中设置了remoteFilter=true，则store在初始化之后，就会加载数据。解决方法是通过重写Ext的ProxyStore类来修复这个问题。
下面是重写了之后的代码：
```js
待补充
```

重写的代码文件需要放在项目目录下的overrides文件夹中，默认没有生成这个文件夹，需要自己创建。重写的类名可以自己定义，但是override属性必须时需要重写的目标类名。