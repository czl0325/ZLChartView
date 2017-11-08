//
//  ZLShapeChart.m
//  Seven
//
//  Created by zhaoliang chen on 2016/11/18.
//  Copyright © 2016年 zhaoliang chen. All rights reserved.
//

#import "ZLShapeChart.h"
#import "ZLChartContentView.h"
#import "ZLLineContentView.h"
#import "Masonry.h"

@interface ZLShapeChart()
<ZLLineContentViewDelegate>

@property (nonatomic,assign) ZLChartType type;
@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) ZLLineContentView* contentView1;
@property (nonatomic,strong) ZLChartContentView* contentView2;

@end

@implementation ZLShapeChart

- (instancetype)initWithType:(ZLChartType)type {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        _type = type;
        _showDataLabel = NO;
        
        switch (_type) {
            case zlLine: {
                _contentView1 = [[ZLLineContentView alloc]initWithFrame:CGRectZero];
                _contentView1.delegate = self;
                [self.scrollView addSubview:_contentView1];
                [_contentView1 setMas_key:@"_contentView1"];
                [_contentView1 mas_makeConstraints:^(MASConstraintMaker* make) {
                    make.edges.mas_equalTo(self.scrollView);
                }];
                
                __weak typeof(ZLShapeChart*) weakSelf = self;
                _contentView1.onReloadHeight = ^(CGFloat height) {
                    [weakSelf mas_updateConstraints:^(MASConstraintMaker* make) {
                        make.height.mas_equalTo(height);
                    }];
                };
            }
                break;
            case zlShape: {
                _contentView2 = [[ZLChartContentView alloc]initWithFrame:CGRectZero];
                [self.scrollView addSubview:_contentView2];
                [_contentView2 setMas_key:@"_contentView2"];
                [_contentView2 mas_makeConstraints:^(MASConstraintMaker* make) {
                    make.edges.mas_equalTo(self.scrollView);
                }];
                
                __weak typeof(ZLShapeChart*) weakSelf = self;
                _contentView2.onReloadHeight = ^(CGFloat height) {
                    [weakSelf mas_updateConstraints:^(MASConstraintMaker* make) {
                        make.height.mas_equalTo(height);
                    }];
                };
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)zl_setXLabel:(NSArray<NSString*>*)array {
    switch (_type) {
        case zlLine: {
            [_contentView1 zl_setXLabel:array];
        }
            break;
        case zlShape: {
            [_contentView2 zl_setXLabel:array];
        }
            break;
        default:
            break;
    }
}

- (void)zl_setYLabel:(NSArray<NSString*>*)array {
    switch (_type) {
        case zlLine: {
            [_contentView1 zl_setYLabel:array];
        }
            break;
        case zlShape: {
            [_contentView2 zl_setYLabel:array];
        }
            break;
        default:
            break;
    }
}

- (void)zl_setDataArray:(NSArray<NSString*>*)array {
    switch (_type) {
        case zlLine: {
            [_contentView1 zl_setDataArray:array];
        }
            break;
        case zlShape: {
            [_contentView2 zl_setDataArray:array];
        }
            break;
        default:
            break;
    }
}

- (void)zl_reloadXArray:(NSArray<NSString*>*)xArray yArray:(NSArray<NSString*>*)yArray dataArray:(NSArray<NSString*>*)dataArray {
    switch (_type) {
        case zlLine: {
            [_contentView1 zl_reloadXArray:xArray yArray:yArray dataArray:dataArray];
        }
            break;
        case zlShape: {
            [_contentView2 zl_reloadXArray:xArray yArray:yArray dataArray:dataArray];
        }
            break;
        default:
            break;
    }
}

- (void)zl_setLineColor:(UIColor*)color {
    switch (_type) {
        case zlLine: {
            _contentView1.zl_lineColor = color;
        }
            break;
        case zlShape: {
            _contentView2.zl_lineColor = color;
        }
            break;
        default:
            break;
    }
}

- (void)setShowDataLabel:(BOOL)showDataLabel {
    _showDataLabel = showDataLabel;
    switch (_type) {
        case zlLine: {
            _contentView1.showDataLabel = showDataLabel;
        }
            break;
        case zlShape: {
            _contentView2.showDataLabel = showDataLabel;
        }
            break;
        default:
            break;
    }
}

- (void)zl_setTextColor:(UIColor*)color {
    switch (_type) {
        case zlLine: {
            _contentView1.zl_textColor = color;
        }
            break;
        case zlShape: {
            
        }
            break;
        default:
            break;
    }
}

- (UIScrollView*)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (void)onTouchPoint:(ZLLineContentView*)lineView point:(CGPoint)point index:(NSInteger)index {
    switch (_type) {
        case zlLine: {
            if (_delegate && [_delegate respondsToSelector:@selector(onTouchPoint:point:index:)]) {
                [_delegate onTouchPoint:self point:point index:index];
            }
        }
            break;
        case zlShape: {
            
        }
            break;
        default:
            break;
    }
}

@end
