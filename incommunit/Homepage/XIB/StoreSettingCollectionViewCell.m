//
//  StoreSettingCollectionViewCell.m
//  incommunit
//
//  Created by 李忠良 on 14/11/7.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "StoreSettingCollectionViewCell.h"

@interface StoreSettingCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation StoreSettingCollectionViewCell {
    DeletePressBlock block;
}

- (void)awakeFromNib {
    // Initialization code
    
    [self.button setExclusiveTouch:YES];
}

- (IBAction)deleteButton:(id)sender {
    if (block) {
        block(self);
    }
}

- (void)setDeleteBlock:(DeletePressBlock)deletePressBlock {
    block = deletePressBlock;
}

@end
