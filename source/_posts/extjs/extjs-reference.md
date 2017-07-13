---
title: 【Extjs】reference的作用
tags: [extjs,js]
---
## reference：

指定组件名称，这个名称在它所属的viewController中要是唯一的，否者会有警告，并且通过lookup获取的时候，只能获取到最后一个的值。
在view中如果指定了viewcontroller，才能使用lookup查找组件，如果没有指定viewcontroller，则需要在view中指定referenceHolder为true，这样
在组件中才能通过lookup查找组件。

<!-- more -->

## reference和数据绑定

组件如果配置了vm，则reference的值，对应的就是vm中data对象的key。
在配置了reference之后，如果在其他的item中需要引用改组件的属性作为bind表达式的一部分，
则需要在该item中配置publishes属性，定义发布到vm中的属性，否者绑定不能生效，
publishes属性在作为items中的item的配置的时候，可以是字符串或者数组，但是在作为Ext.define中定义类的属性的时候必须是一个对象，例如
```js
	publishes:{
		value:true,
     	fieldLabel:true
	}
```
{% githubCard user:zhongzhong0505 %}

关于我: [Github](https://github.com/zhongzhong0505)

