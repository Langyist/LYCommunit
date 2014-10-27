//
//  LYSignup.m
//  incommunit
//  注册界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYSignup.h"
@interface LYSignup ()
@end

@implementation LYSignup
@synthesize m_Phone,m_VerificationText,m_password,m_NetButton,m_RButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0];
    // Do any additional setup after loading the view.
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

-(IBAction)Signup:(id)sender
{
    //if ([self GetRegistration:@""]) {
    [self performSegueWithIdentifier:@"GoMyCommunity" sender:self];
    //}
}

-(IBAction)GetRcode:(id)sender
{
    if (m_Phone.text!=nil&&![m_Phone.text isEqual:@""]) {
        [self GetRegistrationCode: @""];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - 访问网络数据
//获取注册码
-(BOOL)GetRegistrationCode:(NSString *)url
{
    
    m_timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Countdown) userInfo:nil repeats:YES];
    BOOL bc;
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *URL = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@services/validate_code?phone=%@&type=add",URL,m_Phone.text ];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSString *status = [weatherDic objectForKey:@"status"];
    if ([status isEqual:@"200"])
    {
        bc = TRUE;
    }else
    {
        NSLog(@"%@",status);
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        bc = FALSE;
    }
    m_VerificationCode = [weatherDic objectForKey:@"data"];
    m_VerificationText.text =m_VerificationCode;
    [m_timer setFireDate:[NSDate distantPast]];
    return bc;
}

-(void)Countdown
{
    if (m_dTime<0) {
        [m_timer invalidate];
    }
    m_dTime --;
    [m_RButton setTitle: [[NSString alloc] initWithFormat:@"%d",m_dTime] forState: UIControlStateNormal];
}
//进行注册
-(BOOL)GetRegistration:(NSString *)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    
    BOOL bac = false;
    if ([m_password.text isEqualToString: @""]&&[m_Phone isEqual: @""]&&[m_VerificationText isEqual:@""])
    {
        NSError *error;
        //    加载一个NSURL对象
        NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/reg?phone=%@&password=%@&validateCode=%@",url,m_Phone.text,m_password.text,m_VerificationText.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
        //    将请求的url数据放到NSData对象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
        NSString *status = [weatherDic objectForKey:@"status"];
        NSLog(@"%@",status);
        m_VerificationText.text =m_VerificationCode;
        if ([status isEqualToString:@"200"]) {
            bac = TRUE;
        }else
        {
            NSString *message = [weatherDic objectForKey:@"message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            bac = FALSE;
        }
    }else
    {
        UIAlertView *al= [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请填写注册信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        bac = FALSE;
    }
    return bac;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}
@end
