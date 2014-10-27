//
//  LYAnnouncementDetailsViewController.m
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYAnnouncementDetails.h"

@interface LYAnnouncementDetails ()

@end

@implementation LYAnnouncementDetails
@synthesize m_image;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:[m_announMessage objectForKey:@"image_path"]];
    if (url!=nil&&![url isEqual:@""])
    {
        [m_image setImageWithURL:url placeholderImage:nil];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
