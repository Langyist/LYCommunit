//
//  LYAnnouncementDetails.m
//  in_community
//
//  Created by LANGYI on 14-10-11.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYAnnouncementDetails.h"

@interface LYAnnouncementDetails ()

@end

@implementation LYAnnouncementDetails
@synthesize m_iamgeview,m_infoLabel,m_timeLabel,m_titleLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    m_titleLabel.text= [detailDataDictorynary objectForKey:@"name"];
    m_infoLabel.text = [detailDataDictorynary objectForKey:@"content"];
    m_timeLabel.text = [NSString stringWithFormat:@"%@",[detailDataDictorynary objectForKey:@"create_time"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDetailData:(NSDictionary*)dic
{
    detailDataDictorynary = dic;
}

@end
