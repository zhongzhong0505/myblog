---
title: 【翻译】在VS Code中调试ES6代码
date: 2018-06-09 22:16:34
tags: [js,es,node, debugger]
---

我之前是做Java的。调试Java程序很简单。您只需将IDE配置为最新版本的JDK，使用所有最新的语法优点编写应用程序，添加断点并在调试模式下运行它。瞧！你正在调试...

<!-- more -->

现在我主要编写JavaScript（nodejs和浏览器）我经常惊讶于调试一个简单的ES6 JavaScript应用程序是多么复杂和繁琐。为什么我们不能告诉我们的编辑器/ IDE我们的目标JavaScript版本并开始调试？如果只是这么简单...

长久以来，我对JetBrains都非常满意，最近我切换到了VS Code。我经常喜欢尝试开源编辑，但我总是回到IntelliJ或WebStorm。Eclipse? NetBeans? Atom? Brackets? 尽管他们都试过，但都是很沮丧的回到IntelliJ的怀抱。然而，VS Code是我最近的一次冲击，看起来这种关系可能有机会。

现在我已经选定了一个编辑器，我真的很希望能够快速构建ES6应用程序并对其进行调试以解决问题。幸运的是，在几个小时的阅读文档和实验之后，我遇到了一个非常简单的方法来在VS Code中运行和调试服务器端ES6应用程序。

## 第一步 安装nodejs

