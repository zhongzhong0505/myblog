---
title: 【Extjs】类系统
date: 2017-07-15 08:52:14
tags: [extjs,js]
---


## 概述
Ext本身包括数百个类。我们迄今已有超过200万的开发人员，他们来自不同的背景和地点。在规模上
我们面临着提供一个通用代码架构的巨大挑战：
```
    - 简单易学
    - 快速开发，容易调试和无痛部署
    - 有组织，可扩展和可维护
```
因为js是一门弱化了类的，基于原型的一门语言，其最强大的功能之一就是灵活性。使用许多不同编码风格和技术的任何问题都有多种解决方案。然而，这带来了不可预测的代价。没有统一的结构，JavaScript代码可能难以理解，维护和重用。

基于类的编程，在另一外面来说，它是非常流行的面向对象编程模型。基于类的语言通常需要强类型，封装和标准编码约定。
通过使开发人员遵守一大套原则，代码更有可能随时间推移而可预测，可伸缩和可扩展。但是，该模型没有js的动态功能。

每种方法都有利弊，但是我们能够取两者之精华，去两者之糟粕吗？答案是肯定的，Extjs就是你可以使用的解决方案。

<!-- more -->

## 命名约定
在代码库中使用一致的命名约定，用于类，命名空间和文件名，有助于保持代码的组织，结构化和可读性。

## 类
类名只能包含字母数字字符。允许数字但不鼓励，除非它们属于技术术语。不要使用下划线，连字符或任何其他非字母数字字符。 例如：

```
MyCompany.useful_util.Debug_Toolbar 是不好的实践
MyCompany.util.Base64 是好的实践
```

适当的时候和使用对象属性的（.）访问时，类名应该分组成包。至少，他们应该有一个顶级的唯一的命名空间。
例如：
```
MyCompany.data.CoolProxy
MyCompany.Application
```

顶级的命令空间和实际的类名应该遵循CamelCase命名规范。其他的都是小写。
例如：
```
MyCompany.form.action.AutoLoad
```
不由Sencha分发的类不应该使用Ext作为顶级命名空间.

首字母缩写也应该遵循上面的Camel命名规范。例如：
```
Ext.data.JsonProxy 取代 Ext.data.JSONProxy
MyCompany.util.HtmlParser 取代 MyCompary.parser.HTMLParser
MyCompany.server.Http 取代 MyCompany.server.HTTP
```

## 源文件

类的名称直接映射到存储它们的文件路径，因此，每个文件只能有一个类。 例如：
```
Ext.util.Observable 存储在 path/to/src/Ext/util/Observable.js
Ext.form.action.Submit 存储在 path/to/src/Ext/form/action/Submit.js
MyCompany.chart.axis.Numeric 存储在 path/to/src/MyCompany/chart/axis/Numeric.js
```
<strong>path/to/src</strong>是你应用的所有类的源文件目录。所有类都应该保留在这个共同的根目录下，并且应该被正确地命名，为了最佳的开发，维护和部署经验。

## 方法和变量
```
1、和类名一样，方法和变量名称应该只包含字母数字。允许数字但不鼓励，除非它们属于技术术语。
不要使用下划线，连字符或任何其他非字母数字字符。 

2、方法和变量名称应该遵循camelCase命名规范。这也适用于首字母缩略词。


```

例如：

可接受的方法名称：
```
encodeUsingMd5()
getHtml() 取代 getHTML()
getJsonResponse() 取代 getJSONResponse()
parseXmlContent() 取代 parseXMLContent()
```

可接受的变量名：
```
var isGoodName
var base64Encoder
var xmlReader
var httpServer
```

## 属性