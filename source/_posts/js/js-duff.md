---
title: javascript循环-Duff策略
date: 2017-08-20 22:27:27
tags: [js]
---

## Duff策略
Duff策略的核心思想是每一次循环完成标准循环的1～8次。首先通过数组长度对8取模，得到需要循环的次数，然后通过数组长度对8取余，得到需要额外处理的数据项的数量。

```js
//生成测试数据
var values = [];
for(var i=0;i<1000;i++>){
    values.push(i);
}

//计算循环次数
var count = Math.ceil(values.length / 8);
var start = values.length % 8;
var j = 0;

//开始循环
do{
    switch(start){
        case 0: console.log(values[j++]);
        case 7: console.log(values[j++]);
        case 6: console.log(values[j++]);
        case 5: console.log(values[j++]);
        case 4: console.log(values[j++]);
        case 3: console.log(values[j++]);
        case 2: console.log(values[j++]);
        case 1: console.log(values[j++]);
    }
    start = 0 ;//重置为0，这样第二次循环的时候，正好可以每次处理8项数据
}while(--count > 0);
```

<!-- more -->

## Duff策略改进版

```js
//生成测试数据
var values = [];
for(var i=0;i<1000;i++>){
    values.push(i);
}

//计算循环次数
var count = Math.ceil(values.length / 8);
var start = values.length % 8;
var j = 0;

//开始处理额外的数据项，就是不够组成8项一组的数据
if(start > 0){
    do{
        console.log(j++);
    }while(--start > 0)
}

// 循环8项一组的数据
do{
    console.log(j++);
    console.log(j++);
    console.log(j++);
    console.log(j++);

    console.log(j++);
    console.log(j++);
    console.log(j++);
    console.log(j++);    
}while(--count > 0);
```

这个版本相对于上面一个版本来说，去掉了switch语句，减少了条件判断的开销，所以性能比上面的版本要好。
