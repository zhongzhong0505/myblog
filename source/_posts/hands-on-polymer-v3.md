---
title: 使用Polymer3.0预览版
date: 2017-11-27 21:05:30
tags: [polymer]
---

Polymer3.0预览版已经可以试验了，今天这部分将帮助你们开始使用。但是请注意，我们使用了
“试验”这个词。这是一个非常早期的预览版本，肯定有很多的缺陷。
<!-- more -->
但是，艺高人胆大-所以让我们继续。
## 获取工具
在开始之前，你需要更新到最新版本的Polymer Cli。
```js
npm install -g polymer-cli
```

你还需要安装Yarn包管理器来安装组件，如[前一篇文章](/2017/11/15/polymer3-preview/)所述。
有关说明请参考[Yarn安装页面](https://yarnpkg.com/en/docs/install)。

最后，您需要安装Chrome 61或更高版本或Safari 10.1才能运行预览代码。

## 使用Yarn安装依赖
Polymer的组件都发布到了npm中的@polymer命名空间下。使用Yarn来安装组件。

Polymer 3.0还没有初始化的模板，所以你需要从头开始创建你的项目。

开始一个新的Polymer 3.0 预览版项目：

1.初始化项目。创建一个新的目录，并且运行yarn init。
```js
yarn init
```
回答创建项目的步骤提示（在大多数情况下，你可以接受所有提示的默认值）。

2.编辑生成的package.json文件，添加flat属性：
```js
{
  "name":"my-app",
  "flat":true,
  ...
```

3.使用yarn add安装组件，这个命令等价于bower install --save。例如：
```js
yarn add @polymer/polymer@next
yarn add @webcomponents/webcomponentsjs
```
任何你之前使用Bower从Polymer和PolymerElements组织安装的组件，现在都可以从@polymer命名空间安装。请确保包含@next版本以获取3.0预览包。你可以从@wecomponents/webcomponentsjs安装填缝剂（这里不需要@next，因为你是用的是填缝剂的发布版本）。

## 备选Yarn设置

如果你还有其它的npm依赖，例如server，dev tools或者编译器，使用平铺结构安装所有依赖可能会导致版本冲突。在这种情况下，你可以：
* 使用--flat来安装web components
  将"flat":true从package.json文件中移除，然后添加--flat参数来安装前端组件。
  ```js
  yarn add --flat @polymer/polymer@next
  ```
  对于存在package.json文件的项目来说，这种方式不太具有破坏性。这种方式的有点是将所有的依赖关系保存在单个的node_modules文件夹中，但是，这也以为着每次添加组件的时候都需要记住--flat标志。

  * 使用单独的目录
    另一种方法是在package.json文件中使用"flat":true，并为需要嵌套的依赖项的包添加一个包含自己packge.json文件的子目录（例如：tools）。

## 使用模块
如果你不熟悉ES6模块，那么你可以了解很多关于ES6模块的知识。而这篇文章只会涉及一些关键的知识点。

如果你正在寻找ES6模块的详细资料，你可能需要阅读Axel Rauschmayer博士的[探索ES6](http://exploringjs.com/es6/ch_modules.html)这篇文章。

你也可以观看Sam Thorogood在Polymer Summit上关于ES6模块的讨论。
视频地址：https://youtu.be/fIP4pjAqCtQ?list=PLNYkxOF6rcIDP0PqVaJxqNWwIgvoEPzJi

## 安装依赖
你可以使用<script type="module">来导入HTML 模块。例如，你的index.html可能如下所示：
```html
<!doctype html>
<html>
  <head>
    <!-- Load polyfills. Same as 2.x, except for the path -->
    <script
        src="node_modules/@webcomponents/webcomponentsjs/webcomponents-loader.js">
    </script>

    <!-- Import the my-app element's module. -->
    <script type="module" src="src/my-app.js"></script>
  </head>
  <body>
    <my-app></my-app>
  </body>
</html>
```
在模块内部，你可以使用import语句导入一个模块：
```js
import {Element as PolymerElement}
    from "../node_modules/@polymer/polymer/polymer-element.js"
```

和Bower依赖关系一样，可重用的元素不应该在路径中包含node_modules（例如../@polymer/polymer/polymer-element.js）。

关于模块导入，有几个重要的事情需要注意：
* 像HTML导入一样，导入必须使用路径，而不是模块名。
* 导入的路径必须以"./","../"或者"/"开头。
* 导入语句只能在模块内部使用（即使用<script type="module">加载的外部文件或者内联脚本）。
* 模块始终以严格模式运行。

有集中形式的导入声明。在大多数情况下，元素模块注册一个元素，但是不导出任何符号，所以你可以使用这个简单的导入语句：
```js
import "../@polymer/paper-button/paper-button.js"
```

对于行为，你通常会明确导入的行为：
```js
import {IronResizableBehavior}
    from "../@polymer/iron-resizable-behavior/iron-resizable-behavior.js"
```

对于导出了多个成员的Async等工具模块，你可以导入单个的成员也可以导入整个模块：
```js
import * as Async from "../@polymer/polymer/lib/utils/async.js"

Async.microTask.run(callback);
```

不同的模块结构不同，直到我们的3.0的API文档发布之前，你可能需要查看源代码来确定给定模块的导出内容。

## 动态导入（还不完全）

有一个使用import()操作来动态导入模块的规范，但是还没用正式发布。这个操作的行为像一个函数，并返回一个Pormise对象：
```js
import('my-view1.js').then((MyView1) => {
  console.log("MyView1 loaded");
}).catch((reason) => {
  console.log("MyView1 failed to load", reason);
});
```

目前的Polymer CLI工具不支持转换动态导入，所以你现在还不能使用像PRPL这样的延迟加载模式。在产品发布之前，我们将努力增加对Polymer CLI和相关工具的动态导入支持。

如果您正在使用像Webpack这样的工具来使用自定义的构建设置，那么您现在可以使用动态导入，但这不在今天的文章范围之内。

## 定义元素
不是在HTML导入中定义元素，你将使用ES6模块来定义元素。除了你正在编写的js文件而不是html文件这个明显的区别之外，新格式有3个主要区别：
* 导入使用ES6的导入语法，而不是<link rel="import">
* 模板的定义通过提供的template的ge方法返回一个字符串，而不是<dom-module>和<template>元素。
* 使用export导出模块内部的成员，而不是全局定义（例如：当定义行为或者混合）

例子：
my-app.js
```js
// Element is the same as Polymer.Element in 2.x
// Modules give you the freedom to rename the members that you import
import {Element as PolymerElement}
    from '../node_modules/@polymer/polymer/polymer-element.js';

// Added "export" to export the MyApp symbol from the module
export class MyApp extends PolymerElement {

  // Define a string template instead of a `<template>` element.
  static get template() {
    return `<div>This is my [[name]] app.</div>`
  }

  constructor() {
    super();
    this.name = '3.0 preview';
  }

  // properties, observers, etc. are identical to 2.x
  static get properties() {
    name: {
      Type: String
    }
  }
}

customElements.define('my-app', MyApp);
```
正如你所看到的一样，除了上面列出的改变，其它的地方几乎和2.X的一样。到目前为止，对于2.X的API的改变都和动态导入有关。特别是不再支持Polymer.importHref函数。这将被ES6的动态导入所代替。

对于一个重用元素，Polymer元素类的导入将省略node_modules文件夹：
```js
import {Element as PolymerElement}
    from '../@polymer/polymer/polymer-element.js';
```

## 预览项目
预览或测试项目时使用新的--npm标志。

```js
polymer serve --npm
polymer test --npm
```
这个标志告诉devserver从node_modules而不是bower_components加载组件，并在package.json而不是bower.json中查找软件包名称。

确保你在Safari 10.1或Chrome 61或更高版本中加载你的项目。此时，CLI不会对模块进行任何转换，因此3.0仅适用于具有本机模块支持的浏览器。

## 升级现有项目
Polymer Modulizer工具将Polymer 2.x项目升级到Polymer 3.0的npm和ES6模块格式。这个工具处于非常早期的状态。有几个已知的问题应该在接下来的几周内解决。所以，如果遇到问题，不要担心 - 我们正在积极努力使其尽可能地易于使用。

原文地址：https://www.polymer-project.org/blog/2017-08-23-hands-on-30-preview.html