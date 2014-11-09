//
//  LYSignup.m
//  incommunit
//  注册界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#import "LYSignup.h"
#import "LYaddCommunit.h"
#import "StoreOnlineNetworkEngine.h"
@interface LYSignup ()
@end

@implementation LYSignup
@synthesize m_Phone,m_VerificationText,m_password,m_NetButton,m_RButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 25, 0, 25);
    [m_Phone setTextInset:inset];
    [m_VerificationText setTextInset:inset];
    [m_password setTextInset:inset];
    m_dTime = 60;
    [m_NetButton.layer setMasksToBounds:YES];
    [m_NetButton.layer setCornerRadius:3.0];
    [m_RButton.layer setMasksToBounds:YES];
    [m_RButton.layer setCornerRadius:3.0];
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickView)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0]];
    [customLab setText:@"注册"];
    customLab.font = [UIFont boldSystemFontOfSize:17];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;
    self.navigationController.navigationBar.hidden = NO;
    m_Phone.delegate = self;
    m_VerificationText.delegate = self;
    m_password.delegate = self;
}
-(void)ClickView
{
    [m_VerificationText resignFirstResponder];
    [m_Phone resignFirstResponder];
    [m_password resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//下一步button
-(IBAction)Signup:(id)sender
{
    if (m_password.text == nil || [m_password.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"请输入密码"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
    }else if (m_VerificationText.text == nil || [m_VerificationText.text isEqual:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"请输入验证码"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
    }
    else
    {
        [self GetRegistration];
    }
}
//获取验证码
-(IBAction)GetRcode:(id)sender
{
    if (m_Phone.text == nil || [m_Phone.text isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"手机号码不能为空"
                                                       delegate:self
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
    }else {
        [self GetRegistrationCode:@""];
    }
}

#pragma mark - 访问网络数据
//获取注册码
-(BOOL)GetRegistrationCode:(NSString *)url
{
    bc = FALSE;
    m_dTime = 60;
    [m_timer invalidate];
    //    加载一个NSURL对象
    NSDictionary *dic = @{@"phone" : m_Phone.text
                          ,@"type" : @"add"};
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
                                                               m_timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Countdowntime) userInfo:nil repeats:YES];
                                                               m_VerificationCode =result;
                                                               bc = TRUE;
                                                           }
                                                       }];
    [m_timer setFireDate:[NSDate distantPast]];
    return bc;
}

-(void)Countdowntime
{
    if (m_dTime<=0)
    {
        [m_timer invalidate];
        [UIView setAnimationsEnabled:NO];
        [m_RButton setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        [m_RButton layoutIfNeeded];
        [UIView setAnimationsEnabled:YES];
    }else
    {
        m_dTime --;
        [UIView setAnimationsEnabled:NO];
        [m_RButton setTitle:[NSString stringWithFormat:@"%d秒", m_dTime] forState:UIControlStateNormal];
        [m_RButton layoutIfNeeded];
        [UIView setAnimationsEnabled:YES];
    }
}
//进行注册
-(void)GetRegistration
{
    NSDictionary *dic = @{@"phone" : m_Phone.text
                          ,@"password" : m_password.text
                          ,@"validateCode" : m_VerificationText.text};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/reg"
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
                                                               userID =result;
                                                               [self performSegueWithIdentifier:@"GoLYaddCommunit" sender:self];
                                                           }
                                                       }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark UITextField delegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == m_Phone) {
        [m_Phone resignFirstResponder];
        [m_password becomeFirstResponder];
    }else if (textField == m_password) {
        [m_password resignFirstResponder];
        [m_VerificationText becomeFirstResponder];
    }else if (textField == m_VerificationText) {
        
        [m_VerificationText resignFirstResponder];
    }
    return YES;
}

//开始编辑输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==m_VerificationText) {
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
    if (textField==m_VerificationText)
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL ret = YES;
    if (textField == m_Phone &&  range.length == 0) {
        if (![self isPureInt:string]) {
            ret = NO;
        }
        if (m_Phone.text.length >= 11)
            ret = NO;
    }else if (textField == m_password && range.length == 0) {
        
        if (m_password.text.length >= 12)
            ret = NO;
    }
    return ret;

}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        if ([segue.identifier isEqualToString: @"GoLYaddCommunit"])
        {
            LYaddCommunit *detailViewController = (LYaddCommunit*) segue.destinationViewController;
            detailViewController->userID = userID;
        }
    
}
@end
