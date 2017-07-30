---
title: 【Extjs】数据包
date: 2017-07-24 08:27:57
tags: [extjs,js]
---

## 数据包（Data Package）

数据包用来加载和保存应用中的数据。它包含了众多的类，但是最重要的这三个：

这些类是：

* Ext.data.Model
* Store
* Ext.data.proxy.Proxy

以上的这些类几乎在每一个应用中都要用到。有需要其他的类来支持这些类。

<!-- more -->

![logo](extjs-data-package/data-model.png)

## 模型（Models）

数据包的核心是Ext.data.Model。模型表示应用程序中的实体。例如，一个电子商务应用可能包含的模型有Users，Products和Orders。在最简单的级别，一个模型定义一组字段和关联的业务逻辑。

我们来看几个模型的主要部分：
* Fields
* Proxies
* Validations
* Associations

## 创建一个模型

通常最好从一个普通的基类开始定义你的模型。这个基础类允许您轻松地在一个地方为所有模型配置一些通用的属性。它也是配置schema的好地方。schema用来管理应用程序中所有模型。现在我们将关注两个最有用的配置选项：


```js
Ext.define('MyApp.model.Base', {
    extend: 'Ext.data.Model',

    fields: [{
        name: 'id',
        type: 'int'
    }],

    schema: {
        namespace: 'MyApp.model',  // generate auto entityName

        proxy: {     // Ext.util.ObjectTemplate
            type: 'ajax',
            url: '{entityName}.json',
            reader: {
                type: 'json',
                rootProperty: '{entityName:lowercase}'
            }
        }
    }
});
```

你的模型基类，特别是“fields”属性，在不同的应用程序之中可能会有所不同。

## 代理

模型和Store使用代理来处理数据的加载和保存。有两种类型的代理，客户端和服务端。

代理可以直接在模型的schema中定义。

### 客户端代理

客户端代理的例子包括内存代理和本地存储代理，它使用了HTML5的本地存储特性。

虽然较旧的浏览器不支持这些新的HTML5 API，但它们非常有用，许多应用程序将从他们的存在中获益匪浅。

### 服务端代理

服务端代理将数据处理并推送到远程服务器。这个类型的代理例子包括Ajax，jsonp和rest。

## Schema

Schema是具有彼此关联的实体的集合。当模型指定scheme时，该scheme将所有派生模型继承。在上面的例子中，scheme配置了两个值，这两个值用来指定该scheme中的默认值。

第一个值为“namespace”，通过指定这个属性，所有的模型都获得了一个短名称-“entityName”。稍后我们定义模型之后的关联时，这个短名称是非常有用的。

scheme中还定义了一个“proxy”配置。这是一个类似Ext.XTemplate的文本模版的对象模版。不同之处在于，对象模版在给定数据的时候会生成对象。在这种情况下，该配置用于定义所有不明确配置proxy的所有模型对象。

这是非常有用的，因为每个模型可能需要使用相同的方式加载数据，只有一点点的不同。这避免了每个模型重复定义proxy。

我们在url中指定了User.json，url:'{entityName}.json'，应该返回一个字符串。

对于这个例子，我们使用了这个：

 ```js
 {
  "success": "true",
  "user": [
    {
      "id": 1,
      "name": "Philip J. Fry"
    },
    {
      "id": 2,
      "name": "Hubert Farnsworth"
    },
    {
      "id": 3,
      "name": "Turanga Leela"
    },
    {
      "id": 4,
      "name": "Amy Wong"
    }
  ]
}
 ```

 ## Stores

 模型通常和Store一起使用，Store基本上是一个records（模型类的实例）的集合。
创建一个Store然后加载数据非常容易：

```js
var store = new Ext.data.Store ({
    model: 'MyApp.model.User'
});

store.load({
    callback:function(){
        var first_name = this.first().get('name');
         console.log(first_name);
    }
});
```
我们手动调用load方法去加载一组MyApp.model.User的纪录，当callback被调用时，所有的记录都将被保存到store中。

### 内联数据

Store也可以加载内联数据，在内部，Store将我们传入的每个对象作为数据转换为相应的Model类型的记录：

```js
new Ext.data.Store({
    model: 'MyApp.model.User',
    data: [{
        id: 1,
        name: "Philip J. Fry"
    },{
        id: 2,
        name: "Hubert Farnsworth"
    },{
        id: 3,
        name: "Turanga Leela"
    },{
        id: 4,
        name: "Amy Wong"
    }]
});

```

### 排序和分组

Store可以在本地或者远程执行排序，过滤和分组操作。

```js
new Ext.data.Store({
    model: 'MyApp.model.User',

    sorters: ['name','id'],
    filters: {
        property: 'name',
        value   : 'Philip J. Fry'
    }
});
```

在这个Store中，数据将通过name排序，然后通过id排序。数据将被过滤掉剩下的只包含name=“Philip J. Fry”的数据。通过Store的API在任何时候都非常容易修改这些属性。

## 关联（Associations）

通过Associations的API，模型可以关联到一起。大多数应用程序处理许多不同的模型，而且模型几乎总是相关的。博客创作应用程序可能包含用户（User）和帖子（Post）的模型。每个用户创建帖子。在这种情况下，每个用户都可以创建多个帖子，但是一个帖子只能被一个用户所创建。这就是我们所知的多对一关联。我们可以这样表达这种关系：
```js
Ext.define('MyApp.model.User', {
    extend: 'MyApp.model.Base',

    fields: [{
        name: 'name',
        type: 'string'
    }]
});

Ext.define('MyApp.model.Post', {
    extend: 'MyApp.model.Base',

    fields: [{
        name: 'userId',
        reference: 'User', // the entityName for MyApp.model.User
        type: 'int'
    }, {
        name: 'title',
        type: 'string'
    }]
});
```

