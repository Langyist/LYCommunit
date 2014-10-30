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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.statusLabel.transform = CGAffineTransformMakeRotation(M_PI/4);
}

@end
