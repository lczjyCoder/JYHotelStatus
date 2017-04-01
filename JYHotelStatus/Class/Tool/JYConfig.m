//
//  JYConfig.m
//  JYHotelStatus
//
//  Created by zjy on 2017/4/1.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "JYConfig.h"

//颜色常量
NSString *const kColorMainBlack                     = @"3232325f";//主色调黑色 50,50,50 透明度95%
NSString *const kColorMainBackground                = @"f8f8f864";//主背景色 248,248,248
NSString *const kColorMainRed                       = @"d3077564";//主色调红色 211,7,117
NSString *const kColorMainWhite                     = @"ffffff64";//主色调白色 255,255,255

NSString *const kColorLineSplitCell                 = @"dddddd64";//Cell分割线颜色 221,221,221
NSString *const kColorAssistGreen                   = @"7bc73064";//辅助色绿色 123,199,48
NSString *const kColorAssistOrange                  = @"ff740d64";//辅助色橙色 255,116,13
NSString *const kColorYYTScoreLabel                  = @"eb483f64";//积分标签的红色 235,72,63
NSString *const kColorBackgroundCellSelected        = @"eeeeee64";//Cell选中颜色 238,238,238

NSString *const kColorTextWhite                     = @"ffffff64";//字体白色 255,255,255
NSString *const kColorTextDarkGray                  = @"66666664";//字体黑灰色 102,102,102
NSString *const kColorTextDarkDarkGray              = @"33333364";//字体深黑灰色 51,51,51

static NSMutableDictionary *hexadecimalColorCache = nil;

@implementation JYConfig

+ (UIColor *)JYColorWithHexadecimal:(NSString *)hexadecimalStr {
    if ([hexadecimalStr hasPrefix:@"#"]) {
        hexadecimalStr = [hexadecimalStr substringFromIndex:1];
    }
    if ([hexadecimalStr length] == 6) {
        hexadecimalStr = [hexadecimalStr stringByAppendingString:@"64"];
    } else if ([hexadecimalStr length] < 6) {
        return [UIColor clearColor];
    }
    if ([hexadecimalColorCache objectForKey:hexadecimalStr]) {
        return [hexadecimalColorCache objectForKey:hexadecimalStr];
    }
    unsigned int red, green, blue, alpha;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexadecimalStr substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexadecimalStr substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexadecimalStr substringWithRange:range]] scanHexInt:&blue];
    range.location = 6;
    [[NSScanner scannerWithString:[hexadecimalStr substringWithRange:range]] scanHexInt:&alpha];
    
    UIColor *converColor = [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(alpha/100.0f)];
    if (converColor) {
        [hexadecimalColorCache setObject:converColor forKey:hexadecimalStr];
    }
    return converColor;
}

+ (UIView *)makeLineViewWithFrame:(CGRect)frame {
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = [JYConfig JYColorWithHexadecimal:kColorLineSplitCell];
    return lineView;
}

@end
