# �÷�

    myfit
    myfit(options)

## ˵��

- `options`
  - ���� 'Q=*', 'on=*', 'off=*' �е�һ���򼸸�����ϡ�

- ��������ļ��ṹ�����ݣ��������� `fitresult.txt` �� `fitfigure` �С�

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

## ����

- myfit
  > ʹ�ò�����Ĭ��ֵ ('Q=*', 'on=*', 'off=*')

- myfit('Q=900')
  > ֻ���� Q=900 �������ļ�

- myfit('on=1.2', 'off=1.2')
  > ֻ���� on=0.5 off=1.2 �������ļ�
