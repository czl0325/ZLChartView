//
//  ZLLineContentView.m
//  Seven
//
//  Created by zhaoliang chen on 2016/11/21.
//  Copyright © 2016年 zhaoliang chen. All rights reserved.
//

#import "ZLLineContentView.h"
#import "Masonry.h"

@interface ZLLineContentView()

@property (nonatomic,copy) NSArray* arrayXValues;
@property (nonatomic,copy) NSArray* arrayYValues;
@property (nonatomic,copy) NSArray* arrayDataValues;
@property (nonatomic,strong) NSMutableArray* arrayPoints;

@end

@implementation ZLLineContentView

#define zlleft 40
#define zltop 20
#define zlright 10
#define zlheightY 20
#define zlwidthX 35
#define zlbottom 10
#define zlLabelWidth 40

@synthesize onReloadHeight;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _zl_lineColor = [UIColor blackColor];
        _showDataLabel = NO;
        _arrayPoints = [NSMutableArray new];
        _zl_textColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    //画X轴长线
    //CGContextSetFillColorWithColor(context,UIColorFromRGB(0x333333).CGColor);
    CGContextSetRGBStrokeColor(context, 180.0/255, 180.0/255, 180.0/255, 1.0);//线条颜色
    CGContextMoveToPoint(context, zlleft, zltop);
    CGFloat xWidth = 0.0f;
    if (_arrayXValues.count>0) {
        if ((_arrayXValues.count*(zlwidthX-1)+20) > (self.superview.mas_width.view.frame.size.width-zlleft-20)) {
            xWidth = zlleft+_arrayXValues.count*zlwidthX;
        } else {
            xWidth = zlleft+self.superview.superview.mas_width.view.frame.size.width-zlleft-20;
        }
    } else {
        xWidth = zlleft+self.superview.superview.mas_width.view.frame.size.width-zlleft-20;
    }
    CGContextAddLineToPoint(context, xWidth, zltop);
    CGContextDrawPath(context, kCGPathStroke);
    
    //画Y轴长线
    CGContextSetRGBStrokeColor(context, 180.0/255, 180.0/255, 180.0/255, 1.0);//线条颜色
    CGContextMoveToPoint(context, zlleft, zltop);
    CGContextAddLineToPoint(context, zlleft, _arrayYValues.count>0?(_arrayYValues.count-1)*zlheightY+zltop:rect.size.height-zlbottom);
    CGContextDrawPath(context, kCGPathStroke);
    
    if (_arrayXValues.count>0) {
        for (int i=0; i<_arrayXValues.count; i++) {
            NSString* str = _arrayXValues[i];
            CGContextSetLineWidth(context, 0.25);
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [str drawInRect:CGRectMake(zlleft+(i+1)*zlwidthX-15, 5, 30, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0],NSParagraphStyleAttributeName: paragraphStyle}];
            
            CGContextSetLineWidth(context, 0.5);
            CGContextMoveToPoint(context, zlleft+(i+1)*zlwidthX, zltop);
            CGContextAddLineToPoint(context, zlleft+(i+1)*zlwidthX, zltop+5);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    
    if (_arrayYValues.count>0) {
        for (int i=0; i<_arrayYValues.count; i++) {
            NSString* str = _arrayYValues[i];
            CGContextSetLineWidth(context, 0.5);
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            paragraphStyle.lineBreakMode = NSLineBreakByClipping;
            [str drawInRect:CGRectMake(0, zltop+i*zlheightY-5, zlleft, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0],NSParagraphStyleAttributeName: paragraphStyle}];
            
            if (i>0) {
                CGContextSetFillColorWithColor(context,[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor);
                CGContextMoveToPoint(context, zlleft, zltop+i*zlheightY);
                CGContextAddLineToPoint(context, zlleft+5, zltop+i*zlheightY);
                CGContextStrokePath(context);
            }
        }
    }
    
    if (_arrayDataValues.count>0) {
        if (_arrayPoints) {
            [_arrayPoints removeAllObjects];
        }
        CGColorRef color = [_zl_lineColor CGColor];
        size_t numComponents = CGColorGetNumberOfComponents(color);
        if (numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents(color);
            CGFloat R = components[0];
            CGFloat G = components[1];
            CGFloat B = components[2];
            CGContextSetRGBStrokeColor(context, R, G, B, 1.0);//线条颜色
        }
        
        CGContextSetLineWidth(context, 2.0);
        for (int i=0; i<_arrayDataValues.count; i++) {
            if (i < _arrayDataValues.count - 1) {
                CGFloat max = [_arrayYValues[0] floatValue];
                CGFloat yData1 = [_arrayDataValues[i] floatValue];
                CGFloat yData2 = [_arrayDataValues[i+1] floatValue];
                CGFloat yHeight = (_arrayYValues.count-1)*zlheightY;
                CGFloat y1 = (1-(yData1/max))*yHeight+zltop;
                CGFloat y2 = (1-(yData2/max))*yHeight+zltop;
                
                CGContextMoveToPoint(context, zlleft+(i+1)*zlwidthX, y1);
                CGContextAddLineToPoint(context, zlleft+(i+2)*zlwidthX, y2);
                CGContextStrokePath(context);
            }
        }
        
        if (_arrayDataValues.count == 1) {
            CGFloat max = [_arrayYValues[0] floatValue];
            CGFloat yData1 = [_arrayDataValues[0] floatValue];
            CGFloat yHeight = (_arrayYValues.count-1)*zlheightY;
            CGFloat y1 = (1-(yData1/max))*yHeight+zltop;
            CGContextAddArc(context, zlleft+zlwidthX, y1, 3, 0, 2*M_PI, 0);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充颜色
            CGColorRef color = [_zl_lineColor CGColor];
            size_t numComponents = CGColorGetNumberOfComponents(color);
            if (numComponents == 4) {
                const CGFloat *components = CGColorGetComponents(color);
                CGFloat R = components[0];
                CGFloat G = components[1];
                CGFloat B = components[2];
                CGContextSetRGBStrokeColor(context, R, G, B, 1.0);//线条颜色
            }
            CGContextSetLineWidth(context, 1.5);
            CGContextDrawPath(context, kCGPathFillStroke);
            [_arrayPoints addObject:NSStringFromCGPoint(CGPointMake(zlleft+zlwidthX, y1))];
            
            if (_showDataLabel) {
                CGContextSetLineWidth(context, 0.5);
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.alignment = NSTextAlignmentCenter;
                if (y1 < zltop+30) {
                    [_arrayDataValues[0] drawInRect:CGRectMake(zlleft+zlwidthX-zlLabelWidth/2, y1+5, zlLabelWidth, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0],NSParagraphStyleAttributeName: paragraphStyle}];
                } else {
                    [_arrayDataValues[0] drawInRect:CGRectMake(zlleft+zlwidthX-zlLabelWidth/2, y1-15, zlLabelWidth, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0],NSParagraphStyleAttributeName: paragraphStyle}];
                }
            }
        } else {
            for (int i=0; i<_arrayDataValues.count; i++) {
                if (i < _arrayDataValues.count - 1) {
                    CGFloat max = [_arrayYValues[0] floatValue];
                    CGFloat yData1 = [_arrayDataValues[i] floatValue];
                    CGFloat yData2 = [_arrayDataValues[i+1] floatValue];
                    CGFloat yHeight = (_arrayYValues.count-1)*zlheightY;
                    CGFloat y1 = (1-(yData1/max))*yHeight+zltop;
                    CGFloat y2 = (1-(yData2/max))*yHeight+zltop;
                    
                    if (i>0) {
                        CGContextAddArc(context, zlleft+(i+2)*zlwidthX, y2, 3, 0, 2*M_PI, 0);
                        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充颜色
                        CGContextSetLineWidth(context, 1.5);
                        CGColorRef color = [_zl_lineColor CGColor];
                        size_t numComponents = CGColorGetNumberOfComponents(color);
                        if (numComponents == 4) {
                            const CGFloat *components = CGColorGetComponents(color);
                            CGFloat R = components[0];
                            CGFloat G = components[1];
                            CGFloat B = components[2];
                            CGContextSetRGBStrokeColor(context, R, G, B, 1.0);//线条颜色
                        }
                        CGContextDrawPath(context, kCGPathFillStroke);
                        [_arrayPoints addObject:NSStringFromCGPoint(CGPointMake(zlleft+(i+2)*zlwidthX, y2))];
                        
                        if (_showDataLabel) {
                            CGContextSetLineWidth(context, 0.5);
                            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                            paragraphStyle.alignment = NSTextAlignmentCenter;
                            if (y2 < zltop+30) {
                                [_arrayDataValues[i+1] drawInRect:CGRectMake(zlleft+(i+2)*zlwidthX-zlLabelWidth/2, y2+5, zlLabelWidth, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:_zl_textColor,NSParagraphStyleAttributeName: paragraphStyle}];
                            } else {
                                [_arrayDataValues[i+1] drawInRect:CGRectMake(zlleft+(i+2)*zlwidthX-zlLabelWidth/2, y2-15, zlLabelWidth, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:_zl_textColor,NSParagraphStyleAttributeName: paragraphStyle}];
                            }
                        }
                    } else {
                        CGContextAddArc(context, zlleft+(i+1)*zlwidthX, y1, 3, 0, 2*M_PI, 0);
                        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充颜色
                        CGContextSetLineWidth(context, 1.5);
                        CGContextDrawPath(context, kCGPathFillStroke);
                        CGContextAddArc(context, zlleft+(i+2)*zlwidthX, y2, 3, 0, 2*M_PI, 0);
                        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充颜色
                        CGContextSetLineWidth(context, 1.5);
                        CGColorRef color = [_zl_lineColor CGColor];
                        size_t numComponents = CGColorGetNumberOfComponents(color);
                        if (numComponents == 4) {
                            const CGFloat *components = CGColorGetComponents(color);
                            CGFloat R = components[0];
                            CGFloat G = components[1];
                            CGFloat B = components[2];
                            CGContextSetRGBStrokeColor(context, R, G, B, 1.0);//线条颜色
                        }
                        CGContextDrawPath(context, kCGPathFillStroke);
                        [_arrayPoints addObject:NSStringFromCGPoint(CGPointMake(zlleft+(i+1)*zlwidthX, y1))];
                        [_arrayPoints addObject:NSStringFromCGPoint(CGPointMake(zlleft+(i+2)*zlwidthX, y2))];
                        
                        if (_showDataLabel) {
                            CGContextSetLineWidth(context, 0.5);
                            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                            paragraphStyle.alignment = NSTextAlignmentCenter;
                            if (y1 < zltop+30) {
                                [_arrayDataValues[i] drawInRect:CGRectMake(zlleft+(i+1)*zlwidthX-zlLabelWidth/2, y1+5, zlLabelWidth, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:_zl_textColor,NSParagraphStyleAttributeName: paragraphStyle}];
                            } else {
                                [_arrayDataValues[i] drawInRect:CGRectMake(zlleft+(i+1)*zlwidthX-zlLabelWidth/2, y1-15, zlLabelWidth, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:_zl_textColor,NSParagraphStyleAttributeName: paragraphStyle}];
                            }
                            if (y2 < zltop+30) {
                                [_arrayDataValues[i+1] drawInRect:CGRectMake(zlleft+(i+2)*zlwidthX-zlLabelWidth/2, y2+5, zlLabelWidth, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:_zl_textColor,NSParagraphStyleAttributeName: paragraphStyle}];
                            } else {
                                [_arrayDataValues[i+1] drawInRect:CGRectMake(zlleft+(i+2)*zlwidthX-zlLabelWidth/2, y2-15, zlLabelWidth, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:_zl_textColor,NSParagraphStyleAttributeName: paragraphStyle}];
                            }
                        }
                    }
                }
            }
        }
    } else {
//        CGContextSetLineWidth(context, 2.0);
//        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//        paragraphStyle.alignment = NSTextAlignmentCenter;
//        [@"暂无数据" drawInRect:CGRectMake(rect.size.width/2-60, rect.size.height/2-15, 120, 30) withAttributes:@{NSFontAttributeName:Font(25),NSForegroundColorAttributeName:[UIColor redColor],NSParagraphStyleAttributeName: paragraphStyle}];
    }
}

