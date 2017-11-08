# ZLChartView
我写的一个线性图和时间轴图

开源了一个我写的关于线性图和时间轴图的控件，这是我的项目需求，如果有另外的需求可以在我的源代码里面修改。
该控件支持autolayout布局，需要导入masonry的库。

注意：时间轴视图的数据是从1开始

![](https://github.com/czl0325/ZLChartView/blob/master/ZLChart.gif?raw=true)

```Objective-C

    [self.view addSubview:self.zlChart1];
    [self.zlChart1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(label1.mas_bottom).offset(50);
        make.height.mas_equalTo(200);
    }];
    
    NSMutableArray* xArray1 = [NSMutableArray new];
    NSMutableArray* data1 = [NSMutableArray new];
    for (int i=0; i<20; i++) {
        [xArray1 addObject:[NSString stringWithFormat:@"10-%zd",i+1]];
        [data1 addObject:[NSString stringWithFormat:@"%zd",arc4random()%4800+100]];
    }
    [self.zlChart1 zl_reloadXArray:xArray1 yArray:@[@"5000",@"4000",@"3000",@"2000",@"1000"] dataArray:data1];
    /************** y轴注意是倒序排列，数值大的写在前面  **********************/
    
    [self.view addSubview:self.zlChart2];
    [self.zlChart2 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(label2.mas_bottom).offset(50);
        make.height.mas_equalTo(200);
    }];
    
    NSArray* xArray2 = @[@"8:00",@"12:00",@"12:20",@"13:30",@"18:00",@"19:00",@"6:00"];
    NSArray* data2 = @[@"1",@"2",@"3",@"1",@"2",@"3"];
    [self.zlChart2 zl_reloadXArray:xArray2 yArray:@[@"上班",@"吃饭",@"睡觉"] dataArray:data2];
    /************** data2数值下标是从1开始，例如上班是1，吃饭是2，睡觉是3， data2的总数应该是xArray2的总数-1，  **********************/
```
