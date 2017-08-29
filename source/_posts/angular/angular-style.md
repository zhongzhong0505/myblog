---
title: 【翻译】Angular高级样式指南（V4+）
date: 2017-08-29 10:42:24
tags: [angular,ts]
---

原文地址：https://medium.com/google-developer-experts/angular-advanced-styling-guide-v4-f0765616e635

了解如何使用Shadow DOM选择器，Light DOM，@HostBinding，ElementRef，Renderer，Sanitizer等。

<!-- more -->

![输入图片说明](info-01.png)

在这个指南中，我们将介绍Angular的组件和指令中可选的各种属性。会覆盖以下方面：

- Angular的封装模式： emulated, native 和 disabled。
- 浏览器支持， Shadow DOM 对比 Light DOM。
- @Component的样式元数据： 内联, 模版内联和外部样式。
- 使用ngClass和ngStyle指令。
- Shadow DOM选择器：:host, :host()， :host-context()， :host /deep/ selector，:host >>> selector。
- 使用@Component.host 和@HostBinding。不安全的样式。
- 使用ElementRef和nativeElement API（Web）。
- 使用Renderer和setElementClass / setElementStyle API（Web，Server，WebWorker）。
- CSS样式的特殊性和执行顺序。

您可以使用这个来浏览最终的代码[Plnkr](https://plnkr.co/edit/WUjoC897CXuybWvL9qt1?p=preview)


## 介绍

Angular应用的样式使用从未如此灵活。Angular组件体系结构提供了一种新的样式模型，通过使用Web Component规范中的Shadow DOM（模拟或本机）隔离组件样式。每个组件的样式都是在组件范围内的，因此它们不会影响UI的其他区域。

对于这篇文章，我们将使用一个组件来渲染显示一些不同样式选项的歌曲曲目。这个组件将呈现一首歌曲的封面，标题和艺术家。

```js
@Component({
  selector: 'song-track',   // <song-track></song-track>
})
export class SongTrack { }
```

请参考下面的最终效果：
![输入图片说明](info-02.gif)

## Angular封装模式

在进一步探索不同的样式方法之前，让我们快速查看所有可用的封装模式。

### Emulated（仿真）(默认)

使用此模式时，Angular将使用两个独特的属性来识别每个组件：_nghost- *和_ngcontent- *。使用这些属性将任何组件样式添加到head，以隔离样式，如下面的示例所示。

```js
<head>
  <style>
    .container[_ngcontent-ikt-1] { ... } 
  </style>
</head>
<body>
  <my-app>
    <song-track _nghost-ikt-1>
      <div _ngcontent-ikt-1 class="container"></div>
    </song-track>
  </my-app>
</body>
```

注意以粗体显示添加到组件的根和内容中的属性。您可以使用下面的代码显式激活此模式。

```js
@Component({
  selector: 'song-track',
  encapsulation: ViewEncapsulation.Emulated
})
```

**Emulated可以实现跨浏览器的最佳支持。**

### Native（本地）封装

此封装将设置Angular为特定组件使用Native Shadow DOM。根据浏览器，这将是v1规范（Chrome）。

```js
@Component({
  selector: 'song-track',
  encapsulation: ViewEncapsulation.Native
})
```

这将显示以下内容。

```html
<body>
  <my-app>
    <song-track>    
      ▾ #shadow-root (open)    
        <style>.container { ... }</style>   
        <div class="container"></div>
    </song-track>
  </my-app>
</body>
```

请注意，样式如何封装在＃shadow-root下。稍后将介绍具体的样式选项。

**某些浏览器不支持Native封装。[检查](http://caniuse.com/#feat=shadowdomv1)当前的支持。**

### Disabling（禁用）封装

我们还可以为特定的组件完全禁用封装。

```js
@Component({
  selector: 'song-track',
  encapsulation: ViewEncapsulation.None
})
```

通过使用此模式，Angular将向head添加任何定义的样式，因此可以使用此封装在组件之间共享样式。

## Native Shadow DOM浏览器支持

此时，Native Shadow DOM仍然不被广泛支持。请参阅下面的仿真和本机浏览器支持比较。

仿真：

![输入图片说明](info-03.png)

本地：

![输入图片说明](info-04.png)

## Shadow DOM与Light DOM

在对我们的组件进行样式化时，可以帮助区分Shadow DOM和Light DOM。

- Shadow DOM：组件创建或管理的任何本地DOM元素。这也包括任何子组件。
```js
<song-track title="No Lie" artist="Sean Paul..."></song-track>
@Component({
  selector: 'song-track',
  template: `        
     <track-title>{{track}}</track-title>
     <track-artist>{{artist}}</track-artist>`
})
export class SongTrack { }
```

- Light DOM：组件的任何子DOM元素。也称为投影内容（ng-content）。

```js
<song-track>
  <track-title>No Lie</track-title>
  <track-artist>Sean Paul, Dua Lipa</track-artist>
</song-track>
@Component({
  selector: 'song-track',
  template: `<ng-content></ng-content>`
})
export class SongTrack { }
```

## @Component样式元数据

为了调整我们的组件，我们可以使用组件元数据。

**Angular将按照下面使用的相同顺序添加标题中的样式。**

### 使用内联样式

当我们将样式添加到与组件相同的文件中时。首先在顶部以数组的方式添加：

```js
@Component({
  selector: 'song-track',
  styles: [`.container { color: white; }`]
})
export class SongTrack { }
```
### 使用模板内联样式

我们还可以使用此功能将我们的样式嵌入到我们的模板中。在顶部添加：

```js
@Component({
 template: `
   <style>
   .container { color: deepskyblue; }
   </style>   
   <div class="container">...</div>
 `
})
export class SongTrack { }
```

### 使用外部文件

当我们的组件需要更复杂的样式时，我们可以使用外部文件。

```js
//song-track.component.css
.container { ... }
//song-track.component.ts
@Component({
  styleUrls: ['./song-track.component.css'],
})
export class SongTrack { }

```

作为CSS规范的一部分，我们还可以使用@import从其他样式表导入样式。@import必须在样式表的第一行。

```js
@import 'common.css';
.container { ... }
```

## 使用ngClass和ngStyle指令

我们可以使用ngClass和ngStyle指令来动态地调整我们的组件。我们来看一些常见的用法。

```html
<song-track ngClass="selected" class="disabled"></song-track>
<song-track [ngClass]="'selected'"></song-track>   
<song-track [ngClass]="['selected']"></song-track> 
<song-track [ngClass]="{'selected': true}"></song-track>
```

请注意，ngClass可以与现有的类属性组合，也可以不使用任何绑定。要定位多个类，我们可以使用扩展语法和一些有趣的变体.

```html
<song-track ngClass="selected disabled">             
<song-track [ngClass]="'selected disabled'">      
<song-track [ngClass]="['selected', 'disabled']">   
<song-track [ngClass]="{'selected': true, 'disabled': true}">
<song-track [ngClass]="{'selected disabled': true}">
```

对于ngStyle，我们可以做同样的事情，但是由于我们需要键值对，选项较少。

```html
<song-track [ngStyle]="{'color': 'white'}" style="margin: 5px;"><song-track [ngStyle]="{'font-size.px': '12'}">
<song-track [ngStyle]="{'font-size': '12px'}">
<song-track [ngStyle]="{'color': 'white', 'font-size': '12px'}">
```

注意扩展单元语法匹配现有的[CSS测量单位](https://www.w3.org/Style/Examples/007/units.en.html)。要应用多种样式，您可以添加更多属性。

## 使用Shadow DOM选择器

当使用模拟或本机封装时，我们可以访问仅适用于Shadow DOM的一些有趣的CSS选择器。

### 装饰容器（又名宿主）

如果我们需要访问我们的容器或与其他选择器一起使用，我们可以使用:host伪类选择器。

```css
:host { color: black; }          // <song-track>
:host(.selected) { color: red; } // <song-track class="selected">
```

第一个例子将匹配song-track元素并且增加color样式。第二个例子将匹配具有selected类的song-track元素并且增加color样式。

### 样式依赖于祖先元素

我们可以添加一个这样的样式，它会在组件的宿主元素的祖先元素中查找匹配的祖先元素直到文档的根。

```css
:host-context(.theme) { color: red; }   
:host-context(#player1) { color: red; }
```

上面的例子只有当theme这个样式类在组件宿主元素的祖先元素中存在的时候，才会应用指定的样式。第二个例子是使用id=“player1”来匹配祖先元素。

### 装饰宿主元素或后代元素（跨边界）

这个选项将会覆盖任何封装的样式配置包括宿主元素的子元素。此选择器将适用于Shadow和Light DOM。

**我们可以使用/deep/覆盖Shadow DOM的边界**

```css
:host  /deep/ .selected { color: red; }
:host   >>>   .selected { color: red; }
```

**注意：**在Angular-cli中使用/deep/而不是>>>。

## 使用@Component.host

通过使用这个属性，我们可以绑定DOM Properties，DOM Attributes和事件。查看以下不同选项的概述。

```js
@Component({
 host: {
  'value': 'default',                    //'DOM-prop': 'value'  
  '[value]': "'default'",                //'[DOM-prop]': 'expr'   
  
  'class': 'selected',                   //'DOM-attr': 'value'
  '[class]': "'selected'",               //'[DOM-attr]': 'expr'
 
  '(change)': 'onChange($event)',        // (event) : ...   
  '(window:resize)': 'onResize($event)', // (target:event) : ...
 } 
})
```

让我们看一些使用类和样式DOM属性的例子。

```js
@Component({
  host: {
    //setting multiple values
    'class': 'selected disabled',
    'style': 'color: purple; margin: 5px;',
    
    //setting single values (using binding)
    '[class.selected]': 'true',    
    '[class.selected]': '!!selected', //add class if selected = true
    '[style.color]': '"purple"'   //expression must be a string
  } 
})
export class SongTrack { }
```

注意使用方括号来创建绑定。这就是为什么'true'成为布尔值true。对于CSS属性color，我们需要传递一个字符串。

### 绑定不安全表达式

为避免滥用某些样式表达式可能被Angular标记为不安全。

```js
@Component({
  host: {
    '[style]': '_hostStyle' //unsafe
  } 
})
export class SongTrack { }
```

如果遇到这个特殊问题，可以通过在Sanitizer上使用bypassSecurityTrustStyle API来将表达式标记为安全。

```js
export class SongTrack {
  constructor(private sanitizer: Sanitizer){
    this._hostStyle = this.sanitizer
      .bypassSecurityTrustStyle('color: black;');
  }
}
```

## 使用@HostBinding

我们也可以使用@HostBinding装饰器来设置我们的样式。参见下面的一些例子。参见下面的一些例子。

```js
export class SongTrack {   
  //<host class="selected"></host>   
  @HostBinding('class.selected') selected = true;
  //<host style="color: red;"></host>     
  @HostBinding('style.color') color = 'red';
}
```

**@HostBinding装饰器被翻译成@ Component.host元数据。**

## 使用ElementRef和nativeElement API（浏览器）

有时我们可能想要访问底层的DOM元素来操纵它的样式。为了做到这一点，我们需要注入ElementRef并访问nativeElement属性。这将使我们能够访问DOM API。

```js
export class SongTrack {
  constructor(private element: ElementRef){
    let elem = this.element.nativeElement;
    elem.style.color = "blue";
    elem.style.cssText = "color: blue; ..."; // multiple styles
    elem.setAttribute("style", "color: blue;"); 
  }
}
```

**请注意，此选项将适用于浏览器平台，但不适用于桌面或移动设备。**

## 使用Renderer和setElementClass / setElementStyle API（Web，服务器，WebWorker）

比使用ElementRef来设置我们的样式的更安全的替代方法是使用Renderer的setElementClass和setElementStyle方法。

他们使用了抽象层次来克服由于使用ElementRef带来的跨平台的兼容性问题。

```js
export class SongTrack {
  constructor(
     private element: ElementRef,
     private renderer: Renderer
  ){
    let elem = this.element.nativeElement;
    renderer.setElementStyle(elem, "color", "blue");
    renderer.setElementClass(elem, "selected", true);
  }
}
```

## CSS样式的特殊性和执行顺序

所有样式遵循以下特殊性和顺序规则：

- 越具体的样式优先级越高
- 具有相同的特性，应用的最后一个样式规则将覆盖任何先前的样式规则

下面列出的是从低到高的样式优先级：

组件：


- 定义在@Component.styles的样式 (按照数组顺序)
- 模版内联样式
- 定义在@Component.styleUrls的外部样式 (按照数组顺序)


容器：


- 内联样式。例如： <... style="">
- ngClass 和 ngStyle


所以如果我们使用ngStyle，这将覆盖元素上定义的任何内联样式以及之前的任何内容。

**作为Angular渲染执行和组件生命周期的一部分，样式能够静态和动态地应用。**

请注意，根据执行顺序，我们可能会得到另一个覆盖的样式。例如，首先应用@ Component.host，然后应用@Hostbinding。