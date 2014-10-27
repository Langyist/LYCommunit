//
//  LYForgotPassword.h
//  incommunit
//  找回密码界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LYForgotPassword :UIViewController<UITextFieldDelegate>
{
    UITextField *MobilenumberText;
    UITextField *CodeText;
    UITextField *passwordText;
    UIButton *codeButton;
    UIButton *submitButton;
}
@property(nonatomic,retain)IBOutlet UITextField *MobilenumberText;
@property(nonatomic,retain)IBOutlet UITextField *CodeText;
@property(nonatomic,retain)IBOutlet UITextField *passwordText;
@property(nonatomic,retain)IBOutlet UIButton *codeButton;
@property(nonatomic,retain)IBOutlet UIButton *submitButton;
@end