- (void)zl_setXLabel:(NSArray<NSString*>*)array {
    _arrayXValues = array;
    
    [self setNeedsDisplay];
    
    [self mas_updateConstraints:^(MASConstraintMaker* make) {
        CGFloat xWidth = 0.0f;
        if (_arrayXValues.count>0) {
            if ((_arrayXValues.count*(zlwidthX-1)+20) > (self.superview.mas_width.view.frame.size.width-zlleft-20)) {
                xWidth = zlleft+_arrayXValues.count*(zlwidthX-1)+40;
            } else {
                xWidth = zlleft+self.superview.superview.mas_width.view.frame.size.width-zlleft-20;
            }
        } else {
            xWidth = zlleft+self.superview.superview.mas_width.view.frame.size.width-zlleft-20;
        }
        make.width.mas_equalTo(xWidth);
    }];
}

- (void)zl_setYLabel:(NSArray<NSString*>*)array {
    _arrayYValues = array;
    
    [self setNeedsDisplay];
    
    [self mas_updateConstraints:^(MASConstraintMaker* make) {
        if (_arrayYValues.count > 0) {
            make.height.mas_equalTo(_arrayYValues.count*zlheightY+zltop+20);
        } /*else {
           make.height.mas_equalTo(self.superview.superview.mas_height);
           } */
    }];
    
    if (onReloadHeight) {
        onReloadHeight(_arrayYValues.count*zlheightY+zltop+20);
    }
}

