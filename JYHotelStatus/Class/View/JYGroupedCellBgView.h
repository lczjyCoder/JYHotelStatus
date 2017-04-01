//
//  EBKGroupedCellBgView.h
//  Lvmm
//
//  Created by zjy on 16/8/19.
//  Copyright © 2016年 personal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, GroupedCellStyle) {
    GroupedCellStyle_None,
    GroupedCellStyle_Top,
    GroupedCellStyle_Middle,
    GroupedCellStyle_Bottom,
    GroupedCellStyle_Single
};

@interface JYGroupedCellBgView : UIView {
    GroupedCellStyle _groupedCellStyle;
    BOOL _needArrow;
    BOOL _isSelected;
    BOOL _isPlain;
}

- (id)initWithFrame:(CGRect)frame withDataSourceCount:(NSUInteger)count withIndex:(NSInteger)index isPlain:(BOOL)isPlain needArrow:(BOOL)needArrow isSelected:(BOOL)isSelected;
+ (GroupedCellStyle)checkCellStyle:(NSUInteger)count index:(NSInteger)index;

@end
