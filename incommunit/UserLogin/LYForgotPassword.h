//
//  LYForgotPassword.h
//  incommunit
//  找回密码界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetTextField.h"
@interface LYForgotPassword :UIViewController<UITextFieldDelegate>
{
    InsetTextField *MobilenumberText;
    InsetTextField *CodeText;
    InsetTextField *passwordText;
    UIButton *codeButton;
    UIButton *submitButton;
    int m_dTime;
    NSTimer *m_timer;
}

@property(nonatomic,retain)IBOutlet InsetTextField *MobilenumberText;
@property(nonatomic,retain)IBOutlet InsetTextField *CodeText;
@property(nonatomic,retain)IBOutlet InsetTextField *passwordText;
@property(nonatomic,retain)IBOutlet UIButton *codeButton;
@property(nonatomic,retain)IBOutlet UIButton *submitButton;
@end
