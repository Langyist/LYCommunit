//
//  LY_ACCell1.m
//  in_community
//
//  Created by LangYi on 14-10-9.
//  Copyright (c) 2014年 LangYi. All rights reserved.
//

#import "LY_ACCell1.h"
#import <QuartzCore/QuartzCore.h>

@implementation LY_ACCell1
@synthesize m_iamge,m_imageView,m_imageRq;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setImage:(UIImage *)img {
    if (![img isEqual:m_iamge]) {
        m_iamge = [img copy];
        self.m_imageView.image = m_iamge;
        m_iamge = [UIImage imageNamed:@"物业管理"];
        self.m_imageView.layer.cornerRadius = m_imageView.frame.size.width / 2;
        self.m_imageView.layer.masksToBounds = YES;
    }
}

@end
