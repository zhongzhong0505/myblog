---
title: 【Extjs】ui的用法
tags: [extjs,js]
date: 2017-07-13
---
button：
```scss
@include extjs-button-small-ui{
$ui:'btn-link';
$background-color: transparent;
$border: none;
$background-color-over:transparent;
$background-color-focus :transparent;
$background-color-pressed:transparent;
$background-color-focus-pressed:transparent;
}
.x-btn-button-btn-link-small{
line-height: 1;
.x-btn-inner-btn-link-small{
color: #a8a8a8
}
```
}
<!-- more -->

用法：
```js
{
     text:'按钮',
     ui:'btn-link'
}
```