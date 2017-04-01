//
//  HotelStatusModel.h
//  Lvmm
//
//  Created by zjy on 2017/3/21.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelStatusModel : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *remainNum;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger firstWeekday;
@property (nonatomic, strong) NSString *weekday;
@end
