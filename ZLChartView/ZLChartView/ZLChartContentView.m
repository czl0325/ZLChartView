//
//  ZLChartContentView.m
//  Seven
//
//  Created by zhaoliang chen on 2016/11/21.
//  Copyright © 2016年 zhaoliang chen. All rights reserved.
//

#import "ZLChartContentView.h"
#import "Masonry.h"

@interface ZLChartContentView()

@property (nonatomic,copy) NSArray* arrayXValues;
@property (nonatomic,copy) NSArray* arrayYValues;
@property (nonatomic,copy) NSArray* arrayDataValues;
@property (nonatomic,copy) NSMutableArray* arrayXpoints;

@end

@implementation ZLChartContentView

#define zlleft 40
#define zltop 10
#define zlright 10
#define zlheightY 30
#define zlwidthX 50
#define zlbottom 20
#define zlHourWidth 60
#define zlMinLength 25
#define zlMaxLength 150

@synthesize onReloadHeight;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _showDataLabel = NO;
        _zl_lineColor = [UIColor blackColor];
        _arrayXpoints = [NSMutableArray new];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
    
    //画X轴长线
    CGContextSetRGBStrokeColor(context, 180.0/255, 180.0/255, 180.0/255, 1.0);//线条颜色
    CGContextMoveToPoint(context, zlleft, _arrayYValues.count>0?_arrayYValues.count*zlheightY+zltop:rect.size.height-zlbottom);
    CGContextAddLineToPoint(context, zlleft+(_arrayXValues.count>0?[self getXLength]+20:rect.size.width-zlleft-20), _arrayYValues.count>0?_arrayYValues.count*zlheightY+zltop:rect.size.height-zlbottom);
    //CGContextDrawPath(context, kCGPathFillStroke);
    CGContextDrawPath(context, kCGPathStroke);
    
    //画Y轴长线
