//
//  LY_MaintenanceCell.m
//  in_community
//
//  Created by LangYi on 14-10-9.
//  Copyright (c) 2014年 LangYi. All rights reserved.
//

#import "LY_MaintenanceCell.h"

@implementation LY_MaintenanceCell

- (void)awakeFromNib {
    // Initialization code
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.frame) / 2;
    self.avatarImageView.clipsToBounds = YES;
}

@end
