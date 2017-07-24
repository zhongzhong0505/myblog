---
title: 【Extjs】数据包
date: 2017-07-24 08:27:57
tags: [extjs,js]
---

## 数据包（Data Package）

数据包用来加载和保存应用中的数据。它包含了众多的类，但是最重要的这三个：

这些类是：

* Ext.data.Model
* Store
* Ext.data.proxy.Proxy

以上的这些类几乎在每一个应用中都要用到。有需要其他的类来支持这些类。

![logo](extjs-data-package/data-model.png)

## 模型（Models）

数据包的核心是Ext.data.Model。模型表示应用程序中的实体。例如，一个电子商务应用可能包含的模型有Users，Products和Orders。在最简单的级别，一个模型定义一组字段和关联的业务逻辑。

我们来看几个模型的主要部分：
* Fields
* Proxies
* Validations
* Associations

## 创建一个模型

通常最好从一个普通的基类开始定义你的模型。这个基础类允许您轻松地在一个地方为所有模型配置一些通用的属性。它也是配置schema的好地方。schema用来管理应用程序中所有模型。现在我们将关注两个最有用的配置选项：

<!-- more -->

```js
Ext.define('MyApp.model.Base', {
    extend: 'Ext.data.Model',

    fields: [{
        name: 'id',
        type: 'int'
    }],

    schema: {
        namespace: 'MyApp.model',  // generate auto entityName

        proxy: {     // Ext.util.ObjectTemplate
            type: 'ajax',
            url: '{entityName}.json',
            reader: {
                type: 'json',
                rootProperty: '{entityName:lowercase}'
            }
        }
    }
});
```

你的模型基类，特别是“fields”属性，在不同的应用程序之中可能会有所不同。

## 代理

未完