//    CGContextMoveToPoint(context, zlleft, zltop);
//    CGContextAddLineToPoint(context, zlleft, _arrayYValues.count>0?_arrayYValues.count*zlheightY+zltop:rect.size.height-zlbottom);
//    CGContextDrawPath(context, kCGPathFillStroke);
    
    if (_arrayXValues.count>0) {
        [_arrayXpoints removeAllObjects];
        for (int i=0; i<_arrayXValues.count; i++) {
            CGContextSetLineWidth(context, 0.5); CGContextSetFillColorWithColor(context,[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor);
            float length = 0.f, pointX = 0.f;
            if (_arrayXpoints.count > 0) {
                NSArray* array1 = [_arrayXValues[i-1] componentsSeparatedByString:@":"];
                NSString* str1_1 = array1[0];
                NSString* str1_2 = array1[1];
                NSDateComponents *comps1 = [[NSDateComponents alloc]init];
                [comps1 setMonth:01];
                [comps1 setDay:01];
                [comps1 setYear:2010];
                [comps1 setHour:[str1_1 integerValue]];
                [comps1 setMinute:[str1_2 integerValue]];
                [comps1 setSecond:0];
                NSCalendar *calendar1 = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDate *date1 = [calendar1 dateFromComponents:comps1];
                
                NSArray* array2 = [_arrayXValues[i] componentsSeparatedByString:@":"];
                NSString* str2_1 = array2[0];
                NSString* str2_2 = array2[1];
                NSDateComponents *comps2 = [[NSDateComponents alloc]init];
                [comps2 setMonth:01];
                [comps2 setDay:[str2_1 integerValue]<[str1_1 integerValue]?02:01];
                [comps2 setYear:2010];
                [comps2 setHour:[str2_1 integerValue]];
                [comps2 setMinute:[str2_2 integerValue]];
                [comps2 setSecond:0];
                NSCalendar *calendar2 = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDate *date2 = [calendar2 dateFromComponents:comps2];
                
                NSTimeInterval secondsInterval= [date2 timeIntervalSinceDate:date1];
                float last = [_arrayXpoints[_arrayXpoints.count-1] floatValue];
                length = (float)secondsInterval/(60*60)*zlHourWidth;
                if (length<zlMinLength) {
                    length=zlMinLength;
                }
                if (length>zlMaxLength) {
                    length=zlMaxLength;
                }
                pointX = last+length;
            } else {
                pointX = zlleft;
            }
            CGContextMoveToPoint(context, pointX, _arrayYValues.count>0?_arrayYValues.count*zlheightY+zltop:rect.size.height-zlbottom);
            CGContextAddLineToPoint(context, pointX, (_arrayYValues.count>0?_arrayYValues.count*zlheightY+zltop:rect.size.height-zlbottom)+5);
            CGContextDrawPath(context, kCGPathFillStroke);
            [_arrayXpoints addObject:[NSString stringWithFormat:@"%f",pointX]];
            
            NSString* str = _arrayXValues[i];
            CGContextSetLineWidth(context, 0.25);
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [str drawInRect:CGRectMake(pointX-20, (_arrayYValues.count>0?_arrayYValues.count*zlheightY+zltop:rect.size.height-zlbottom)+5, 40, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0],NSParagraphStyleAttributeName: paragraphStyle}];
        }
    }
    if (_arrayYValues.count>0) {
        CGFloat lengths[] = {3, 1.5};
        CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
        CGContextSetRGBStrokeColor(context, 180.0/255, 180.0/255, 180.0/255, 1.0);//线条颜色
        CGContextMoveToPoint(context, zlleft, zltop);
        CGContextAddLineToPoint(context, zlleft+(_arrayXValues.count>0?[self getXLength]:rect.size.width-zlleft-20), zltop);
        //CGContextStrokePath(context);
        CGContextDrawPath(context, kCGPathStroke);
        
        for (int i=0; i<_arrayYValues.count; i++) {
            NSString* str = _arrayYValues[i];
            CGContextSetLineWidth(context, 0.5);
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [str drawInRect:CGRectMake(0, zltop+(i+0.5)*zlheightY-8, zlleft, 15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0],NSParagraphStyleAttributeName: paragraphStyle}];
            
            CGFloat lengths[] = {3, 1.5};
            CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
            CGContextSetRGBStrokeColor(context, 180.0/255, 180.0/255, 180.0/255, 1.0);//线条颜色
            CGContextMoveToPoint(context, zlleft, zltop+(i+1)*zlheightY);
            CGContextAddLineToPoint(context, zlleft+(_arrayXValues.count>0?[self getXLength]:rect.size.width-zlleft-20), zltop+(i+1)*zlheightY);
            //CGContextStrokePath(context);
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    
    if (_arrayDataValues.count>0 && _arrayDataValues.count == _arrayXpoints.count-1) {
        for (int i=0; i<_arrayDataValues.count; i++) {
            NSString* str = _arrayDataValues[i];
            NSInteger state = [str integerValue];
            CGContextSetLineWidth(context, zlheightY-2);
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
            CGContextSetLineDash(context, 0, 0, 0);  //虚线还原
            CGContextMoveToPoint(context, [_arrayXpoints[i] floatValue], zltop+(state-1)*zlheightY+zlheightY/2);
            CGContextAddLineToPoint(context, [_arrayXpoints[i+1] floatValue], zltop+(state-1)*zlheightY+zlheightY/2);
            CGContextStrokePath(context);
        }
    }
}

- (void)zl_setXLabel:(NSArray<NSString*>*)array {
    _arrayXValues = array;
    float length = [self getXLength];
    
    [self setNeedsDisplay];
    
    [self mas_updateConstraints:^(MASConstraintMaker* make) {
        //make.width.mas_equalTo(zlleft+array.count*(zlwidthX-1)+40);
        make.width.mas_equalTo(length);
    }];
}

