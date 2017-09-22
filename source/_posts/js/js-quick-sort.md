---
title: js实现快速排序以及应用
date: 2017-09-21 00:24:53
tags: [js,算法]
---

## js实现快速排序

### 快速排序的思想
快速排序是基于分治的一种排序算法。排序规则是将数组分为独立的两部分，并对每一部分单独排序。就是说，先获取一个元素作为基准值，然后通过两个游标，
一个从数组前端往后扫描，如果扫描到比基准值大的元素，停止扫描，一个从后端往前端扫描，如果扫描到比基准值小的元素，停止扫描。
然后交换两个元素的位置。当两个游标相遇的时候，可以证明此时基准值前端的元素比它小，基准值后面的元素比它大。然后分别对基准值右侧和左侧的元素排序。这样整个数组就排序完成了。
在看了《算法》这本书上的介绍之后，记录下过程：
    
<!-- more -->

### 排序过程
```js
            /*需要排序的数据data，选择第一个元素data[0]作为基准元素*/
            5   9   1   7   10  15  3   20

            i                               j       /*初始位置*/
                i                        j      /*第一次移动，此时data[i]>data[0],i停止移动，j移动，此时data[j]>data[0],j继续移动*/
                i                   j           /*第二次移动，此时data[j]<data[0],j停止移动，并且交换data[i]和data[j]的值*/
            5   3   1   7   10  15  9   20      /*交换之后的数据*/
                    i               j           /*第三次移动，i移动，此时data[i]<data[0],i继续移动*/
                        i           j           /*第四次移动，i移动，此时data[i]>data[0],i停止移动，j移动*/
                        i       j               /*第五次移动，j移动，此时data[j]>data[0],j继续移动*/
                        i   j                   /*第六次移动，j移动，此时data[j]>data[0],j继续移动*/
                        i,j                     /*第七次移动，j移动，此时i，j处于同一个位置，此时data[j]>data[0]，j继续移动*/
                    j   i                       /*第八次移动，j移动，此时data[j]<data[0],j停止移动，此时i>=j,本次循环结束，并且交换data[0]和data[j]的值*/
            1   3   5   7   10  15  9   20      /*然后对data[0]~data[j-1],data[j+1]~data[data.length]分别进行上面的操作*/
```


### js实现
```js
    const quickSort = (data,start,end)=>{
        if(start >= end) return;
        const p = partition(data,start,end);
        quickSort(data,start,p-1);//对基准值左侧排序
        quickSort(data,p+1,end);//对基准值右侧排序
    }
    const partition = (data,start,end)=>{
        const v = data[start];
        let i=start,j=end+1;
        while(true){//开始循环
            while(data[++i] < v){//一直移动i，知道找到一个元素，该元素大于v
                if(i == end) break;//如果到最后还是没有找到符合条件的值，退出循环
            }
            while(data[--j] > v);//一直移动j，知道找到一个元素，该元素小于v，这里不需要边界值的判断，因为data[start]就是一个哨兵
            if(i>=j) break;//如果i和j相交，说明此次循环结束
            swap(data,i,j);//交换data[i]和data[j]的值
        }
        swap(data,start,j);//交换data[start]和data[j]的值
        return j;
    }
    const swap = (data,i,j)=>{
        let temp = data[i];
        data[i] = data[j];
        data[j] = temp;
    }
```

到此，快速排序算法的js实现，就算完成了。

## 快速排序的应用
### 获取数组中,第k大的数
这里需要将之前实现的升序排序改成降序,只需要修改partition函数中对应的两个while条件就行了.
实现代码如下:
```js
  const quickSort = (data, start, end, n) => {
    if (data.length === 1) return data[0];
    const p = partition(data, start, end);
    if (n === p + 1) {
      return data[p];
    } else if (n > p + 1) {
      data.splice(start, p + 1);
      n -= (p + 1) - start;
      return quickSort(data, 0, data.length - 1, n); //对基准值右侧排序
    } else {
      data.splice(p, end);
      return quickSort(data, 0, data.length - 1, n); //对基准值左侧排序
    }
  }
  const partition = (data, start, end) => {
    const v = data[start];
    let i = start,
      j = end + 1;
    while (true) { //开始循环
      while (data[++i] > v) { //一直移动i，知道找到一个元素，该元素小于v
        if (i == end) break; //如果到最后还是没有找到符合条件的值，退出循环
      }
      while (data[--j] < v); //一直移动j，知道找到一个元素，该元素大于v，这里不需要边界值的判断，因为data[start]就是一个哨兵
      if (i >= j) break; //如果i和j相交，说明此次循环结束
      swap(data, i, j); //交换data[i]和data[j]的值
    }
    swap(data, start, j); //交换data[start]和data[j]的值
    return j;
  }
  const swap = (data, i, j) => {
    let temp = data[i];
    data[i] = data[j];
    data[j] = temp;
  }
```
