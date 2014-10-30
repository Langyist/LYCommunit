//
//  LY_AnnouncementCell.m
//  in_community
//
//  Created by LangYi on 14-10-8.
//  Copyright (c) 2014年 LangYi. All rights reserved.
//

#import "LY_AnnouncementCell.h"
@implementation LY_AnnouncementCell
@synthesize lable1,lable2,lable3,m_imageview,m_iamge,label4;
- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.label4.transform = CGAffineTransformMakeRotation(M_PI/-4);
}
- (void)setImage:(UIImage *)img
{
    if (![img isEqual:m_iamge]) {
        m_iamge = [img copy];
        self.m_imageview.image = m_iamge;
    }
}
@end
