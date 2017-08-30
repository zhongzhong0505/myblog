---
title: javascript模块
date: 2017-08-29 17:27:45
tags: [js]
---

## es6之前的模块？

在es6之前，如果我们需要引入一个外部的库，可能是像下面这样子的：

引入Jquery
```js
<script src="https://cdn.bootcss.com/jquery/3.2.1/core.js"></script>
```

<!-- more -->

然后在js中可以像下面这样使用：

```js
$(function(){
    $('.aaa').on('click',function(){
        //...
    });
});
```

在es6之前，几乎所有的第三方类库，都是通过上面这种形式引入的。
这种形式的引入会有下面一些问题：

- 全局变量污染
    每个第三方的类库基本都是定义了一个唯一的全局变量，然后将所有的函数，属性都封装到这个变量上面。
- script标签顺序有严格的依赖
    所有的类库基本上都需要依赖jQuery，在引入自己的类库文件之前必须引入jQuery的类库。

## 创建es6的模块

在es6的规范中，引入了模块的概念。

例如现在我有一个a.js文件，这里面封装了一个模块，然后需要给外部提供一些接口。内容如下：

```js

let p1 = 'abc';
const m1 = {
    fn:()=>{
        console.log('from a module...p1='+p1);
    }
};

export { m1 };

```


## 使用es6模块

上面我们已经写好了一个模块，下面来看一下如何使用这个模块。
**注意：**在chrome浏览器中，默认是不支持模块的。

解决办法：
在chrome浏览器中访问：chrome://flags/
然后找到Experimental Web Platform features项，点击启用。重启浏览器之后生效。

接下来我们再创建一个模块和一个用来使用这些模块的html页面

b.js的内容如下：
```js
//导入a.js模块
import { m1 } from './a.js';

//调用模块的方法
m1.fn();

```
index.html的内容如下：
```js
<!doctype html>
<html>
    <head>
        <script type="module" src="./b.js"></script>
    </head>
</html>
```

**注意：**
- 这里的script标签的type必须是module才行。
- 需要使用一个web服务器来运行上面的内容，否则浏览器会报跨域的错误


这里推荐使用轻量级的http-server作为web服务器来运行上面的内容。
使用以下命令安装http-server:
```js
cnpm install -g http-server
```

如果你没有安装cnpm的话，请先安装cnpm。
到此，我们来看一下我们的目录结构：
![效果图](info-03.png)

在此目录下运行：
```js
http-server
```

然后访问：http://127.0.0.1:8080

查看下图：
![效果图](info-01.png)

从上图中可以看出，此时模块b的作用域链的活动对象中，包含了导入的模块a，也就是说，此时在b模块中，可以访问到a模块。


控制台输出如下：
![效果图](info-02.png)

到此，我们已经初步了解了es6模块的创建已经使用。

## import和export

参考链接：https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/export

在模块中，除了可以像上面a.js中那样，导出一个模块，还支持以下导出方式：

- export { name1, name2, …, nameN };
- export { variable1 as name1, variable2 as name2, …, nameN };
- export let name1, name2, …, nameN; 
- export let name1 = …, name2 = …, …, nameN; 

- export default expression;
- export default function (…) { … } 
- export default function name1(…) { … } 
- export { name1 as default, … };

- export * from …;
- export { name1, name2, …, nameN } from …;
- export { import1 as name1, import2 as name2, …, nameN } from …;


除了像b.js中那样，导入一个模块之外，还支持以下方式的导入：

- import defaultMember from "module-name"; 
- import * as name from "module-name"; 
- import { member } from "module-name"; 
- import { member as alias } from "module-name"; 
- import { member1 , member2 } from "module-name"; 
- import { member1 , member2 as alias2 , [...] } from "module-name"; 
- import defaultMember, { member [ , [...] ] } from "module-name"; 
- import defaultMember, * as name from "module-name"; 
- import "module-name";


下面具体来看几种方式的使用：

### 第一种：导出多个成员
将a.js的内容修改为如下：
```js
let p1 = 'abc';
const m1 = {
    fn:()=>{
        console.log('from a module...p1='+p1);
    }
};

export { m1 , p1 };
```

b.js的内容修改为如下：
```js
//导入a.js模块
import { m1,p1 } from './a.js';

//调用模块的方法
m1.fn();

console.log(p1);
```

刷新页面，查看控制台输出：
![效果图](info-04.png)

### 第二种：通过as指定导出别名

修改a.js的内容，改为如下：
```js
let p1 = 'abc';
const m1 = {
    fn:()=>{
        console.log('from a module...p1='+p1);
    }
};

export { m1 as m, p1 as p };
```
as可以指定导出别名。

b.js修改如下：
```js
//导入a.js模块
import { m , p } from './a.js';

//调用模块的方法
m.fn();

console.log(p);
```

注意，import语句中，导入的名称必须和export导出的一致。

将b.js修改

### 第三种：默认导出

修改a.js内容如下：
```js
let p1 = 'abc';
const m1 = {
    fn:()=>{
        console.log('from a module...p1='+p1);
    }
};

export default { m1 }
```
注意，默认导出只能导出一个成员。

修改b.js内容如下：
```js
//导入a.js模块
import abc from'./a.js';

//调用模块的方法
abc.m1.fn();

```
看下图：
![效果图](info-05.png)

从图中可以看出，导入的对象层级结构，发现和上面的情况不一样。这是因为，这里的abc相当于定义的一个变量用来接收a模块中的默认导出对象。 类似下面的赋值语句：
```js
let abc = {m1:{...}}
```
也就是说export default其实就是导出了一个名称为default的对象。
类型下面的代码：
```js
//a
const default = {...}

//b
const abc = default;
```

注意这里不能使用{abc}的形式导入。

将b.js修改为如下内容：
```js
//导入a.js模块
import  * as m1  from'./a.js';

```

看下图：
![效果图](info-06.png)

会发现对象的层级又多了一层。 仔细看会发现，此时m1的类型为Module。也就是说，这种情况是将a模块导入，然后赋值给了m1。
类似下面的代码：
```js
//a
const a: Module = {
    default:{m1:{...}}
};
const abc = a ;
```