我发现在VS Code中调试ES6最简单的方法是使用最新的Node.js版本。该版本使用新的“inspector”调试协议，比旧版本中使用的传统协议更加稳健。如果您尚未安装Node，请从此处安装它：[https://nodejs.org/en/](https://nodejs.org/en/)

如果你已经安装了nodejs，请这样检查版本：

```
node --version
```

如果您未运行版本8.x（或更高版本），则可以使用Node版本管理器（如“n”）安装最新版本：
[https://github.com/tj/n](https://github.com/tj/n)

或者nvm
[https://github.com/creationix/nvm](https://github.com/creationix/nvm)

就个人而言，我更喜欢“n”，但这两种解决方案都适用于安装和管理多个版本的Node。使用这些工具之一安装最新版本的Node，并确保已经切换到最新版本，就可以继续往下看了。


## 第二步 配置一个新的ES6项目

让我们创建一个非常简单的ES6的项目，并且在VS Code中启动它。

```
$ mkdir debug-es6 && cd debug-es6
$ npm init -f
$ code .
```

当然，这假定你已经安装了VS Code。如果没有，现在就做。

接下来，我们需要安装必要的Babel模块以便传输我们的代码。这个命令可以做到这一点：

```
$ npm install --save-dev babel-cli babel-preset-es2015
```

babel-cli是Babel编译器，babel-preset-es2015是增加ES6支持的插件。安装完成后，我们需要更新package.json文件或创建.babelrc文件，以便将Babel配置为使用ES6插件。为了简单起见，我们只需要像这样更新package.json：

```
  "devDependencies": {
    "babel-cli": "^6.24.1",
    "babel-preset-es2015": "^6.24.1"
  },
  "babel": {
    "presets": [
      "es2015"
    ]
  }
```

现在我们来编写一个我们可以调试的简单应用程序。继续在你的项目根目录下创建一个src文件夹，并且创建一个像src/math.js这样的文件：

```
export function add(num1, num2) {
  return num1 + num2;
}
export function multiply(num1, num2) {
  return num1 * num2;
}
```

还要创建一个src / app.js文件，它可以像下面这样使用我们的math模块：

```
import {add, multiply} from './math';
const num1 = 5, num2 = 10;
console.log('Add: ', add(num1, num2));
console.log('Multiply: ', multiply(num1, num2));
```

这应该足以建立一个基本的调试会话。让我们继续...

### 第三步 配置Babel以将ES6转储到ES5

调试ES6的第一步是配置一个转译器，将您的ES6代码转换为Node可以本地运行的东西。换句话说，就是转换成ES5。但除了编译代码之外，我们还需要生成source map文件，以允许VS代码中的节点调试器映射源代码和编译代码之间的断点。

当然，有些方法可以在不配置转换器的情况下进行调试。然而我们要这样的运气使用babel-node或者babel-register来调试。他们的调试环境看起来很脆弱，或者需要自定义代码来启动调试过程。我正在寻找一种简单的解决方案，可以在几乎所有情况下都能正常工作。配置Babel来传输代码并生成source map，似乎是开启调试的钥匙...

除了编译我们的代码并生成源代码地图之外，我们希望Babel继续监听我们代码的更改并在必要时重新编译。这样使我们的编写代码-编译-调试这一循环更加完善。为此，请在您的package.json文件中添加一个“compile”的脚本，如下所示：

```
"scripts": {
  "test": "echo \"Error: no test specified\" && exit 1",
  "compile": "babel src --out-dir .compiled --source-maps --watch"
},
```

该脚本将转换src文件夹中的代码并将结果输出到.compiled文件夹。 --source-maps和--watch选项指示Babel生成source map文件，并继续观察源文件的变化（并在发生变化时重新编译）。启动Babel编译器：

```
$ npm run compile
```

我们现在有一个基本的ES6应用程序，每当进行更改时都会自动进行编译。优秀！

## 第四步 添加启动配置

现在可以添加VS Code Launch Configuration，以便在调试模式下运行应用程序。在菜单栏中，单击“调试 - >打开配置”，然后在出现提示选择环境时选择“Node.js”。更新结果文件如下所示：

```
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Launch App.js",
      "program": "${workspaceRoot}/src/app.js",
      "outFiles": [ "${workspaceRoot}/.compiled/**/*.js" ]
    }
}
```

此配置中的type和request选项表明您将使用Node.js来运行ES6应用程序，而VS Code应该为您启动它（而不是附加到已经运行的Node进程）。program指定应用程序的入口点，outFiles告诉VS Code在哪里可以找到在执行程序期间实际使用的编译文件（和source map）。source map将允许编辑器将已编译的ES5代码映射回您的ES6源代码。

## 第五步 调试你的应用

创建启动配置后，让我们继续设置几个断点。您可以通过单击行号左侧的装订线来设置断点。在src / app.js的最后一行添加一个断点，并在src / math.js中的另一个函数内添加一个断点。通过单击左侧导航栏中的调试图标，从调试窗口顶部的下拉列表中选择“Launch App.js”启动配置，然后单击绿色的“Start Debugging “箭头。程序应该会停留在你的第一个断点处！

请注意，我们的启动配置设置为始终运行src / app.js应用程序。如果您想调试当前选中并在编辑器中可见的文件，该怎么办？您可以通过添加第二个启动配置来完成此操作。从菜单栏中选择“调试 - >打开配置”，复制/粘贴现有​​的启动配置，并修改副本，如下所示

```
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Launch App.js",
      "program": "${workspaceRoot}/src/app.js",
      "outFiles": [ "${workspaceRoot}/.compiled/**/*.js" ]
    },
    {
      "type": "node",
      "request": "launch",
      "name": "Launch Current File",
      "program": "${file}",
      "outFiles": [ "${workspaceRoot}/.compiled/**/*.js" ]
    }
}
```

您现在可以通过单击调试图标，从下拉列表中选择“Launch Current File”配置，然后单击绿色运行按钮来调试编辑器中当前可见的文件。

## 结论

呼！回顾这些步骤，看起来比实际工作要多得多。一旦习惯了添加Babel依赖并创建启动配置，为调试设置ES6项目实际上非常快。转译过程肯定会增加一些开销，但只需一点点努力，您将立即调试您的ES6项目。

原文地址：https://medium.com/@drcallaway/debugging-es6-in-visual-studio-code-4444db797954