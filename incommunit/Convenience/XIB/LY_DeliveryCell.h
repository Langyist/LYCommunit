//
//  LY_DeliveryCell.h
//  in_community
//
//  Created by wangliang on 14-9-21.
//  Copyright (c) 2014年 wangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LY_DeliveryCell : UITableViewCell
{
    IBOutlet UIImageView *m_imageview;
    IBOutlet UILabel *m_name;
    IBOutlet UILabel *m_call_number;
    IBOutlet UILabel *m_send_info;
    IBOutlet UILabel *m_distance;
    IBOutlet UILabel *m_sendable;
    IBOutlet UILabel *m_hui;
}
@property (strong, nonatomic) IBOutlet UIImageView *m_imageview;
@property (strong, nonatomic) IBOutlet UILabel *m_name;
@property (strong, nonatomic) IBOutlet UILabel *m_call_number;
@property (strong, nonatomic) IBOutlet UILabel *m_send_info;
@property (strong, nonatomic) IBOutlet UILabel *m_distance;
@property (strong, nonatomic) IBOutlet UILabel *m_sendable;
@property (strong, nonatomic) IBOutlet UILabel *m_hui;
@property(copy, nonatomic) UIImage *m_iamge;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImage;

// new set data function
// 设置店名
- (void)setStoreName:(NSString *)name;
// 设置拨打次数
- (void)setCallNumber:(NSInteger)callNumber;
// 设置距离
- (void)setDistance:(NSInteger)meter;
@end
