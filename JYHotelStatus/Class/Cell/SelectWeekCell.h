//
//  SelectWeekCell.h
//  Lvmm
//
//  Created by zjy on 2017/3/21.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectWeekDayBlock)(UIButton *selectedBtn);
@interface SelectWeekCell : UITableViewCell
@property (nonatomic, strong) SelectWeekDayBlock selectWeekDayBlock;
@end
