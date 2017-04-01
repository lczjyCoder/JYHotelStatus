//
//  TotalStockCell.m
//  Lvmm
//
//  Created by zjy on 2017/3/21.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "TotalStockCell.h"

@interface TotalStockCell () <UITextFieldDelegate> {
    NSInteger stockNum;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *subtractBtn;
@property (nonatomic, strong) UIButton *addBtn;
@end

@implementation TotalStockCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.frame = CGRectMake(0, 0, MAINSCREEN_SIZE.width, 55);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    stockNum = 50;
    [self addSubview:self.titleLabel];
    [self addSubview:self.addBtn];
    [self addSubview:self.subtractBtn];
    [self addSubview:self.stockTextField];
    [self initMasonry];
    return self;
}

- (void)addStockAction:(UIButton *)sender {
    stockNum = [self.stockTextField.text integerValue];
    stockNum ++;
    self.stockTextField.text = [NSString stringWithFormat:@"%ld",stockNum];
    [self valueChanged:self.stockTextField];
}

- (void)subtractStockAction:(UIButton *)sender {
    stockNum = [self.stockTextField.text integerValue];
    stockNum --;
    self.stockTextField.text = [NSString stringWithFormat:@"%ld",stockNum];
    [self valueChanged:self.stockTextField];
}

- (void)valueChanged:(UITextField *)textField {
    stockNum = [self.stockTextField.text integerValue];
    if (stockNum >= 99999) {
        stockNum = 99999;
        self.stockTextField.text = [NSString stringWithFormat:@"%ld",stockNum];
        [self.addBtn setImage:[UIImage imageNamed:@"addGrey"] forState:UIControlStateNormal];
        self.addBtn.enabled = NO;
        return;
    }
    if (stockNum <= 0) {
        [self.subtractBtn setImage:[UIImage imageNamed:@"subtractGrey"] forState:UIControlStateNormal];
        self.subtractBtn.enabled = NO;
    } else {
        [self.subtractBtn setImage:[UIImage imageNamed:@"subtractRed"] forState:UIControlStateNormal];
        [self.addBtn setImage:[UIImage imageNamed:@"addRed"] forState:UIControlStateNormal];
        self.subtractBtn.enabled = YES;
        self.addBtn.enabled = YES;
    }
    if (self.stockTextField.text.length == 0) {
        self.stockTextField.text = @"0";
    }
    _changeStockBlock(self.stockTextField.text);
}

- (void)initMasonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 15));
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.subtractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stockTextField.mas_left);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.stockTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addBtn.mas_left);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(65, 35));
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

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setImage:[UIImage imageNamed:@"addRed"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addStockAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)subtractBtn {
    if (!_subtractBtn) {
        _subtractBtn = [[UIButton alloc] init];
        [_subtractBtn setImage:[UIImage imageNamed:@"subtractRed"] forState:UIControlStateNormal];
        [_subtractBtn addTarget:self action:@selector(subtractStockAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subtractBtn;
}

- (UITextField *)stockTextField {
    if (!_stockTextField) {
        _stockTextField = [[UITextField alloc] init];
        _stockTextField.backgroundColor = [JYConfig JYColorWithHexadecimal:kColorMainBackground];
        _stockTextField.textAlignment = NSTextAlignmentCenter;
        _stockTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_stockTextField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        _stockTextField.text = [NSString stringWithFormat:@"%ld",stockNum];
    }
    return _stockTextField;
}

@end
