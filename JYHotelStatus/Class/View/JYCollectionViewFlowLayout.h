//
//  EBKCollectionViewFlowLayout.h
//  Lvmm
//
//  Created by zjy on 2017/3/21.
//  Copyright © 2017年 Lvmama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYCollectionViewFlowLayout : UICollectionViewFlowLayout
/**  一行中 cell 的个数 */
@property (nonatomic,assign) NSUInteger itemCountPerRow;
/**  一页显示多少行 */
@property (nonatomic,assign) NSUInteger rowCount;
@end
