//
//  EBKDateTool.h
//  Lvmm
//
//  Created by zjy on 2017/3/23.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@interface JYDateTool : NSObject

@property (nonatomic, strong) NSCalendar *gregorian;

+ (JYDateTool *)shareJYDateTool;

- (NSDate *)dateWithIndexPath:(NSIndexPath *)index;
- (NSIndexPath *)todayIndexPath;
- (NSDate *)systemDateWithDate:(NSDate *)date;
- (NSDateComponents *)todayComponents;
- (NSDateComponents *)currentComponents:(NSInteger)section;
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
- (NSInteger)totaldaysInMonth:(NSDate *)date;
- (NSDateComponents *)componentsWithDate:(NSDate *)date;
- (NSInteger)firstWeekdayInSection:(NSInteger)section;
@end