- (void)zl_setDataArray:(NSArray<NSString*>*)array {
    _arrayDataValues = array;
    
    [self setNeedsDisplay];
}

- (void)zl_reloadXArray:(NSArray<NSString*>*)xArray yArray:(NSArray<NSString*>*)yArray dataArray:(NSArray<NSString*>*)dataArray {
    _arrayXValues = xArray;
    _arrayYValues = yArray;
    _arrayDataValues = dataArray;
    [self setNeedsDisplay];
    
    [self mas_updateConstraints:^(MASConstraintMaker* make) {
        CGFloat xWidth = 0.0f;
        if (_arrayXValues.count>0) {
            if ((_arrayXValues.count*(zlwidthX-1)+20) > (self.superview.mas_width.view.frame.size.width-zlleft-20)) {
                xWidth = zlleft+_arrayXValues.count*(zlwidthX-1)+40;
            } else {
                xWidth = zlleft+self.superview.superview.mas_width.view.frame.size.width-zlleft-20;
            }
        } else {
            xWidth = zlleft+self.superview.superview.mas_width.view.frame.size.width-zlleft-20;
        }
        make.width.mas_equalTo(xWidth);
    }];
    [self mas_updateConstraints:^(MASConstraintMaker* make) {
        if (_arrayYValues.count > 0) {
            make.height.mas_equalTo(_arrayYValues.count*zlheightY+zltop);
        } /*else {
            make.height.mas_equalTo(self.superview.superview.mas_height);
        } */
    }];
    
    if (onReloadHeight) {
        if (_arrayYValues.count > 0) {
            onReloadHeight(_arrayYValues.count*zlheightY+zltop);
        }
    }
}

- (void)setZl_lineColor:(UIColor *)zl_lineColor {
    _zl_lineColor = zl_lineColor;
    
    [self setNeedsDisplay];
}

- (void)setShowDataLabel:(BOOL)showDataLabel {
    _showDataLabel = showDataLabel;
    
    [self setNeedsDisplay];
}

- (void)setZl_textColor:(UIColor *)zl_textColor {
    _zl_textColor = zl_textColor;
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point1 = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    for (int i=0; i<_arrayPoints.count; i++) {
        NSString* str = _arrayPoints[i];
        CGPoint point2 = CGPointFromString(str);
        if ((point1.x>(point2.x-20))
            &&point1.x<(point2.x+20)
            &&point1.y>(point2.y-20)
            &&point1.y<(point2.y+20)) {
            if (_delegate && [_delegate respondsToSelector:@selector(onTouchPoint:point:index:)]) {
                [_delegate onTouchPoint:self point:point2 index:i];
            }
            break;
        }
    }
}

@end
