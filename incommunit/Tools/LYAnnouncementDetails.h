//
//  LYAnnouncementDetailsViewController.h
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AsyncDownload.h"
@interface LYAnnouncementDetails: UIViewController
{
    @public NSDictionary *m_announMessage;//公告详情
    UIImageView *m_image;
}
@property(nonatomic,retain)IBOutlet UIImageView *m_image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@end
