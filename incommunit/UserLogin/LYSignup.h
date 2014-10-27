//
//  LYSignup.h
//  incommunit
//   注册界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSignup : UIViewController<UITextFieldDelegate>
{
    UITextField * m_Phone;
    UITextField *m_VerificationText;
    UITextField *m_password;
    NSString *m_VerificationCode;
    @public BOOL bcbool ;
    UIButton * m_NetButton;
    UIButton * m_RButton;
    int m_dTime;
    NSTimer *m_timer;
}
@property(nonatomic,retain)IBOutlet UITextField *m_Phone;
@property(nonatomic,retain)IBOutlet UITextField *m_VerificationText;
@property(nonatomic,retain)IBOutlet UITextField *m_password;
@property(nonatomic,retain)IBOutlet UIButton * m_NetButton;
@property(nonatomic,retain)IBOutlet UIButton * m_RButton;
@end
