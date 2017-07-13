---
title: 【Extjs】数据绑定
---
```js
var vm = new Ext.app.ViewModel();

vm.bind('{x}',function(x){
    console.log(x);
});

vm.set('x','hello');
//hello


vm.bind('Hello {x:capitalize}',function(v){
    console.log(v);
});

vm.set('x','world');
//Hello World


vm.bind({x:'x={x},y:['{y}']'},function(v){
    console.log(v);
});

vm.set('x',1);

//wait for y….
vm.set('y',2);

//{x:'x=1',y:[2]}

vm.bind('{foo}',this.onFoo,this,{
    deep:true,
    single:true,
    twoWay:false
})

```

<!-- more -->

//combobox绑定

绑定到combobox的displayField
combo.selection.属性名称
属性名称为配置的displayField的值

条件绑定

hidden:'{combo.selection.fieldName === "ddd"}'

当选择项的值为ddd的时候，隐藏


//textfield，默认不会将值添加到vm中，需要配置publishes
属性，
在items中使用的时候，publishes的值可以是一个字符串，也可以是字符串数组
但是在define定义的类中的时候，必须是一个对象
例如：
```js
{
     xtype:'form',
     items:[{
          xtype:'textfield'
          publishes:'value'
     }]
}
```

这样之后还必须配置reference，reference的值对应的就是vm中的data的key，key对应的值是一个对象，这个对象包括publishes中发布的属性。

```js
Ext.define('MyTextField',{
    extend:'Ext.form.field.TextField',
    publishes:{
        value:true
    }
})
```

//配置简单的表达式

例如：3个数字输入框，a,b,c
要配置绑定：c=a+b
则：
a的配置
```js
{
     reference:'a',
     bind:{
          value:'{a}'
     }
}
```
b的配置
```js
{
     reference:'b',
     bind:{
          value:'{b}'
     }
}
```
c的配置
```js
{
     reference:'c',
     bind:{
          value:'{a+b}'
     }
}
```

这种方法是其实是利用了bind，将a和b发布到了vm中

{% githubCard user:zhongzhong0505 %}







