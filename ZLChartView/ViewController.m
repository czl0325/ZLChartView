//
//  ViewController.m
//  ZLChartView
//
//  Created by zhaoliang chen on 2017/11/8.
//  Copyright © 2017年 zhaoliang chen. All rights reserved.
//

#import "ViewController.h"
#import "ZLShapeChart.h"
#import "Masonry.h"

@interface ViewController ()

@property(nonatomic,strong)ZLShapeChart* zlChart1;
@property(nonatomic,strong)ZLShapeChart* zlChart2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel* label1 = [UILabel new];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:20];
    label1.text = @"线条图";
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(30);
    }];
    
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
    
    UILabel* label2 = [UILabel new];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:20];
    label2.text = @"时间轴图";
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.zlChart1.mas_bottom).offset(30);
    }];
    
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ZLShapeChart*)zlChart1 {
    if (!_zlChart1) {
        _zlChart1 = [[ZLShapeChart alloc] initWithType:zlLine];
        //[_zlShapeChart zl_setBackColor: XMColor(170, 170, 170)];
        _zlChart1.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0f];
        _zlChart1.showDataLabel = YES;
        [_zlChart1 zl_setLineColor:[UIColor colorWithRed:231.0/255 green:55.0/255 blue:40.0/255 alpha:1.0]];
        [_zlChart1 zl_setTextColor:[UIColor colorWithRed:231.0/255 green:55.0/255 blue:40.0/255 alpha:1.0]];
    }
    return _zlChart1;
}

- (ZLShapeChart*)zlChart2 {
    if (!_zlChart2) {
        _zlChart2 = [[ZLShapeChart alloc] initWithType:zlShape];
        [_zlChart2 zl_setLineColor:[UIColor colorWithRed:212.0/255 green:237.0/255 blue:242.0/255 alpha:1.0]];//线条颜色
    }
    return _zlChart2;
}

@end
