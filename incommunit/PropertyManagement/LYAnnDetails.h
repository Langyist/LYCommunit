//
//  LYAnnouncementDetails.h
//  in_community
//
//  Created by LANGYI on 14-10-11.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYAnnDetails : UIViewController
{
    UIImageView *m_iamgeview;
    UILabel * m_titleLabel;
    UILabel * m_infoLabel;
    UILabel * m_timeLabel;
    
    NSDictionary *detailDataDictorynary;
}
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property(nonatomic,retain)IBOutlet UIImageView *m_iamgeview;
@property(nonatomic,retain)IBOutlet UILabel * m_titleLabel;
@property(nonatomic,retain)IBOutlet UILabel * m_infoLabel;
@property(nonatomic,retain)IBOutlet UILabel * m_timeLabel;

-(void)setDetailData:(NSDictionary*)dic;

@end
