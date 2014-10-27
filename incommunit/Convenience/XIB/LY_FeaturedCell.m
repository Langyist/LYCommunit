//
//  LY_FeaturedCell.m
//  in_community
//
//  Created by wangliang on 14-9-20.
//  Copyright (c) 2014年 wangliang. All rights reserved.
//

#import "LY_FeaturedCell.h"

@implementation LY_FeaturedCell
@synthesize m_iamge,m_imageview;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setImage:(UIImage *)img {
    if (![img isEqual:m_iamge]) {
        m_iamge = [img copy];
        self.m_imageview.image = m_iamge;
    }
}
@end
