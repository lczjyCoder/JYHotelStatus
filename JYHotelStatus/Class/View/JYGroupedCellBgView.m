//
//  EBKGroupedCellBgView.m
//  Lvmm
//
//  Created by zjy on 16/8/19.
//  Copyright © 2016年 personal. All rights reserved.
//

#import "JYGroupedCellBgView.h"

@implementation JYGroupedCellBgView

- (id)initWithFrame:(CGRect)frame withDataSourceCount:(NSUInteger)count withIndex:(NSInteger)index isPlain:(BOOL)isPlain needArrow:(BOOL)needArrow isSelected:(BOOL)isSelected {
    _groupedCellStyle = [JYGroupedCellBgView checkCellStyle:count index:index];
    self = [super initWithFrame:CGRectMake(0, 0, MAINSCREEN_SIZE.width, CGRectGetHeight(frame))];
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        _needArrow = needArrow;
        _isSelected = isSelected;
        _isPlain = isPlain;
        [self setNeedsDisplay];
    }
    return self;
}

+ (GroupedCellStyle)checkCellStyle:(NSUInteger)count index:(NSInteger)index {
    if (count > 0) {
        if (count > 1) {
            if (index == 0) {
                return GroupedCellStyle_Top;
            }
            if (index == count - 1) {
                return GroupedCellStyle_Bottom;
            }
            return GroupedCellStyle_Middle;
        }
        return GroupedCellStyle_Single;
    }
    return GroupedCellStyle_None;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef _context = UIGraphicsGetCurrentContext();
    CGColorRef _contextColor = [JYConfig JYColorWithHexadecimal:(_isSelected?kColorBackgroundCellSelected:kColorMainWhite)].CGColor;
    CGContextBeginPath(_context);
    CGContextSetFillColorWithColor(_context, _contextColor);//设置颜色
    CGContextFillRect(_context, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height));
    CGContextStrokePath(_context);
    
    CGFloat minx = CGRectGetMinX(rect) + ((!_isPlain)?10:0), maxx = CGRectGetMaxX(rect), miny = CGRectGetMinY(rect), maxy = CGRectGetMaxY(rect);
    
    switch (_groupedCellStyle) {
        case GroupedCellStyle_Top:
        {
            CGContextSetStrokeColorWithColor(_context, [JYConfig JYColorWithHexadecimal:kColorLineSplitCell].CGColor);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx, miny);
            CGContextAddLineToPoint(_context, maxx, miny);
            CGContextStrokePath(_context);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx + 10, maxy);
            CGContextAddLineToPoint(_context, maxx - 10, maxy);
            CGContextStrokePath(_context);
            
            if (_needArrow) {
                UIGraphicsPushContext(_context);
                if (_isPlain) {
                    [[UIImage imageNamed:@"cellArrow.png"] drawInRect:CGRectMake(maxx - 20, (maxy - 15) / 2.0, 10, 15)];
                } else {
                    [[UIImage imageNamed:@"cellArrow.png"] drawInRect:CGRectMake(maxx - 30, (maxy - 15) / 2.0, 10, 15)];
                }
                UIGraphicsPopContext();
            }
        }
            break;
        case GroupedCellStyle_Middle:
        {
            CGContextSetStrokeColorWithColor(_context, [JYConfig JYColorWithHexadecimal:kColorLineSplitCell].CGColor);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx + 10, maxy);
            CGContextAddLineToPoint(_context, maxx - 10, maxy);
            CGContextStrokePath(_context);
            
            if (_needArrow) {
                UIGraphicsPushContext(_context);
                if (_isPlain) {
                    [[UIImage imageNamed:@"cellArrow.png"] drawInRect:CGRectMake(maxx - 20, (maxy - 15) / 2.0, 10, 15)];
                } else {
                    [[UIImage imageNamed:@"cellArrow.png"] drawInRect:CGRectMake(maxx - 30, (maxy - 15) / 2.0, 10, 15)];
                }
                UIGraphicsPopContext();
            }
            
        }
            break;
        case GroupedCellStyle_Bottom:
        {
            CGContextSetStrokeColorWithColor(_context, [JYConfig JYColorWithHexadecimal:kColorLineSplitCell].CGColor);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx, maxy);
            CGContextAddLineToPoint(_context, maxx, maxy);
            CGContextStrokePath(_context);
            
            if (_needArrow) {
                UIGraphicsPushContext(_context);
                if (_isPlain) {
                    [[UIImage imageNamed:@"cellArrow.png"] drawInRect:CGRectMake(maxx - 20, (maxy - 15) / 2.0, 10, 15)];
                } else {
                    [[UIImage imageNamed:@"cellArrow.png"] drawInRect:CGRectMake(maxx - 30, (maxy - 15) / 2.0, 10, 15)];
                }
                UIGraphicsPopContext();
            }
        }
            break;
        case GroupedCellStyle_Single:
        {
            minx = CGRectGetMinX(rect);
            CGContextSetStrokeColorWithColor(_context, [JYConfig JYColorWithHexadecimal:kColorLineSplitCell].CGColor);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx, miny);
            CGContextAddLineToPoint(_context, maxx, miny);
            CGContextStrokePath(_context);
            
            CGContextBeginPath(_context);
            CGContextMoveToPoint(_context, minx, maxy);
            CGContextAddLineToPoint(_context, maxx, maxy);
            CGContextStrokePath(_context);
            
            if (_needArrow) {
                UIGraphicsPushContext(_context);
                if (_isPlain) {
                    [[UIImage imageNamed:@"cellArrow.png"] drawInRect:CGRectMake(maxx - 20, (maxy - 15) / 2.0, 10, 15)];
                } else {
                    [[UIImage imageNamed:@"cellArrow.png"] drawInRect:CGRectMake(maxx - 30, (maxy - 15) / 2.0, 10, 15)];
                }
                UIGraphicsPopContext();
            }
        }
            break;
        case GroupedCellStyle_None:
        {
            if (_needArrow) {
                UIGraphicsPushContext(_context);
                if (_isPlain) {
                    [[UIImage imageNamed:@"cellArrow.png"] drawInRect:CGRectMake(maxx - 20, (maxy - 15) / 2.0, 10, 15)];
                } else {
                    [[UIImage imageNamed:@"cellArrow.png"] drawInRect:CGRectMake(maxx - 30, (maxy - 15) / 2.0, 10, 15)];
                }
                UIGraphicsPopContext();
            }
        }
            break;
        default:
            break;
    }
}

@end
