//
//  ZLShapeChart.h
//  Seven
//
//  Created by zhaoliang chen on 2016/11/18.
//  Copyright © 2016年 zhaoliang chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    zlLine = 1,
    zlShape,
}ZLChartType;

@class ZLShapeChart;
@protocol ZLShapeChartDelegate <NSObject>
@optional
- (void)onTouchPoint:(ZLShapeChart*)chart point:(CGPoint)point index:(NSInteger)index;
@end

@interface ZLShapeChart : UIView

- (instancetype)initWithType:(ZLChartType)type;

- (void)zl_setXLabel:(NSArray<NSString*>*)array;
- (void)zl_setYLabel:(NSArray<NSString*>*)array;
- (void)zl_setDataArray:(NSArray<NSString*>*)array;
- (void)zl_reloadXArray:(NSArray<NSString*>*)xArray yArray:(NSArray<NSString*>*)yArray dataArray:(NSArray<NSString*>*)dataArray;
- (void)zl_setLineColor:(UIColor*)color;
- (void)zl_setTextColor:(UIColor*)color;

@property(nonatomic,assign)id<ZLShapeChartDelegate> delegate;
@property(nonatomic,assign)BOOL showDataLabel;

@end
