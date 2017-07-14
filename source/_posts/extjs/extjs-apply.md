---
title: 【Extjs】apply&applyIf
date: 2017-07-14 22:41:21
tags: [extjs,js]
---

## apply

```js
    Ext.apply({a:1},{a:2});
    //{a:2}
```

```js
    Ext.apply([{b:2}],[{a:2,b:3}]);
    //[{a:2,b:3}]
```


```js
    Ext.apply([{a:1,b:2}],[{a:2,b:3}]);

    //[{a:2,b:3}]
```


```js
    Ext.apply([{a:1,b:2}],[{c:3}]);

    //[{c:3}]
```

```js
    Ext.apply([{a:1,b:2}],[{c:3},{d:4}]);

    //[{c:3},{d:4}]
```


<!-- more -->

## applyIf

```js
    Ext.applyIf({a:1},{a:2});
    //{a:1}
```

```js
    Ext.applyIf([{a:1,b:2}],[{a:2,b:3}]);
    //[{a:1,b:2}]
```

```js
    Ext.applyIf([{b:2}],[{a:2,b:3}]);
    //[{b:2}]
```

```js
    Ext.applyIf([{a:1,b:2}],[{c:3},{d:4}]);
    //[{a:1,b:2},{d:4}]
```






