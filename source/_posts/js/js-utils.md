---
title: 必备js工具方法
date: 2017-12-15 21:23:34
tags: [js]
---

1. 所有的可能组合方式
<!-- more -->
```js
const anagrams = str => {
  if(str.length <= 2)  return str.length === 2 ? [str, str[1] + str[0]] : [str];
  return str.split('').reduce( (acc, letter, i) => {
    anagrams(str.slice(0, i) + str.slice(i + 1)).map( val => acc.push(letter + val) );
    return acc;
  }, []);
}
// anagrams('abc') -> ['abc','acb','bac','bca','cab','cba']
```
2. 数字数组的平均值
```js
const average = arr =>
  arr.reduce( (acc , val) => acc + val, 0) / arr.length;
// average([1,2,3]) -> 2
```
3. 每一个单词首字母转换为大写
```js
const capitalizeEveryWord = str => str.replace(/\b[a-z]/g, char => char.toUpperCase());
// capitalizeEveryWord('hello world!') -> 'Hello World!'
```
4. 首字母大写
```js
const capitalize = (str, lowerRest = false) =>
  str.slice(0, 1).toUpperCase() + (lowerRest? str.slice(1).toLowerCase() : str.slice(1));
// capitalize('myName', true) -> 'Myname'
//capitalize('myName') -> 'MyName
```
5. 检查回文
```
const palindrome = str =>
  str.toLowerCase().replace(/[\W_]/g,'').split('').reverse().join('') === str.toLowerCase().replace(/[\W_]/g,'');
// palindrome('taco cat') -> true
```

6. 计算数组中指定值的出现次数
```js
const countOccurrences = (arr, value) => arr.reduce((a, v) => v === value ? a + 1 : a + 0, 0);
// countOccurrences([1,1,2,1,2,3], 1) -> 3
```
7. 获取当前网址
```js
const currentUrl = _ => window.location.href
```
8. 函数柯里化
```js
const curry = f =>
  (...args) =>
    args.length >= f.length ? f(...args) : (...otherArgs) => curry(f)(...args, ...otherArgs);
// curry(Math.pow)(2)(10) -> 1024
```
9. 嵌套数组合并
```js
const deepFlatten = arr =>
  arr.reduce( (a, v) => a.concat( Array.isArray(v) ? deepFlatten(v) : v ), []);
  // deepFlatten([1,[2],[[3],4],5]) -> [1,2,3,4,5]
```
10. 去掉2个数组的共有元素
```js
const difference = (arr, values) => arr.filter(v => !values.includes(v));
// difference([1,2,3], [1,2]) -> [3]
```
11. 计算2点直接的距离
```js
const distance = (x0, y0, x1, y1) => Math.hypot(x1 - x0, y1 - y0);
// distance(1,1, 2,3) -> 2.23606797749979
```
12. 转义正则表达式
```js
const escapeRegExp = str => str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
// escapeRegExp('(test)') -> \\(test\\)
```
13. 斐波拉契数列
```js
const fibonacci = n => 
  Array(n).fill(0).reduce((acc, val, i) => acc.concat(i > 1 ? acc[i - 1] + acc[i - 2] : i),[]);
// fibonacci(5) -> [0,1,1,2,3]
```
14. 数组去重
```js
const unique = arr => arr.filter(i => arr.indexOf(i) === arr.lastIndexOf(i));
// unique([1,2,2,3,4,4,5]) -> [1,3,5]
```
15. 数组合并
```js
const flatten = arr => arr.reduce( (a, v) => a.concat(v), []);
// flatten([1,[2],3,4]) -> [1,2,3,4]
```
16. 获取数组中最大值
```js
const arrayMax = arr => Math.max(...arr);
// arrayMax([10, 1, 5]) -> 10
```
17. 获取数组中最小值
```js
const arrayMin = arr => Math.min(...arr);
// arrayMin([10, 1, 5]) -> 1
```
18. 获取滚动条位置
```js
const getScrollPos = (el = window) =>
  ( {x: (el.pageXOffset !== undefined) ? el.pageXOffset : el.scrollLeft,
   y: (el.pageYOffset !== undefined) ? el.pageYOffset : el.scrollTop} );
// getScrollPos() -> {x: 0, y: 200}
```
19. 最大公约数
```js
const gcd = (x , y) => !y ? x : gcd(y, x % y);
// gcd (8, 36) -> 4
```
20. 使用一组连续范围数字初始化一个组数
```js
const initializeArrayRange = (end, start = 0) =>
  Array.apply(null, Array(end-start)).map( (v,i) => i + start );
  // initializeArrayRange(5) -> [0,1,2,3,4]
```
21. 测试函数执行时间
```js
const timeTaken = (func,...args) => {
  var t0 = performance.now(), r = func(...args);
  console.log(performance.now() - t0);
  return r;
}
// timeTaken(Math.pow, 2, 10) -> 1024 (0.010000000009313226 logged in console)
```
22. 将键值对数组转成对象
```js
const objectFromPairs = arr => arr.reduce((a,v) => (a[v[0]] = v[1], a), {});
// objectFromPairs([['a',1],['b',2]]) -> {a: 1, b: 2}
```
23. 管道,返回一组函数处理后的结果
```
const pipe = (...funcs) => arg => funcs.reduce((acc, func) => func(acc), arg);
// pipe(btoa, x => x.toUpperCase())("Test") -> "VGVZDA=="
```
24. 生成指定范围的随机整数
```js
const randomIntegerInRange = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
// randomIntegerInRange(0, 5) -> 2
```
25. 将数组乱序
```js
const randomizeOrder = arr => arr.sort( (a,b) => Math.random() >= 0.5 ? -1 : 1);
// randomizeOrder([1,2,3]) -> [1,3,2]
```
26. RGB转16进制值
```js
const rgbToHex = (r, g, b) => ((r << 16) + (g << 8) + b).toString(16).padStart(6, '0');
// rgbToHex(255, 165, 1) -> 'ffa501'
```
27. 回到顶部
```js
const scrollToTop = _ => {
  const c = document.documentElement.scrollTop || document.body.scrollTop;
  if(c > 0) {
    window.requestAnimationFrame(scrollToTop);
    window.scrollTo(0, c - c/8);
  }
}
// scrollToTop()
```
28. 获取2个数组的交集
```js
const similarity = (arr, values) => arr.filter(v => values.includes(v));
// similarity([1,2,3], [1,2,4]) -> [1,2]
```
29. 字符排序
```js
const sortCharactersInString = str =>
  str.split('').sort( (a,b) => a.localeCompare(b) ).join('');
// sortCharactersInString('cabbage') -> 'aabbceg'
```
30. 获取url中的参数
```js
const getUrlParameters = url =>
  Object.assign(...url.match(/([^?=&]+)(=([^&]*))?/g).map(m => {[f,v] = m.split('='); return {[f]:v}}));
  // getUrlParameters('http://url.com/page?name=Adam&surname=Smith') -> {name: 'Adam', surname: 'Smith'}
```
31. UUID生成
```js
const uuid = _ =>
  ( [1e7]+-1e3+-4e3+-8e3+-1e11 ).replace( /[018]/g, c =>
    (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
  );
// uuid() -> '7982fcfe-5721-4632-bede-6000885be57d'
```

原文地址： https://github.com/Chalarangelo/30-seconds-of-code