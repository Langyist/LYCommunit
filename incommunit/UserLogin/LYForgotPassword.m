//
//  LYForgotPassword.m
//  incommunit
//  找回密码界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYForgotPassword.h"
@interface LYForgotPassword ()

@end

@implementation LYForgotPassword
@synthesize MobilenumberText,CodeText,codeButton,passwordText,submitButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 25, 0, 25);
    [MobilenumberText setTextInset:inset];
    [CodeText setTextInset:inset];
    [passwordText setTextInset:inset];
    
    [codeButton.layer setMasksToBounds:YES];
    [codeButton.layer setCornerRadius:3.0];
    
    [submitButton.layer setMasksToBounds:YES];
    [submitButton.layer setCornerRadius:3.0];
    
    self.MobilenumberText.keyboardType = UIKeyboardTypeNamePhonePad;
    self.MobilenumberText.delegate = self;
    
    self.navigationController.navigationBar.hidden = NO;
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0]];
    //[customLab setText:@"忘记密码"];
    [customLab setText:@"找回密码"];
    customLab.font = [UIFont boldSystemFontOfSize:17];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;;
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0];
    
    self.CodeText.keyboardType = UIKeyboardTypeNamePhonePad;
    self.CodeText.delegate = self;
    self.passwordText.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取验证码
- (IBAction)verificationcodeButton:(id)sender {
    
    [self.MobilenumberText resignFirstResponder];
    [self.CodeText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    if ([self.MobilenumberText.text  isEqual:@""] || [self.MobilenumberText.text isEqual:nil]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"手机号码不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    //    else if (!(self.MobilenumberText.text.length == 11)){
    //
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
    //                                                        message:@"请输入正确的手机号码"
    //                                                       delegate:self
    //                                              cancelButtonTitle:@"确定"
    //                                              otherButtonTitles:nil, nil];
    //        [alert show];
    //    }
    else {
        
        NSLog(@"手机号:%@",self.MobilenumberText.text);
        [self Getverificationcode:@""];
    }
}

#pragma mark - 访问网络数据
//获取验证码
- (void)Getverificationcode:(NSString *)url
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *URl = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/validate_code?phone=%@&type=mod",URl,self.MobilenumberText.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *getcodeDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",getcodeDic);
    NSString *codeString = [getcodeDic objectForKey:@"data"];
    NSLog(@"%@",codeString);
    self.CodeText.text = codeString;
}

//提交
- (IBAction)SubmitButton:(id)sender {
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *URl = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/change_pwd?phone=%@&password=%@&validateCode=%@",URl,self.MobilenumberText.text,self.passwordText.text,self.CodeText.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *getcodeDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",getcodeDic);
    NSString *message = [getcodeDic objectForKey:@"message"];
    NSLog(@"%@",message);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resignkeyboardButton:(id)sender {
    [self.MobilenumberText resignFirstResponder];
    [self.CodeText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

#pragma mark UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.MobilenumberText) {
        
        [self.MobilenumberText resignFirstResponder];
        [self.passwordText becomeFirstResponder];
    }
    else if (textField == self.passwordText) {
        if ((self.passwordText.text.length < 6)|| (self.passwordText.text.length >12)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请输入6-12位新密码"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }else {
            
            NSLog(@"%@",self.passwordText.text);
            [self.CodeText becomeFirstResponder];
        }
        [self.passwordText resignFirstResponder];
    }else if (textField == self.CodeText) {
        if (!(self.CodeText.text.length == 6)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请输入六位验证码"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }else {
            
            NSLog(@"%@",self.CodeText.text);
        }
        [self.CodeText resignFirstResponder];
    }
    
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

@end
