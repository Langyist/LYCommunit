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
#import "LYReachability.h"
#import "UIImage+Scale.h"
#import "LYFunctionInterface.h"
@interface LYUserloginView () {
    
    NSThread* myThread;
}
@end
@implementation LYUserloginView
@synthesize userText,passwordtext,login,m_Pview,m_iamgeview,m_communityName,m_loginbutton;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_communityName.userInteractionEnabled = YES;
    
    [m_loginbutton.layer setMasksToBounds:YES];
    [m_loginbutton.layer setCornerRadius:3.0];
    [self modify:userText imageName:@"ic_username" size:CGSizeMake(31, 32)];
    [self modify:passwordtext imageName:@"ic_password" size:CGSizeMake(29, 37)];
    userText.delegate=self;
    passwordtext.delegate=self;
    passwordtext.secureTextEntry = YES;
    [login setHidesWhenStopped:YES];
    m_communityName.text = community_Name;
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0]];
    [customLab setText:@"登陆"];
    customLab.font = [UIFont boldSystemFontOfSize:17];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;
    self.navigationController.navigationBar.hidden = YES;
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickView)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0];
    m_communityName.text = [[LYSelectCommunit GetCommunityInfo] objectForKey:@"name"];
    [LYSqllite CreatUserTable];
    if (!m_bool)
    {
        NSMutableDictionary* temp = [[NSMutableDictionary alloc] init];
        temp = [LYSqllite Ruser];
        if (temp!=nil)
        {
            if ([[[NSString alloc] initWithFormat:@"%@",[temp objectForKey:@"id"]] isEqual:[[NSString alloc] initWithFormat:@"%@",[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"]]] )
            {
                userText.text =[temp objectForKey:@"user"];
                passwordtext.text =[temp objectForKey:@"password"];
                [self login:[temp objectForKey:@"user"] password:[temp objectForKey:@"password"]];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)modify:(UITextField *)textFiled imageName:(NSString *)imageName size:(CGSize)iconSize {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textFiled.frame.size.height * 1.2, textFiled.frame.size.height)];
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [UIImage imageWithImage:image scaledToSize:CGSizeMake(iconSize.width / 2, iconSize.height / 2)];
    
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
//login 登陆函数
-(IBAction)login:(NSString*)user password:(NSString *)password
{
    [passwordtext resignFirstResponder];
    LYReachability *r = [LYReachability reachabilityWithHostName:@"www.baidu.com"];
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
    }
    else
    {
        myThread = [[NSThread alloc] initWithTarget:self selector:@selector(startlogin:) object:nil];
        [myThread start];
        userinfo = [[NSMutableDictionary alloc] init];
        if ([[LYSelectCommunit GetCommunityInfo] objectForKey:@"name"] ==nil||[[[LYSelectCommunit GetCommunityInfo] objectForKey:@"name"]isEqual:@"null"])
        {
            userinfo = [LYSqllite Ruser];
            [userinfo setValue:userText.text forKey:@"user"];
            [userinfo setValue:passwordtext.text forKey:@"password"];
        }else
        {
            [userinfo setValue:userText.text forKey:@"user"];
            [userinfo setValue:passwordtext.text forKey:@"password"];
            [userinfo setValue:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"] forKey:@"community_id"];
            [userinfo setValue:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"name"] forKey:@"communitname"];
            [userinfo setValue:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"address"] forKey:@"communitaddress"];
            [userinfo setValue:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"distance"] forKey:@"communitdistance"];
            [userinfo setValue:[[LYSelectCommunit GetCommunityInfo] objectForKey:@"max_level"] forKey:@"communitmax_level"];
        }
        
        
        
        NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
        NSLog(@"plistDic = %@",plistDic);
        NSString *urlstr = [plistDic objectForKey: @"URL"];
        NSString *Ustr = [[NSString alloc] initWithFormat:@"%@/services/login",urlstr];
        NSError *error;
        //    加载一个NSURL对象
        NSURL *url = [NSURL URLWithString:Ustr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = @"username=";//设置参数
        str = [str stringByAppendingFormat:@"%@&password=%@&community_id=%@", userText.text,passwordtext.text,[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"]];
        
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        //第三步，连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (received!=nil) {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
            if ([[weatherDic objectForKey:@"status"] isEqualToString:@"200"])
            {
                [LYSqllite  wuser:userinfo];
                [self performSegueWithIdentifier:@"GoLYFunctionInterface" sender:self];
            }else
            {
                UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:[weatherDic objectForKey:@"message"]
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
                [al show];
            }
            
        }else
        {
            UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"登陆失败"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
            [al show];
        }
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
        [self login:userText.text password:passwordtext.text];
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
    [LYSqllite  wuser:userinfo];
    [self performSegueWithIdentifier:@"GoLYFunctionInterface" sender:self];
}

- (IBAction)clickName:(id)sender {
    
    [self performSegueWithIdentifier:@"GoSelectConmunit" sender:nil];

}

@end

