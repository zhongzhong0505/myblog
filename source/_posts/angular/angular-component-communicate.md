---
title: 【翻译】Angular组件交互的3种方式
date: 2017-08-29 13:26:16
tags: [angular,ts]
---

原文地址：https://medium.com/@mirokoczka/3-ways-to-communicate-between-angular-components-a1e3f3304ecb

![输入图片说明](info-01.png )

本文是为Angular 2+编写的。在撰写本文时，最新版本是Angular 4。

这篇文章为初学者编写的，如果您是高级的或中级的Angular开发人员，您可能已经了解所有这些技术。

组件之间如何通信？这是我看到许多初级的Angular开发者争论的话题。我将向您展示3种最常见的方法，其中包含适合不同用例的示例。redux的方式，我会在以后另外写一篇文章。

<!-- more -->

![输入图片说明](info-02.png )

想象一下你的应用程序中有侧边栏的用例。侧边栏打开或关闭。你会拥有一个侧边栏组件，然后具有打开／关闭的功能以及询问组件状态的方法。

我将介绍三种实现这一行为的方法：

- 将一个组件的引用传递给另一个组件
- 通过父组件进行通信
- 通过服务通信

**这篇文章中的所有实例在StackBlitz和github仓库都有对应的源代码。**

## 将一个组件的引用传递给另一个组件

当组件之间有依赖关系时，应使用此解决方案。例如下拉菜单，下拉菜单切换（按钮）。它们通常不能独立存在。

[Demo](https://stackblitz.com/edit/angular-communication-1)

[Github](https://github.com/mkoczka/angular-components-communication/tree/approach-1)

我们将创建一个side-bar-toggle组件，它将side-bar作为输入属性，通过点击切换按钮，打开或关闭side-bar。

以下是相关的代码：

app.component.html

```js

<app-side-bar-toggle [sideBar]="sideBar"></app-side-bar-toggle>
<app-side-bar #sideBar></app-side-bar>

```

side-bar-toggle.component.ts

```js
@Component({
  selector: './app-side-bar-toggle',
  templateUrl: './side-bar-toggle.component.html',
  styleUrls: ['./side-bar-toggle.component.css']
})
export class SideBarToggleComponent {

  @Input() sideBar: SideBarComponent;

  @HostListener('click')
  click() {
    this.sideBar.toggle();
  }

}
```

side-bar.component.ts

```js
@Component({
  selector: './app-side-bar',
  templateUrl: './side-bar.component.html',
  styleUrls: ['./side-bar.component.css']
})
export class SideBarComponent {

  @HostBinding('class.is-open')
  isOpen = false;

  toggle() {
    this.isOpen = !this.isOpen;
  }

}
```

## 通过父组件进行通信

可以通过父组件来控制组件之间的共享状态，以为你不想因为一个变量创建新的服务或者编写样板代码。


[Demo](https://stackblitz.com/edit/angular-communication-2)
[Github](https://github.com/mkoczka/angular-components-communication/tree/approach-2)

这种方法的实现与前一种方法几乎相同，但是side-bar-toggle组件不接收side-bar作为输入。而父组件则保留传递给side-bar组件的sideBarIsOpened属性。

app.component.html

```js
<app-side-bar-toggle (toggle)="toggleSideBar()"></app-side-bar-toggle>
<app-side-bar [isOpen]="sideBarIsOpened"></app-side-bar>
```

app.component.ts
```js
@Component({
  selector: 'my-app',
  templateUrl: './app.component.html',
  styleUrls: [ './app.component.css' ]
})
export class AppComponent {
  sideBarIsOpened = false;

  toggleSideBar(shouldOpen: boolean) {
    this.sideBarIsOpened = !this.sideBarIsOpened;
  }
}
```

side-bar-toggle.component.ts
```js
@Component({
  selector: './app-side-bar-toggle',
  templateUrl: './side-bar-toggle.component.html',
  styleUrls: ['./side-bar-toggle.component.css']
})
export class SideBarToggleComponent {

  @Output() toggle: EventEmitter<null> = new EventEmitter();

  @HostListener('click')
  click() {
    this.toggle.emit();
  }

}
```

side-bar.component.ts
```js
@Component({
  selector: './app-side-bar',
  templateUrl: './side-bar.component.html',
  styleUrls: ['./side-bar.component.css']
})
export class SideBarComponent {

  @HostBinding('class.is-open') @Input()
  isOpen = false;

}
```

## 通过服务通信

最后这种方式在你需要处理受控组件或者从多个组件中提取状态的时候是非常有效的一种方式。

[Demo](https://stackblitz.com/edit/angular-communication-3)
[Github](https://github.com/mkoczka/angular-components-communication/tree/approach-3)

![输入图片说明](info-03.png)

现在我们在应用程序中有多个地方需要访问我们的side-bar组件。我们来看看我们怎么做。

我们现在将创建side-bar.service.ts，我们有：

- side-bar.service.ts
- side-bar.component.ts
- side-bar.component.html

side-bar服务将具有toggle方法和change事件，因此，当side-bar组件的状态更改的时候，可以通知每一个注入了此服务的组件。

在这个例子中，side-bar-toggle组件和side-bar组件都没有输入属性，因为它们通过服务进行通信。

现在的代码：

app.component.html
```js
<app-side-bar-toggle></app-side-bar-toggle>
<app-side-bar></app-side-bar>
```

app.component.ts
```js
@Component({
  selector: './app-side-bar-toggle',
  templateUrl: './side-bar-toggle.component.html',
  styleUrls: ['./side-bar-toggle.component.css']
})
export class SideBarToggleComponent {

  constructor(
    private sideBarService: SideBarService
  ) { }

  @HostListener('click')
  click() {
    this.sideBarService.toggle();
  }
}
```

side-bar.component.ts
```js
@Component({
  selector: './app-side-bar',
  templateUrl: './side-bar.component.html',
  styleUrls: ['./side-bar.component.css']
})
export class SideBarComponent {

  @HostBinding('class.is-open')
  isOpen = false;

  constructor(
    private sideBarService: SideBarService
  ) { }

  ngOnInit() {
    this.sideBarService.change.subscribe(isOpen => {
      this.isOpen = isOpen;
    });
  }
}
```

side-bar.service.ts
```js
@Injectable()
export class SideBarService {

  isOpen = false;

  @Output() change: EventEmitter<boolean> = new EventEmitter();

  toggle() {
    this.isOpen = !this.isOpen;
    this.change.emit(this.isOpen);
  }

}
```


