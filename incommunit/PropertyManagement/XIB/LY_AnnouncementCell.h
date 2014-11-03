//
//  LY_AnnouncementCell.h
//  in_community
//
//  Created by LangYi on 14-10-8.
//  Copyright (c) 2014年 LangYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LY_AnnouncementCell : UITableViewCell
{
     IBOutlet UIImageView *m_imageview;
     IBOutlet UILabel *lable1;
     IBOutlet UILabel *lable2;
     IBOutlet UILabel *lable3;
}
@property (strong, nonatomic) IBOutlet UIImageView *m_imageview;
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic) IBOutlet UILabel *lable3;
@property(copy, nonatomic) UIImage *m_iamge;

- (void)setTextContent:(NSString *)text;
- (void)setTimestamp:(NSString *)timestamp;

@end
