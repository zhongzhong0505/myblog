---
title: 【Extjs】alias和xtype的区别
tags: [extjs,js]
date: 2017-07-14 13:23:17
---


## 配置了xtype，不配置alias
```js
Ext.define("MyBtn",{
    extend:"Ext.Button",
    xtype:'aaa'
});
Ext.create('MyBtn', {
    text: 'Click me',
    renderTo: Ext.getBody(),
    handler: function(btn) {
        alert("xtype:"+btn.getXType());
        alert("xtypes:"+btn.getXTypes());
    }
});

//xtype:aaa
//xtypes:component/box/button/aaa
```
可以使用Ext.widget("aaa");创建对象实例

<!-- more -->

## 配置了alias，不配置xtype

```js
Ext.define("MyBtn",{
    extend:"Ext.Button",
    alias:'widget.aaa'
});

Ext.create('MyBtn', {
    text: 'Click me',
    renderTo: Ext.getBody(),
    handler: function(btn) {
        alert("xtype:"+btn.getXType())
        alert("xtypes:"+btn.getXTypes())
    }
});

//xtype:aaa
//xtypes:component/box/button/aaa
```

可以使用Ext.widget("aaa");创建对象实例


## 配置alias，也配置xtype

```js
Ext.define("MyBtn",{
    extend:"Ext.Button",
    xtype:'bbb',
    alias:'widget.aaa'
});

Ext.create('MyBtn', {
    text: 'Click me',
    renderTo: Ext.getBody(),
    handler: function(btn) {
        alert("xtype:"+btn.getXType())
        alert("xtypes:"+btn.getXTypes())
    }
});

//xtype:bbb
//xtypes:component/box/button/bbb/aaa
```

可以使用Ext.widget("aaa");创建对象实例
或者Ext.widget("bbb");创建对象实例
