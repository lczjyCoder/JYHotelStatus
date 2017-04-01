//
//  JYConfig.h
//  JYHotelStatus
//
//  Created by zjy on 2017/4/1.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAINSCREEN_SIZE [UIScreen mainScreen].bounds.size

//颜色常量
extern NSString *const kColorMainBlack;
extern NSString *const kColorMainBackground;
extern NSString *const kColorMainRed;
extern NSString *const kColorMainWhite;

extern NSString *const kColorLineSplitCell;
extern NSString *const kColorAssistGreen;
extern NSString *const kColorAssistOrange;
extern NSString *const kColorYYTScoreLabel;
extern NSString *const kColorBackgroundCellSelected;

extern NSString *const kColorTextWhite;
extern NSString *const kColorTextDarkGray;
extern NSString *const kColorTextDarkDarkGray;

@interface JYConfig : NSObject

+ (UIColor *)JYColorWithHexadecimal:(NSString *)hexadecimalStr;
+ (UIView *)makeLineViewWithFrame:(CGRect)frame;
@end
