---
title: 【翻译】angular4路由模块的变化
date: 2017-08-24 17:55:58
tags: [angular,ts,js]
---

原文地址：https://yakovfain.com/2017/03/26/angular-4-changes-in-the-router/

Angular4在路由中有一些有用的更改。我们来看一下在路由的CanDeactivete中接收参数的变化。（看<a href="https://yakovfain.com/2016/07/20/angular-2-guarding-routes/" terget="_blank">这里</a>）



路由可以使用ActivatedRoute的快照属性或通过订阅其属性参数来接收参数。现在有一个属性paramMap，可以通过使用get（）方法获取一个特定的参数，或者通过调用getAll（）获取所有的参数。

<!-- more -->

以下是接收上一个路由中没有更改的参数ID的方法：
```js
export class ProductDetailComponentParam {
  productID: string;
 
  constructor(route: ActivatedRoute) {
    this.productID = route.snapshot.paramMap.get('id');
  }
}
```


如果路由在上一个路由中已经更改了，（看<a href="https://yakovfain.com/2016/11/20/angular-2-implementing-master-detail-using-router/" target="_blank">这里</a>）你可以像下面这样订阅id的流：
```js
export class ProductDetailComponentParam {
  productID: string;
 
  constructor(route: ActivatedRoute) {
 
    route.paramMap.subscribe(
     params => this.productID = params.get('id')
     );
  }
}
```

CanDeactivate守卫现在允许您更具体，有条件地禁止从路由导航，具体取决于用户计划导航的位置。接口CanDeactivate现在有一个可选参数nextState，您可以检查以决定是否要禁止导航。下一个代码片段只显示用户尝试导航到由路径“/”表示的归属路由时，显示警告弹出窗口。导航到任何其他路线仍然没有保护。

```js
@Injectable()
export class UnsavedChangesGuard implements CanDeactivate<ProductDetailComponent>{
 
    constructor(private _router:Router){}
 
    canDeactivate(component: ProductDetailComponent, 
                  currentRoute: ActivatedRouteSnapshot,
                  currentState: RouterStateSnapshot, 
                  nextState?: RouterStateSnapshot){
 
        let canLeave: boolean = true;
 
        // If the user wants to go to home component
        if (nextState.url === '/') {
          canLeave = window.confirm("You have unsaved changes. Still want to go home?");
        }
        return canLeave;
 
    }
}
```

Angular4刚刚发布，里面还有很多其它方面的改变，但是我只想和你分享这些。

