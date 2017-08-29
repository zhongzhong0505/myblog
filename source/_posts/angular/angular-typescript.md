---
title: Angular为什么选择TypeScript？
date: 2017-08-29 11:04:43
tags: [angular,ts]
---

原文地址：https://vsavkin.com/writing-angular-2-in-typescript-1fa77c78d8e8

Angular是用TypeScript编写的。在这篇文章中，我将讨论为什么我们作出决定。我还将分享我使用TypeScript的经验：它如何影响我写和重构我的代码的方式。

## TypeScript有很好的工具

TypeScript的最大的卖点就是工具。它提供高级自动完成，导航和重构。拥有这样的工具几乎是大型项目的必备要求。没有他们，改变代码的恐惧使代码库处于半只读状态，并使大规模重构非常危险且昂贵。

TypeScript不是编译为JavaScript的唯一类型语言。还有其他语言具有更强的类型系统，在理论上可以提供绝对强大的工具。但在实践中大多数人除了编译器之外没有其他的东西。这是因为构建丰富的开发工具必须是第一天就明确的目标，它是针对TypeScript团队的。这就是为什么他们构建语言服务，可以由使用的编辑器提供类型检查和自动完成。如果您想知道为什么有这么多编辑器具有很好的TypeScript支持，答案就是语言服务。

智能感知和重构提示（例如：重命名变量）对代码编写过程和重构过程的重要性是不争的事实。虽然很难衡量，但我觉得现在之前要几天时间的重构可以在不到一天的时间内完成。

虽然TypeScript大大提高了代码编辑体验，但它使得开发人员设置更加复杂，特别是与在页面上放置ES5脚本相比。此外，您不能使用分析JavaScript源代码的工具（例如JSHint），但通常有足够的替代品。

## TypeScript是JavaScript的超集

由于TypeScript是JavaScript的超集，因此您无需经历大量重写即可迁移到JavaScript。你可以一个模块一个模块，逐步的迁移。

只需选一个模块，将.js文件重命名为.ts，然后逐步添加类型注释。完成一个模块之后，再挑选下一个重构模块。一旦编写了整个代码库，就可以开始调整编译器设置，使其更加严格。

这个过程可能需要一些时间，但是对于Angular来说，这还不是最大的问题。逐步迁移的过程，能够让我们保持开发新功能的同时来修复转换过程中的bug。

## TypeScript明确了抽象

一个好的设计是关于设计良好的接口。并且以支持它们的语言来表达接口的想法要容易得多。

例如，想象一个销售书籍的应用程序，可以通过用户界面的注册用户或通过某种API的外部系统进行购买。
![logo](info-01.png)

正如你所看到的，这两个类都扮演购买者的角色。尽管对应用极为重要，在代码中没有清晰的表达购买者的含义。没有名为buyeraser.js的文件。因此，有人可能会在不知道这段代码含义的情况下修改这个代码。

```
function processPurchase(purchaser, details){ } 

class User { } 

class ExternalSystem { }
```

只通过看代码来确定什么对象可以充当购买者的角色，这个角色有什么方法非常困难。我们不知道，我们不会从我们的工具中获得很多帮助。我们必须人为推断这个信息，这很慢，容易出错。

现在，将其与我们明确定义购买者接口的版本进行比较。

```
interface Purchaser {id: int; bankAccount: Account;} 

class User implements Purchaser {} 

class ExternalSystem implements Purchaser {}
```

具有类型的版本可以清楚的表示，有一个购买者的接口，然后有两个类实现了这个接口。所以TypeScript接口允许我们定义抽象/协议/角色。

重要的是要认识到，TypeScript不会强制我们引入额外的抽象。购买者抽象存在于JavaScript版本的代码中，但没有明确定义。


在静态类型的语言中，子系统之间的边界是使用接口定义的。由于JavaScript缺少接口，边界并没有在纯JavaScript中表达出来。不能清楚地看到边界，开发人员开始依赖于具体的类型而不是抽象接口，这代码耦合度非常高。

在开发Angular的过程中，在转换到TypeScript之前和之后的工作经验，坚定了我的想法。定义接口，强制我去考虑API的边界，帮助我去定义子系统的接口，并且暴露出耦合的地方。

## TypeScript使代码更容易阅读和理解

是的，我知道这看起来不直观。让我试着用一个例子来说明我的意思。我们来看看这个函数jQuery.ajax（）。们可以从签名中获得什么样的信息？

```
jQuery.ajax(url, settings)
```

我们唯一可以确定的是该函数有两个参数。我们可以猜出这些类型。也许第一个是一个字符串，第二个是一个配置对象。但这仅仅是猜测，我们可能会错。我们不知道什么选项进入设置对象（他们的名字和类型），或者这个函数返回什么。

我们没有办法在不查看源码或者文档的情况下调用此函数。检查源代码不是一个好的选择 - 功能和类的要点是能够在不知道它们如何实现的情况下使用它们。换句话说，我们应该依靠他们的接口，而不是依靠它们的实现。我们可以检查文档，但它不是最好的开发人员体验 - 它需要更多的时间，文档往往是过时的。

所以虽然很容易读取jQuery.ajax（url，settings），要真正了解如何调用这个函数，我们需要读取它的源码或其文档。