- (void)zl_setYLabel:(NSArray<NSString*>*)array {
    _arrayYValues = array;
    
    [self setNeedsDisplay];
    
    [self mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(_arrayYValues.count*zlheightY+zltop+20);
    }];
    
    if (onReloadHeight) {
        onReloadHeight(_arrayYValues.count*zlheightY+zltop+20);
    }
}

- (void)zl_setDataArray:(NSArray<NSString*>*)array {
    if (!(_arrayXValues.count > 0 && _arrayYValues.count > 0)) {
        return;
    }
    _arrayDataValues = array;
    
    [self setNeedsDisplay];
}

- (void)zl_reloadXArray:(NSArray<NSString*>*)xArray yArray:(NSArray<NSString*>*)yArray dataArray:(NSArray<NSString*>*)dataArray {
    if (!(xArray.count > 0 && yArray.count > 0)) {
        return;
    }
    
    _arrayXValues = xArray;
    float length = [self getXLength];
    _arrayYValues = yArray;
    _arrayDataValues = dataArray;
    [self setNeedsDisplay];
    
    [self mas_updateConstraints:^(MASConstraintMaker* make) {
        //make.width.mas_equalTo(zlleft+xArray.count*(zlwidthX-1)+40);
        make.width.mas_equalTo(length+zlleft+10);
    }];
    [self mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(_arrayYValues.count*zlheightY+zltop+20);
    }];
    
    if (onReloadHeight) {
        onReloadHeight(_arrayYValues.count*zlheightY+zltop+20);
    }
}

- (void)setZl_lineColor:(UIColor *)zl_lineColor {
    _zl_lineColor = zl_lineColor;
    
    [self setNeedsDisplay];
}

- (void)setShowDataLabel:(BOOL)showDataLabel {
    _showDataLabel = showDataLabel;
    
}

- (float)getXLength {
    [_arrayXpoints removeAllObjects];
    for (int i=0; i<_arrayXValues.count; i++) {
        float length = 0.f, pointX = 0.f;
        if (_arrayXpoints.count > 0) {
            NSArray* array1 = [_arrayXValues[i-1] componentsSeparatedByString:@":"];
            NSString* str1_1 = array1[0];
            NSString* str1_2 = array1[1];
            NSDateComponents *comps1 = [[NSDateComponents alloc]init];
            [comps1 setMonth:01];
            [comps1 setDay:01];
            [comps1 setYear:2010];
            [comps1 setHour:[str1_1 integerValue]];
            [comps1 setMinute:[str1_2 integerValue]];
            [comps1 setSecond:0];
            NSCalendar *calendar1 = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *date1 = [calendar1 dateFromComponents:comps1];
            
            NSArray* array2 = [_arrayXValues[i] componentsSeparatedByString:@":"];
            NSString* str2_1 = array2[0];
            NSString* str2_2 = array2[1];
            NSDateComponents *comps2 = [[NSDateComponents alloc]init];
            [comps2 setMonth:01];
            [comps2 setDay:[str2_1 integerValue]<[str1_1 integerValue]?02:01];
            [comps2 setYear:2010];
            [comps2 setHour:[str2_1 integerValue]];
            [comps2 setMinute:[str2_2 integerValue]];
            [comps2 setSecond:0];
            NSCalendar *calendar2 = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *date2 = [calendar2 dateFromComponents:comps2];
            
            NSTimeInterval secondsInterval= [date2 timeIntervalSinceDate:date1];
            float last = [_arrayXpoints[_arrayXpoints.count-1] floatValue];
            length = (float)secondsInterval/(60*60)*zlHourWidth;
            if (length<zlMinLength) {
                length=zlMinLength;
            }
            if (length>zlMaxLength) {
                length=zlMaxLength;
            }
            pointX = last+length;
        } else {
            pointX = zlleft;
        }
        [_arrayXpoints addObject:[NSString stringWithFormat:@"%f",pointX]];
    }
    if (_arrayXpoints.count > 0) {
        return [[_arrayXpoints lastObject] floatValue];
    }
    return 0.f;
}

@end
