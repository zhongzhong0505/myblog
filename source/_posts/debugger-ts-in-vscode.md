---
title: 在vscode中调试ts代码
date: 2019-06-12 10:29:07
tags: [ts, vscode, debugger, koa]
---

### 说明
最近在使用ts写koa的应用的时候，需要debugger，试了两种调试方法，记录下。

<!-- more -->

### 方案一

使用编译后的代码调试，这种方法可以在ts中打断点，然后调试的时候会走到ts代码中，但是如果你想跳入一个方法内部，如果没有在这个方法内部打断点的话，vscode会进入到编译后的js代码里面，这可能不是你想要的。
```js
{
    "type": "node",
    "request": "launch",
    "name": "Launch Program",
    "preLaunchTask": "npm: compile",
    "program": "${workspaceFolder}/src/app.ts",
    "sourceMaps": true,
    "smartStep": true,
    "internalConsoleOptions": "openOnSessionStart",
    "outFiles": [
        "${workspaceFolder}/dist/**/*.js"
    ]
},
```

packege.json中的compile命令
```js
"compile": "rimraf dist/ && tsc --pretty && copyfiles -u 1 src/config/*.json src/*.js dist/"
```

这种方法就是先将ts代码编译成js，然后就可以直接调试没有问题了。



### 方案二

使用ts-node直接调试，这种方法直接调试ts代码，暂时没有发现其他问题。

```js
{
    "name": "调试代码",
    "type": "node",
    "request": "launch",
    "args": [
        "${workspaceRoot}/src/app.ts"
    ],
    "runtimeArgs": [
        "--nolazy",
        "-r",
        "ts-node/register"
    ],
    "sourceMaps": true,
    "cwd": "${workspaceRoot}",
    "protocol": "inspector",
    "console": "integratedTerminal",
    "internalConsoleOptions": "neverOpen"
}
```

这种方案需要ts-node的支持，所以你需要先install下ts-node才行。