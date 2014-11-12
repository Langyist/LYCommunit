//
//  LYUserloginView.m
//  incommunit
//  用户登陆界面
//  Created by LANGYI on 14/10/26.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#import "LYUserloginView.h"
#import"LYSqllite.h"
#import "LYSelectCommunit.h"
#import "Reachability.h"
#import "UIImage+Scale.h"
#import "LYFunctionInterface.h"
#import "StoreOnlineNetworkEngine.h"
@interface LYUserloginView () {
    
    NSThread* myThread;
}
@end
@implementation LYUserloginView
static BOOL YTourist;
@synthesize userText,passwordtext,login,m_Pview,m_iamgeview,m_communityName,m_loginbutton;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_communityName.userInteractionEnabled = YES;
    [m_loginbutton.layer setMasksToBounds:YES];
    [m_loginbutton.layer setCornerRadius:3.0];
    [self modify:userText imageName:@"用户" size:CGSizeMake(31, 32)];
    [self modify:passwordtext imageName:@"密码" size:CGSizeMake(29, 37)];
    userText.delegate=self;
    passwordtext.delegate=self;
    passwordtext.secureTextEntry = YES;
    [login setHidesWhenStopped:YES];
    m_communityName.text = community_Name;
    self.navigationController.navigationBar.hidden = YES;
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickView)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    if(USERinfo==nil)
    {
        m_communityName.text = [[LYSelectCommunit GetCommunityInfo] objectForKey:@"name"];
    }else
    {
        m_communityName.text = [USERinfo objectForKey:@"name"];
    }
    [LYSqllite CreatUserTable];
    }

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)modify:(UITextField *)textFiled imageName:(NSString *)imageName size:(CGSize)iconSize {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -1, textFiled.frame.size.height * 1.2, textFiled.frame.size.height)];
    
    UIImage *image = [UIImage imageNamed:imageName];
    //image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(iconSize.width / 2, iconSize.height / 2)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0.0, 0.0, iconSize.width / 2, iconSize.height / 2);
    imageView.center = CGPointMake(textFiled.frame.size.height / 2, textFiled.frame.size.height / 2);
    imageView.contentMode = UIViewContentModeCenter;
    //imageView.backgroundColor = [UIColor colorWithRed:86.0f / 255.0f green:190.0f / 255.0f blue:164.f / 255.0f alpha:1];
    [view addSubview:imageView];
    
    textFiled.leftView = view;
    textFiled.leftViewMode = UITextFieldViewModeAlways;
    
    //textFiled.layer.cornerRadius = 8.0f;
    //[textFiled setTextInset:UIEdgeInsetsMake(0, 5, 0, 3)];
    //textFiled.returnKeyType = UIReturnKeyDone;
}

-(void)ClickView
{
    [userText resignFirstResponder];
    [passwordtext resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"GoSelectConmunit"])
    {
        LYSelectCommunit *detailViewController = (LYSelectCommunit*) segue.destinationViewController;
        detailViewController->m_bl = TRUE;
    }
}
- (IBAction)login:(UIButton *)button
{
    [passwordtext resignFirstResponder];
    userinfo= [[NSMutableDictionary alloc] init];
    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    myThread = [[NSThread alloc] initWithTarget:self selector:@selector(startlogin:) object:nil];
    [myThread start];

    [userinfo setValue:userText.text forKey:@"user"];
    [userinfo setValue:passwordtext.text forKey:@"password"];
    [userinfo setValue:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"] forKey:@"community_id"];
    [userinfo setValue:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"name"] forKey:@"communitname"];
    [userinfo setValue:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"address"] forKey:@"communitaddress"];
    [userinfo setValue:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"distance"] forKey:@"communitdistance"];
    [userinfo setValue:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"max_level"] forKey:@"communitmax_level"];

    if ([userText.text isEqual:@""]||userText.text==nil) {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"用户不能为空"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [aler show];
        
    }else if ([passwordtext.text isEqual:@""]||passwordtext.text==nil)
    {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"密码不能为空"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
        [aler show];
    }else
    {
        [self login:userText.text password:passwordtext.text communitID:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"]];
    }
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示"
                                                          message:@"当前没有可用网络"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
            [alert show];
            [myThread cancel];
            [login stopAnimating];
            [login setHidesWhenStopped:YES];
            return;
        }
            break;
        case ReachableViaWWAN:
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示"
                                                          message:@"当前使用的是3G网络是否继续"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"继续", nil];
            [alert show];
        }
            // 使用3G网络
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            break;
    }
    [myThread cancel];
    [login stopAnimating];
    [login setHidesWhenStopped:YES];
}

