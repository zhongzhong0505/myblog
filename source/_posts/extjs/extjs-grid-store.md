---
title: 【Extjs】grid的store配置autoLoad=false无效的问题
date: 2017-07-18 22:51:27
tags: [extjs,js]
---

今天在使用Ext的grid的组件的时候，发现在grid的store中配置了autoLoad为false的时候，grid在渲染完成之后store还是自动加载了数据。找了许久，才发现原来是Ext的一个bug，所以在此记录一下，并把找到的问题的解决方法记录下来。

<!-- more -->

## 自定义组件

```js
Ext.define('Site.view.conaict.CustomerList', {
    extend: 'Ext.grid.Panel',
    xtype: 'customerList',
    plugins: 'gridfilters',
    flex: 5,
    store: {
        autoLoad: false,
        remoteFilter: true,
        remoteSort: true,
        fields: ['dealerCode', 'dealerName','dealerSubclass','contactPerson'],
        pageSize: 50,
        proxy: r2.global.SiteDao.proxyGetCustomerList(),
    },
    bbar: {
        xtype: 'pagingtoolbar',
        displayInfo: true
    },
    columns: [{
        xtype: 'rownumberer',
        width:50
    }, {
        text: '客户编码',
        dataIndex: 'dealerCode',
        flex: 1,
        filter: 'string'
    }, {
        text: '客户名称',
        dataIndex: 'dealerName',
        flex:1,
        filter:'string'
    }, {
        text: '分类',
        dataIndex: 'dealerSubclass',
        flex: 1
    }, {
        text:'联系人',
        dataIndex:'contactPerson',
        flex:1
    }]
});
```

定义好自己的组件之后，页面打开之后，发现数据已经加载出来了。当时就蒙蔽了，这是什么问题啊，明明autoLoad已经设置为false了呀？

## 解决方法

在网上搜索了之后，最后发现是如果在store中设置了remoteFilter=true，则store在初始化之后，就会加载数据。解决方法是通过重写Ext的ProxyStore类来修复这个问题。
下面是重写了之后的代码：
```js
Ext.define('Ext.overrides.ProxyStore', {
    override: 'Ext.data.ProxyStore',

    onSorterEndUpdate: function() {
        var me = this,
            sorters;


        // If we're in the middle of grouping, it will take care of loading
        sorters = me.getSorters(false);
        if (me.settingGroups || !sorters) {
            return;
        }


        sorters = sorters.getRange();


        // Only load or sort if there are sorters
        if (sorters.length) {
            //FIX: make sure autoLoad setting is respected
            if (me.getRemoteSort() && (me.getAutoLoad() || me.isLoaded())) {
                me.load({
                    callback: function() {
                        me.fireEvent('sort', me, sorters);
                    }
                });
            } else if (!me.getRemoteSort()) {
                me.fireEvent('datachanged', me);
                me.fireEvent('refresh', me);
                me.fireEvent('sort', me, sorters);
            }
        } else {
            // Sort event must fire when sorters collection is updated to empty.
            me.fireEvent('sort', me, sorters);
        }
    },


    onFilterEndUpdate: function() {
        var me = this,
            suppressNext = me.suppressNextFilter;


        if (me.getRemoteFilter()) {
            //<debug>
            me.getFilters().each(function(filter) {
                if (filter.getInitialConfig().filterFn) {
                    Ext.raise('Unable to use a filtering function in conjunction with remote filtering.');
                }
            });
            //</debug>
            me.currentPage = 1;
            //FIX: make sure autoLoad setting is respected
            if (!suppressNext && (me.getAutoLoad() || me.isLoaded())) {
                me.load();
            }
        } else if (!suppressNext) {
            me.fireEvent('datachanged', me);
            me.fireEvent('refresh', me);
        }


        if (me.trackStateChanges) {
            // We just mutated the filter collection so let's save stateful filters from this point forward.
            me.saveStatefulFilters = true;
        }


        // This is not affected by suppressEvent.
        me.fireEvent('filterchange', me, me.getFilters().getRange());
    }
});  
```

主要修改以下两句代码：
```js
if (!suppressNext && (me.getAutoLoad() || me.isLoaded())) {
    me.load();
}
```

```js
if (me.getRemoteSort() && (me.getAutoLoad() || me.isLoaded())) {
    me.load({
        callback: function() {
            me.fireEvent('sort', me, sorters);
        }
    });
...
```
都加上了autoLoad的判断，这样之后，就解决了这个问题。

## 加载数据的时机？

虽然实现了功能，但是现在必须点击grid的分页工具栏的刷新按钮才能加载数据，这样体验的话就不好了，那怎么解决这个问题呢？

那就是给grid添加事件监听，当grid渲染完成之后，加载数据。
```js
listeners:{
    afterrender : function(){
        this.store.reload();
    }
},
```

## 注意

重写的代码文件需要放在项目目录下的overrides文件夹中，默认没有生成这个文件夹，需要自己创建。重写的类名可以自己定义，但是override属性必须时需要重写的目标类名。