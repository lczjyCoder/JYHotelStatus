//
//  HotelStatusModel.m
//  Lvmm
//
//  Created by zjy on 2017/3/21.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "HotelStatusModel.h"
#import "JYDateTool.h"

@implementation HotelStatusModel

- (void)setDate:(NSDate *)date {
    _date = date;
    _firstWeekday = [[JYDateTool shareJYDateTool] firstWeekdayInThisMonth:date];
    NSInteger weekday = [[JYDateTool shareJYDateTool] componentsWithDate:date].weekday;
    switch (weekday) {
        case 1:
            _weekday = @"周日";
            break;
        case 2:
            _weekday = @"周一";
            break;
        case 3:
            _weekday = @"周二";
            break;
        case 4:
            _weekday = @"周三";
            break;
        case 5:
            _weekday = @"周四";
            break;
        case 6:
            _weekday = @"周五";
            break;
        case 7:
            _weekday = @"周六";
            break;
        default:
            break;
    }
}

@end
