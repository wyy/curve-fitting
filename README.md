# 用法

    myfit
    myfit(options)

## 说明

- `options`
  - 参数 'Q=*', 'on=*', 'off=*' 中的一个或几个的组合。

拟合如下文件结构的数据，结果存放在 `fitfigure`, `fitdata` 和 `fitresult.txt` 中。

```
|- off=0.1
  |- Q=100
    |- on=0.1 off=0.1.xls
    |- on=0.2 off=0.1.xls
    |- on=0.3 off=0.1.xls
    ...
    |- on=0.12 off=0.1.xls
  |- Q=200
  |- Q=300
  ...
  |- Q=900
|- off=0.2
|- off=0.3
...
|- off=0.12
```

## 例子

- myfit
  > 使用参数的默认值 ('Q=*', 'on=*', 'off=*')，通配符 * 表示任意字符。

- myfit('Q=900')
  > 只分析 Q=900 的数据文件。

- myfit('on=1.2', 'off=1.2')
  > 只分析 on=1.2 off=1.2 的数据文件。

- myfit('filter', '2')
  > 过滤掉前 2 个低频振动，'filter' 参数后可以紧跟着指定频率个数，默认值为 '3'。
  > 'filter' 参数可以和 'Q=*', 'on=*', 'off=*' 参数混合使用。
