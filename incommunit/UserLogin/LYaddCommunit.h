//
//  LYaddCommunit.h
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMComBoxView.h"
@interface LYaddCommunit : UIViewController<LMComBoxViewDelegate>
{
    UILabel *m_lableinfo;
    UITextField *m_Nickname;
    UIImageView *m_iamgeview;
    UIButton *m_button;
}
@property(nonatomic,retain)IBOutlet UILabel *m_lableinfo;
@property(nonatomic,retain)IBOutlet UITextField *m_Nickname;
@property(nonatomic,retain)IBOutlet UIImageView *m_iamgeview;
@property(nonatomic,retain)IBOutlet UIButton *m_button;
@end
