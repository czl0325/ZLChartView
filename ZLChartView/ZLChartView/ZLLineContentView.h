//
//  ZLLineContentView.h
//  Seven
//
//  Created by zhaoliang chen on 2016/11/21.
//  Copyright © 2016年 zhaoliang chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLLineContentView;
@protocol ZLLineContentViewDelegate <NSObject>

- (void)onTouchPoint:(ZLLineContentView*)lineView point:(CGPoint)point index:(NSInteger)index;

@end

@interface ZLLineContentView : UIView

- (void)zl_setXLabel:(NSArray<NSString*>*)array;
- (void)zl_setYLabel:(NSArray<NSString*>*)array;
- (void)zl_setDataArray:(NSArray<NSString*>*)array;
- (void)zl_reloadXArray:(NSArray<NSString*>*)xArray yArray:(NSArray<NSString*>*)yArray dataArray:(NSArray<NSString*>*)dataArray;

@property(nonatomic,copy)void (^onReloadHeight)(CGFloat height);
@property(nonatomic,copy)UIColor* zl_lineColor;
@property(nonatomic,assign)BOOL showDataLabel;
@property(nonatomic,copy)UIColor* zl_textColor;

@property(nonatomic,assign)id<ZLLineContentViewDelegate> delegate;

@end
