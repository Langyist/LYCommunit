//
//  LYSignup.h
//  incommunit
//   注册界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetTextField.h"

@interface LYSignup : UIViewController<UITextFieldDelegate>
{
    InsetTextField * m_Phone;
    InsetTextField *m_VerificationText;
    InsetTextField *m_password;
    NSString *m_VerificationCode;
    @public BOOL bcbool ;
    UIButton * m_NetButton;
    UIButton * m_RButton;
    int m_dTime;
    NSTimer *m_timer;
    NSString *userID;
    BOOL bc;//注册发送是否成功
}
@property(nonatomic,retain)IBOutlet InsetTextField *m_Phone;
@property(nonatomic,retain)IBOutlet InsetTextField *m_VerificationText;
@property(nonatomic,retain)IBOutlet InsetTextField *m_password;
@property(nonatomic,retain)IBOutlet UIButton * m_NetButton;
@property(nonatomic,retain)IBOutlet UIButton * m_RButton;
@end
