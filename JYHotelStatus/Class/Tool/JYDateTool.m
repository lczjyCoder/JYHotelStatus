//
//  EBKDateTool.m
//  Lvmm
//
//  Created by zjy on 2017/3/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "JYDateTool.h"

@interface JYDateTool ()

@end

@implementation JYDateTool
#pragma mark - Deal with Date

+ (JYDateTool *)shareJYDateTool {
    static JYDateTool *dateTool = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        dateTool = [[JYDateTool alloc] init];
        ;
    });
    return dateTool;
}

- (NSCalendar *)gregorian {
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorian;
}

- (NSDate *)dateWithIndexPath:(NSIndexPath *)index {
    NSIndexPath *todayIndexPath = [self todayIndexPath];
    NSInteger firstWeekday = [self firstWeekdayInSection:0];
    NSInteger newFirstWeekday = [self firstWeekdayInSection:index.section];
    NSDateComponents *todayComp = [self todayComponents];
    NSDateComponents *newComp = [[NSDateComponents alloc] init];
    [newComp setDay:todayComp.day + (index.row - todayIndexPath.row) - (newFirstWeekday - firstWeekday)];
    [newComp setMonth:index.section + todayComp.month];
    [newComp setYear:todayComp.year];
    NSDate *date = [self.gregorian dateFromComponents:newComp];
    return date;
}

- (NSIndexPath *)todayIndexPath {
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:[NSDate date]];
    NSDateComponents *todayComp = [self todayComponents];
    NSInteger row = firstWeekday + todayComp.day - 1;
    NSIndexPath *todayIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    return todayIndexPath;
}

- (NSDate *)systemDateWithDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSDate *systemDate = [date dateByAddingTimeInterval:time];
    return systemDate;
}

- (NSDateComponents *)componentsWithDate:(NSDate *)date {
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [self.gregorian components: unitFlags
                                               fromDate:date];
    return comp;
}

- (NSDateComponents *)todayComponents {
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [self.gregorian components: unitFlags
                                          fromDate:dt];
    return comp;
}

- (NSDateComponents *)currentComponents:(NSInteger)section {
    NSDateComponents *comp = [self todayComponents];
    if (section + comp.month > 12) {
        NSInteger moreYears = (section + comp.month) / 12;
        comp.month = section + comp.month - 12 * moreYears;
        comp.year = comp.year + moreYears;
        if (comp.month == 0) {
            comp.month = 12;
            comp.year = comp.year - 1;
        }
    } else {
        [comp setMonth:section + comp.month];
    }
    return comp;
}

- (NSInteger)firstWeekdayInSection:(NSInteger)section {
    [self.gregorian setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [self currentComponents:section];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [self.gregorian dateFromComponents:comp];
    
    NSUInteger firstWeekday = [self.gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date {
    [self.gregorian setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [self.gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [self.gregorian dateFromComponents:comp];
    
    NSUInteger firstWeekday = [self.gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date {
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

@end
