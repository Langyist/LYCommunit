//
//  LYMyCommunit.h
//  incommunit
//  我的小区界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LYMyCommunit : UIViewController
{
    UIView *m_view;
}
@property (strong, nonatomic) IBOutlet UILabel *communitNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *PercentLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UIButton *m_button;
@property(nonatomic,retain)IBOutlet UIView *m_view;
@end
