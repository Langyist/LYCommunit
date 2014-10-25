//
//  LYUIview.m
//  incommunit
//
//  Created by LANGYI on 14/10/25.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYUIview.h"
@implementation LYUIview :UIView
//自定义提示
+ (UIView*)showProgressAlert:(UIView*)selfview sms:(NSString*)message
{
    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(50, selfview.bounds.size.height/2.0f, selfview.bounds.size.width-100, 70)];
    View.layer.cornerRadius = 8.0f;
    View.layer.masksToBounds = YES;
    View.backgroundColor = [UIColor colorWithRed:(238.0/255) green:(183.0/255) blue:(88.0/255) alpha:0.7];
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activeView.center = CGPointMake(View.bounds.size.width/2.0f-60, View.bounds.size.height/2.0f);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(View.bounds.size.height/2.0f+40, View.bounds.size.height/2.0f-15, View.bounds.size.width, 30)];
    titleLabel.text=message;
    [View addSubview:titleLabel];
    [activeView setColor:[UIColor whiteColor]];
    [activeView startAnimating];
    [View addSubview:activeView];
    [selfview addSubview:View];
    selfview.userInteractionEnabled = NO;
    return View;
}

@end
