//
//  RemainStockCell.m
//  Lvmm
//
//  Created by zjy on 2017/3/22.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "RemainStockCell.h"

@interface RemainStockCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *remainStockLabel;
@end

@implementation RemainStockCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.frame = CGRectMake(0, 0, MAINSCREEN_SIZE.width, 50);
    [self addSubview:self.titleLabel];
    [self addSubview:self.remainStockLabel];
    [self initMasonry];
    return self;
}

- (void)resetCell:(NSString *)remainStock {
    self.remainStockLabel.text = remainStock;
}

- (void)initMasonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 15));
    }];
    [self.remainStockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 15));
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkGray];
        _titleLabel.text = @"总库存";
    }
    return _titleLabel;
}

- (UILabel *)remainStockLabel {
    if (!_remainStockLabel) {
        _remainStockLabel = [[UILabel alloc] init];
        _remainStockLabel.font = [UIFont systemFontOfSize:13];
        _remainStockLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkGray];
        _remainStockLabel.textAlignment = NSTextAlignmentRight;
        _remainStockLabel.text = @"50间";
    }
    return _remainStockLabel;
}



@end
