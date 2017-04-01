//
//  SelectWeekCell.m
//  Lvmm
//
//  Created by zjy on 2017/3/21.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "SelectWeekCell.h"

@interface SelectWeekCell ()
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SelectWeekCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.frame = CGRectMake(0, 0, MAINSCREEN_SIZE.width, 80);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.titleLabel];
    
    NSArray *arr = @[@"周三",@"周二",@"周一",@"全部",@"周日",@"周六",@"周五",@"周四"];
    for (int i = 0; i < 8; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i + 100;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[JYConfig JYColorWithHexadecimal:kColorTextDarkDarkGray] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [JYConfig JYColorWithHexadecimal:kColorLineSplitCell].CGColor;
        [btn addTarget:self action:@selector(selectWeekdayAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 25));
            if (i < 4) {
                make.top.equalTo(self).offset(10);
                make.right.equalTo(self).offset(- (15 + 65 * i));
            } else {
                make.bottom.equalTo(self).offset(-10);
                make.right.equalTo(self).offset(- (15 + 65 * (i - 4)));
            }
        }];
    }
    
    [self initMasonry];
    return self;
}

- (void)initMasonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(60, 15));
        make.top.equalTo(self).offset(12);
    }];
}

- (void)selectWeekdayAction:(UIButton *)sender {
    if (sender.tag == 103) {
        for (int i = 0; i < 8; i ++) {
            UIButton *btn = [self viewWithTag:i + 100];
            if (btn.tag == 103) {
                [btn setTitleColor:[JYConfig JYColorWithHexadecimal:kColorMainRed] forState:UIControlStateNormal];
                btn.layer.borderColor = [JYConfig JYColorWithHexadecimal:kColorMainRed].CGColor;
            } else {
                [btn setTitleColor:[JYConfig JYColorWithHexadecimal:kColorTextDarkDarkGray] forState:UIControlStateNormal];
                btn.layer.borderColor = [JYConfig JYColorWithHexadecimal:kColorLineSplitCell].CGColor;
            }
        }
    } else {
        if ([sender.titleLabel.textColor isEqual:[JYConfig JYColorWithHexadecimal:kColorTextDarkDarkGray]]) {
            [sender setTitleColor:[JYConfig JYColorWithHexadecimal:kColorMainRed] forState:UIControlStateNormal];
            sender.layer.borderColor = [JYConfig JYColorWithHexadecimal:kColorMainRed].CGColor;
            UIButton *btn = [self viewWithTag:103];
            [btn setTitleColor:[JYConfig JYColorWithHexadecimal:kColorTextDarkDarkGray] forState:UIControlStateNormal];
            btn.layer.borderColor = [JYConfig JYColorWithHexadecimal:kColorLineSplitCell].CGColor;
        } else {
            [sender setTitleColor:[JYConfig JYColorWithHexadecimal:kColorTextDarkDarkGray] forState:UIControlStateNormal];
            sender.layer.borderColor = [JYConfig JYColorWithHexadecimal:kColorLineSplitCell].CGColor;
        }
    }
    _selectWeekDayBlock(sender);
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [JYConfig JYColorWithHexadecimal:kColorTextDarkGray];
        _titleLabel.text = @"适用日期";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