现在，将其与类型版本对比

```
ajax(url: string, settings?: JQueryAjaxSettings): JQueryXHR; 

interface JQueryAjaxSettings { 
  async?: boolean; 
  cache?: boolean; 
  contentType?: any; 
  headers?: { [key: string]: any; }; 
  //... 
} 

interface JQueryXHR { 
  responseJSON?: any; //... 
}
```

它给了我们更多的信息。

- 这个函数的第一个参数是一个字符串。
- settings参数是可选的。我们可以看到可以传递给函数的所有选项，不仅仅是它们的名字，还包括它们的类型。
- 该函数返回一个JQueryXHR对象，我们可以看到它的属性和函数。

键入的签名肯定比无类型的签名更长，但是：string，JQueryAjaxSettings和JQueryXHR并不混乱。它们是提高代码可理解性的重要文档。我们可以在更大程度上了解代码，而无需深入实施或阅读文档。我个人的经验是，我可以更快地读取类型化代码，因为类型提供了更多的上下文来了解代码。但如果任何读者可以找到关于类型如何影响代码可读性的研究，请发表评论。

与其他编译为JavaScript的语言相比，TypeScript的类型是可选的，jQuery.ajax(url, settings)仍然是有效的typescript。所以并不是非开即关，TypeScript更多的是增强。如果发现代码在读取和理解时没有类型注释是微不足道的，请不要使用它们。只有在增加价值的情况下使用他们。

## TypeScript是否限制表达？

动态类型的语言具有较差的工具，但它们更有韧性和表现力。我认为使用TypeScript会使得你的代码死板，但远比想象的程度要低。让我告诉你我的意思。假设我使用ImmutableJS定义个人记录。

```
const PersonRecord = Record({name:null, age:null}); 

function createPerson(name, age) { 
  return new PersonRecord({name, age}); 
} 

const p = createPerson("Jim", 44); 

expect(p.name).toEqual("Jim");
```

我们如何确定记录的类型？让我们来定义一个Person接口。
```
interface Person { name: string, age: number };
```

如果我们尝试执行以下操作：
```
function createPerson(name: string, age: number): Person { 
  return new PersonRecord({name, age}); 
}
```

TypeScript编译器就会警告，因为编译器不知道PersonRecord和Person类型兼容。一些有函数式编程经验的人会说：“TypeScript只有依赖类型！”。但是不是这样的。TypeScript的类型系统不是最先进的。但它的目标是不同的。这不是证明程序是100％正确的。它更多的是提供给你更多的提示信息和启用更强大的工具。所以当类型系统不够灵活时，可以采取快捷方式。所以我们可以转换创建的记录，通过下面这样：

```
function createPerson(name: string, age: number): Person { 
  return <any>new PersonRecord({name, age}); 
}

```

类型实例：

```
interface Person { name: string, age: number }; 

const PersonRecord = Record({name:null, age:null}); 

function createPerson(name: string, age: number): Person { 
  return <any>new PersonRecord({name, age}); 
} 

const p = createPerson("Jim", 44); 

expect(p.name).toEqual("Jim");
```

这段代码能够正常运行是因为类型系统是结构化的。只要创建的对象具有正确的属性-name和age，就能正常运行。

你需要以拥抱的心态去使用TypeScript的快捷方式。只有这样，你会发现使用这种语言非常的愉快。
例如，不要尝试添加类型到一些时髦的元编程代码 - 很可能你将无法静态地表达。遇到这种情况，可以配置类型检查忽略他们。这种情况下，你的代码不会失去太多的表达力，同时又具有工具化和可分析的特性。

这类似于试图获得100％的单元测试代码覆盖率。而95％通常不是那么困难，100％可能是具有挑战性的，可能会对您的应用程序的体系结构产生负面影响。

可选类型系统还保留了JavaScript开发工作流程。您的应用程序代码库的大部分可能会“损坏”，但您仍然可以运行它。TypeScript将继续生成JavaScript，即使类型检查器提示错误。这在开发过程中非常有用。

## 为什么使用TypeScript？

今天有很多选项可供前端开发人员使用：ES5，ES6（Babel），TypeScript，Dart，PureScript，Elm等。所以，为什么选择TypeScript？

让我们从ES5开始。ES5跟TypeScript相比，他不需要转换。这样可以使得你的构建设置保持简单。你不需要添加文件监视器，转换代码，生成source map。它就能工作。

ES6需要一个转换器，所以构建设置与TypeScript不会有很大的不同。但它是一个标准，这意味着每一个编辑器和构建工具都支持ES6或将支持它。这是一个较弱的论据，它曾经是大多数编辑器在这一点上具有优秀的TypeScript支持。

Elm和PureScript是具有强大类型系统的优雅语言，可以提供比TypeScript更多的功能。用Elm和PureScript编写的代码可能比ES5中类似的代码更简单。

每个这些选项都有利弊，但我认为TypeScript是一个很好的选择，使其成为大多数项目的绝佳选择。TypeScript占用良好静态类型语言的95％，并将其带入JavaScript生态系统。你仍然可以写ES6：你仍然可以继续使用相同的标准库，相同的第三方库，相同的成语和许多相同的工具（例如，Chrome开发工具）。它给了你很多，而不会强迫你离开JavaScript生态系统。
