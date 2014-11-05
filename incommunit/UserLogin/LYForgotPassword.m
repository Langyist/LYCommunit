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
- (void)Getverificationcode:(NSString *)url
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *URl = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/validate_code?phone=%@&type=mod",URl,MobilenumberText.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *getcodeDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",getcodeDic);
    if (![[getcodeDic objectForKey:@"status"] isEqual:@"201"]) {
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:[getcodeDic objectForKey:@"message"]
                                                       delegate:self
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
    }
    NSString *codeString = [getcodeDic objectForKey:@"data"];
    NSLog(@"%@",codeString);
    self.CodeText.text = codeString;
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
        if (!(CodeText.text.length == 6)) {
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
    if (textField == MobilenumberText && range.length == 0) {
        if (![self isPureInt:string]) {
            ret = NO;
        }
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
        
        NSLog(@"手机号:%@",self.MobilenumberText.text);
        [self Getverificationcode:@""];
    }
}

//提交
- (IBAction)done:(id)sender {
    
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *URl = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/change_pwd?phone=%@&password=%@&validateCode=%@",URl,MobilenumberText.text,passwordText.text,CodeText.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *getcodeDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",getcodeDic);
    NSString *message = [getcodeDic objectForKey:@"message"];
    NSLog(@"%@",message);
    if (![[getcodeDic objectForKey:@"status"] isEqual:@"201"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:[getcodeDic objectForKey:@"message"]
                                                       delegate:self
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
    }
    
    
}

@end
