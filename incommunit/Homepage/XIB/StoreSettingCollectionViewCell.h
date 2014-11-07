//
//  StoreSettingCollectionViewCell.h
//  incommunit
//
//  Created by 李忠良 on 14/11/7.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreSettingCollectionViewCell;

typedef void (^DeletePressBlock)(StoreSettingCollectionViewCell *cell);

@interface StoreSettingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *textLabel;
- (void)setDeleteBlock:(DeletePressBlock)deletePressBlock;

@end
