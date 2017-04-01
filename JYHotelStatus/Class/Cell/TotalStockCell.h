//
//  TotalStockCell.h
//  Lvmm
//
//  Created by zjy on 2017/3/21.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeStockBlock)(NSString *stock);
@interface TotalStockCell : UITableViewCell
@property (nonatomic, strong) UITextField *stockTextField;
@property (nonatomic, strong) ChangeStockBlock changeStockBlock;
@end