//login 登陆函数
-(void)login:(NSString*)user password:(NSString *)password communitID:(NSString *)Communitid
{
        NSDictionary *dic = @{@"username" : user
                              ,@"password" : password
                              ,@"community_id" : Communitid};
        [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/login"
                                                                params:dic
                                                                repeat:YES
                                                                 isGet:NO
                                                              activity:YES
                                                           resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                               if(!bValidJSON)
                                                               {
                                                                   UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                                   [alview show];
                                                               }else
                                                               {
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
                                                           }];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CQ = @"^142\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestcq = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CQ];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestcq evaluateWithObject:mobileNum] == YES)) {
        return YES;
    }
    else {
        return NO;
    }
}

-(IBAction)startlogin:(id)sender
{
    [login setHidesWhenStopped:NO];
    [login startAnimating];
}
#pragma mark- UItextField 协议函数
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==userText)
    {
        [userText resignFirstResponder];
        [passwordtext becomeFirstResponder];
    }else if(textField==passwordtext)
    {
        [textField resignFirstResponder];
//         [self login:userText.text password:passwordtext.text];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL ret = YES;
    if (textField == userText && range.length == 0) {
        if (userText.text.length >= 20)
            ret = NO;
    }else if (textField == passwordtext && range.length == 0) {
        
        if (passwordtext.text.length >= 12)
            ret = NO;
    }
    return ret;
}

//开始编辑输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==userText) {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y -=60;
        //frame.size.height +=60;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView commitAnimations];
    }else if (textField==passwordtext)
    {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y -=100;
        //frame.size.height +=100;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView commitAnimations];
    }
}
//结束编辑输入框
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==userText)
    {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y +=60;
        //frame.size.height -=60;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }else if (textField == passwordtext)
    {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y +=100;
        //frame.size.height -=100;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

//返回上一个界面不刷新数据
-(IBAction)returnPage:(id)sender
{
    [self performSegueWithIdentifier:@"SelectCommunity" sender:self];
}

//忘记密码
- (IBAction)forgetPsdButton:(id)sender {
    [self performSegueWithIdentifier:@"GoLYForgotPassword" sender:self];
}

//游客登陆
-(IBAction)touristsButton:(id)sender
{
    userinfo= [[NSMutableDictionary alloc] init];
    [userinfo setValue:@"" forKey:@"user"];
    [userinfo setValue:@"" forKey:@"password"];
    [userinfo setValue:@"" forKey:@"community_id"];
    [userinfo setValue:@"" forKey:@"communitname"];
    [userinfo setValue:@"" forKey:@"communitaddress"];
    [userinfo setValue:@"" forKey:@"communitdistance"];
    [userinfo setValue:@"" forKey:@"communitmax_level"];
    [userinfo setValue:@"-2" forKey:@"auth_stauts"];
    [LYSqllite wuser:userinfo];
    YTourist = TRUE;
    [LYSqllite  wuser:userinfo];
    [self performSegueWithIdentifier:@"GoLYFunctionInterface" sender:self];
}

- (IBAction)clickName:(id)sender
{
    [self performSegueWithIdentifier:@"GoSelectConmunit" sender:nil];
}

+(BOOL )Getourist
{
    return YTourist;
}
@end

