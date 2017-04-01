//
//  HotelChangeStatusCell.m
//  Lvmm
//
//  Created by zjy on 2017/3/21.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "HotelChangeStatusCell.h"

@interface HotelChangeStatusCell ()
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation HotelChangeStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.frame = CGRectMake(0, 0, MAINSCREEN_SIZE.width, 44);
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.statusLabel];
    [self initMasonry];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)initMasonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 15));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 15));
        make.centerY.equalTo(self);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(9, 16));
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkDarkGray];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.text = @"正常";
    }
    return _statusLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkGray];
        _titleLabel.text = @"房态";
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"listArrowIcon.png"];
    }
    return _arrowImageView;
}



@end
