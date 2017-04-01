//
//  HotelStatusCell.h
//  Lvmm
//
//  Created by zjy on 2017/3/20.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotelStatusModel;
@interface HotelStatusDateCell : UICollectionViewCell

@property (nonatomic, strong) UIView *selectBGView;

- (void)resetCell:(HotelStatusModel *)model;

@end
