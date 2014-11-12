//
//  LYForgotPassword.m
//  incommunit
//  找回密码界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYForgotPassword.h"
#import "StoreOnlineNetworkEngine.h"
#import "LYSqllite.h"
#import "LYSelectCommunit.h"

@interface LYForgotPassword ()

@end

@implementation LYForgotPassword
@synthesize MobilenumberText,CodeText,codeButton,passwordText,submitButton;
- (void)viewDidLoad
{
    [super viewDidLoad];
    m_dTime = 60;
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 25, 0, 25);
    [MobilenumberText setTextInset:inset];
    [CodeText setTextInset:inset];
    [passwordText setTextInset:inset];
    [codeButton.layer setMasksToBounds:YES];
    [codeButton.layer setCornerRadius:3.0];
    [submitButton.layer setMasksToBounds:YES];
    [submitButton.layer setCornerRadius:3.0];
    self.MobilenumberText.delegate = self;
    self.navigationController.navigationBar.hidden = NO;
    self.CodeText.delegate = self;
    self.passwordText.delegate = self;
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downkeyboardGesture)];
    [self.view addGestureRecognizer:tapgesture];
}
//点击空白关闭键盘
- (void)downkeyboardGesture
{
    [self.MobilenumberText resignFirstResponder];
    [self.CodeText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 访问网络数据
//获取验证码
- (void)Getverificationcode
{
    [m_timer invalidate];
    m_dTime = 60;
    
    NSDictionary *dic = @{@"phone" : MobilenumberText.text
                          ,@"type" : @"mod"};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/validate_code"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                               [alview show];
                                                           }else
                                                           {
                                                               m_timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Countdown) userInfo:nil repeats:YES];
                                                           }
                                                       }];

}

#pragma mark UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.MobilenumberText) {
        [MobilenumberText resignFirstResponder];
        [passwordText becomeFirstResponder];
    }
    else if (textField == passwordText) {
        if ((passwordText.text.length < 6)|| (passwordText.text.length >12)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请输入6-12位新密码"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }else {
            
            NSLog(@"%@",self.passwordText.text);
            [CodeText becomeFirstResponder];
        }
        [passwordText resignFirstResponder];
    }else if (textField == CodeText) {
        if (!(CodeText.text.length == 4)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请输入4位验证码"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }else {
            
            NSLog(@"%@",self.CodeText.text);
        }
        [CodeText resignFirstResponder];
    }
    
    return YES;
}

-(void)Countdown
{
    if (m_dTime<=0)
    {
        [m_timer invalidate];
        [codeButton setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
    }else
    {
        m_dTime --;
        [UIView setAnimationsEnabled:NO];
        [codeButton setTitle:[NSString stringWithFormat:@"%d秒", m_dTime] forState:UIControlStateNormal];
        [codeButton layoutIfNeeded];
        [UIView setAnimationsEnabled:YES];
    }
}

//开始编辑输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==CodeText) {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y -=50;
        //frame.size.height +=60;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView commitAnimations];
    }
}
//结束编辑输入框
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==CodeText)
    {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y +=50;
        //frame.size.height -=60;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}
//限制输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL ret = YES;
    if (textField == MobilenumberText &&  range.length == 0) {
        if (![self isPureInt:string]) {
            ret = NO;
        }
        if (MobilenumberText.text.length >= 11)
            ret = NO;
    }else if (textField == passwordText && range.length == 0) {
        
        if (passwordText.text.length >= 12)
            ret = NO;
    }
    return ret;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
//获取验证码
- (IBAction)GetVerifyCode:(id)sender {
    
    [MobilenumberText resignFirstResponder];
    [CodeText resignFirstResponder];
    [passwordText resignFirstResponder];
    if ([MobilenumberText.text isEqual:@""] || [MobilenumberText.text isEqual:nil]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"手机号码不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        [self Getverificationcode];
    }
}

//提交找回密码信息
- (IBAction)done:(id)sender
{
    if([MobilenumberText.text isEqualToString:@""]||[passwordText.text isEqualToString:@""]||[CodeText.text isEqualToString:@""])
    {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"请先获取验证码"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alview show];
    }else
        
    {
        NSDictionary *dic = @{@"phone" : MobilenumberText.text
                              ,@"password" : passwordText.text
                              ,@"validateCode" : CodeText.text};
        [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/change_pwd"
                                                                params:dic
                                                                repeat:YES
                                                                 isGet:YES
                                                           resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                               if(!bValidJSON)
                                                               {
                                                                   UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                                   [alview show];
                                                               }
                                                               else
                                                               {
                                                                   [self login];
                                                               }
                                                           }];
        }
}

- (void)login {
    
    // 获取小区信息
    NSDictionary *communitInfo = [LYSelectCommunit GetCommunityInfo];
    
    // 初始化用户信息
    NSString *username = [MobilenumberText.text length] ? MobilenumberText.text : @"";
    NSString *password = [passwordText.text length] ? passwordText.text : @"";
    NSMutableDictionary *userinfo= [[NSMutableDictionary alloc] init];
    [userinfo setValue:username forKey:@"user"];
    [userinfo setValue:password forKey:@"password"];
    [userinfo setValue:[communitInfo objectForKey:@"id"] forKey:@"community_id"];
    [userinfo setValue:[communitInfo objectForKey:@"name"] forKey:@"communitname"];
    [userinfo setValue:[communitInfo objectForKey:@"address"] forKey:@"communitaddress"];
    [userinfo setValue:[communitInfo objectForKey:@"distance"] forKey:@"communitdistance"];
    [userinfo setValue:[communitInfo objectForKey:@"max_level"] forKey:@"communitmax_level"];
    
    // 登录结果处理
    AnalyzeResponseResult result = ^(BOOL bValidJSON, NSString *errorMsg, id result) {
        if(!bValidJSON) {
            UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alview show];
        }
        else {
            [userinfo setValue:[result objectForKey:@"auth_status"] forKey:@"auth_status"];
            [LYSqllite  wuser:userinfo];
            BOOL isMember = YES;
            if ([[userinfo objectForKey:@"auth_stauts"] isEqualToString:@"-1"]) {
                isMember = NO;
            }
            if (isMember) {
                [self performSegueWithIdentifier:@"GoLYFunctionInterface" sender:self];
            }
            else {
                [self performSegueWithIdentifier:@"GoLYaddCommunit" sender:self];
            }
        }
    };
    
    // 登录请求
    NSString *communityID = [[communitInfo objectForKey:@"id"] length] ? [communitInfo objectForKey:@"id"] : @"";
    NSDictionary *loginInfo = @{
                                @"username" : username
                                ,@"password" : password
                                ,@"community_id" : communityID
                                };
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/login"
                                                            params:loginInfo
                                                            repeat:YES
                                                             isGet:NO
                                                          activity:YES
                                                       resultBlock:result];
}

@end