在应用程序中表达不同模型之间的丰富关系很容易。每个模型可以与其他模型有任意数量的关联。此外，您的模型可以按任何顺序定义。一旦你有这个Model类型的记录，就可以轻松地遍历关联的数据。例如，如果您想获取用户的所有帖子，您可以执行以下操作：
```js
// Loads User with ID 1 and related posts and comments
// using User's Proxy
MyApp.model.User.load(1, {
    callback: function(user) {
        console.log('User: ' + user.get('name'));

        user.posts(function(posts){
            posts.each(function(post) {
                console.log('Post: ' + post.get('title'));
            });
        });
    }
});
```

上述关联导致一个新的方法添加到了模型上。每个用户拥有多个帖子，它就会添加我们使用的posts这个方法。调用posts方法会返回一个帖子模型的Store配置。

关联不仅对加载数据有帮助。 它们对于创建新记录也非常有用：

```js
user.posts().add({
    userId: 1,
    title: 'Post 10'
});

user.posts().sync();
```

这将实例化一个新的帖子，该帖子会自动给出userId字段中的用户ID。调用sync（）通过其代理（最终由scheme的代理配置定义）保存新的Post。这是一个异步操作，如果您希望在操作完成时收到通知，您可以传递回调。

关联的“逆”向也会在Post中生成一个新的方法：

```js
MyApp.model.Post.load(1, {
    callback: function(post) {

        post.getUser(function(user) {
            console.log('Got user from post: ' + user.get('name'));
        });                           
    }
});

MyApp.model.Post.load(2, {
    callback: function(post) {
        post.setUser(100);                         
    }
});
```

加载函数getUser（）是异步的，需要一个回调函数来获取用户实例。setUser（）方法将userId（有时称为“外键”）更新为100，并保存Post模型。像往常一样，回调可以被传递，当保存操作完成时将被触发 - 无论是否成功。

## 加载嵌套数据

当定义关联时，加载记录的动作也可以在单个请求中加载关联的记录。例如，考虑像这样的服务器响应：

```js
{
    "success": true,
    "user": [{
        "id": 1,
        "name": "Philip J. Fry",
        "posts": [{
            "title": "Post 1"
        },{
            "title": "Post 2"
        },{
            "title": "Post 3"
        }]
    }]
}
```

该框架可以在单个响应中自动解析嵌套数据，如上述。我们可以在单个服务器响应中返回所有数据，而不是发送一个获取用户数据的请求，另一个用于获取帖子数据。

## 校验

模型还提供了一个验证数据的支持。为了演示，我们将基于上面我们使用的例子。 首先，我们向User模型添加一些验证：
```js
Ext.define('MyApp.model.User', {
    extend: 'Ext.data.Model',
    fields: ...,

    validators: {
        name: [
            'presence',
            { type: 'length', min: 7 },
            { type: 'exclusion', list: ['Bender'] }
        ]
    }
});
```

校验器被定义成了一个以字段名为key，多个校验为值的对象。这些规则被解释为校验器对象配置或者校验器对象配置数组。我们示例中的验证器验证name字段，该字段的长度至少应为7个字符，并且该值将是除“Bender”之外的任何值。

一些验证需要额外的可选配置 - 例如，长度验证可以采用min和mac属性，格式可以采用matcher等。Ext JS内置了五个验证，添加自定义规则很容易。

首先，我们来认知下内置的：

* Presence - 确保该字段必须有值。0是有效值，但是空字符串不是。
* Length - 确保字符串在min和max长度之间。 两个约束是可选的。
* Format - 确保字符串与正则表达式格式匹配。 在上面的例子中，我们确保age字段仅由数字组成。
* Inclusion - 确保一个值在一组特定值内（例如确保性别是男性或女性）。
* Exclusion - 确保值不是特定值值之一（例如将用户名列入“admin”）。


现在我们已经掌握了不同的验证，我们来试试将它们用于一个User实例。 我们将创建一个用户并对其进行验证，并注意任意的失败情况：

```js
// now lets try to create a new user with as many validation
// errors as we can
var newUser = new MyApp.model.User({
    id: 10,
    name: 'Bender'
});

// run some validation on the new user we just created
console.log('Is User valid?', newUser.isValid());

//returns 'false' as there were validation errors

var errors = newUser.getValidation(),
    error  = errors.get('name');

console.log("Error is: " + error);
```

这里的关键功能是getValidation（），它运行所有配置的验证，并返回由每个字段的第一个出现的错误填充的记录或有效字段的布尔值true。 验证记录是懒惰创建的，仅在请求时更新。

在这种情况下，第一个错误显示：“名称字段长度必须大于7”。所以让我们提供一个包含超过7个字符的名字。

```js
newUser.set('name', 'Bender Bending Rodriguez');
errors = newUser.getValidation();
```

此用户记录现在可以满足所有的验证。 该记录存在，它包含超过7个字符，名称不匹配Bender。

newUser.isValid（）将返回true。 当我们调用getValidation（）时，验证记录将被更新，并且将不再脏，并且所有的字段将被设置为true。

原文地址：
http://docs.sencha.com/extjs/6.5.1/guides/core_concepts/data_package.html