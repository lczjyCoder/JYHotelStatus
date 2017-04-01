//
//  HotelStatusCell.m
//  Lvmm
//
//  Created by zjy on 2017/3/20.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "HotelStatusDateCell.h"
#import "HotelStatusModel.h"
#import "JYDateTool.h"

@interface HotelStatusDateCell ()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *remainNumLabel;
@end

@implementation HotelStatusDateCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.selectBGView];
    [self addSubview:self.dateLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.remainNumLabel];
    [self initMasonry];
    return self;
}

- (void)resetCell:(HotelStatusModel *)model {
    self.dateLabel.text = [NSString stringWithFormat:@"%ld",[[JYDateTool shareJYDateTool] componentsWithDate:model.date].day];
    self.statusLabel.text = model.status;
    if ([self.statusLabel.text isEqualToString:@"正常"]) {
        self.statusLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorAssistGreen];
    } else if ([self.statusLabel.text isEqualToString:@"紧张"]) {
        self.statusLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorAssistOrange];
    } else {
        self.statusLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorYYTScoreLabel];
    }
    self.remainNumLabel.text = model.remainNum;
    if (model.selected) {
        self.selectBGView.backgroundColor = [JYConfig JYColorWithHexadecimal:@"FDEAF3"];
    } else {
        self.selectBGView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.dateLabel.text = @"";
    self.statusLabel.text = @"";
    self.remainNumLabel.text = @"";
    self.selectBGView.backgroundColor = [UIColor whiteColor];
}

- (void)initMasonry {
    [self.selectBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(4);
        make.right.equalTo(self).offset(-4);
        make.top.equalTo(self).offset(4);
        make.bottom.equalTo(self).offset(-4);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBGView);
        make.right.equalTo(self.selectBGView);
        make.top.equalTo(self.selectBGView).offset(1);
        make.height.mas_equalTo(14);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBGView);
        make.right.equalTo(self.selectBGView);
        make.top.equalTo(self.dateLabel.mas_bottom).offset(2);
        make.height.mas_equalTo(12);
    }];
    
    [self.remainNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBGView);
        make.right.equalTo(self.selectBGView);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(2);
        make.height.mas_equalTo(12);
    }];
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        _dateLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkDarkGray];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:10];
        _statusLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorAssistGreen];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (UILabel *)remainNumLabel {
    if (!_remainNumLabel) {
        _remainNumLabel = [[UILabel alloc] init];
        _remainNumLabel.font = [UIFont systemFontOfSize:10];
        _remainNumLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkGray];
        _remainNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _remainNumLabel;
}

- (UIView *)selectBGView {
    if (!_selectBGView) {
        _selectBGView = [[UIView alloc] init];
        _selectBGView.layer.cornerRadius = 3;
        _selectBGView.backgroundColor = [UIColor whiteColor];
    }
    return _selectBGView;
}
@end
