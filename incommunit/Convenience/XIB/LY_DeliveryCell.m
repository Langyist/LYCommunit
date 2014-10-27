//
//  LY_DeliveryCell.m
//  in_community
//
//  Created by wangliang on 14-9-21.
//  Copyright (c) 2014年 wangliang. All rights reserved.
//

#import "LY_DeliveryCell.h"

@implementation LY_DeliveryCell
@synthesize m_imageview,m_iamge,m_name,m_call_number,m_send_info,m_distance,m_sendable,m_hui;

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
