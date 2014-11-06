//
//  LYAbout.m
//  in_community
//  关于
//  Created by LANGYI on 14-10-20.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYAbout.h"

@interface LYAbout () {
    
    UIAlertView *updatealert;
    UIAlertView *dialalert;
    
    UIWebView *phoneCallWebView;
}

@end

@implementation LYAbout
@synthesize m_tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.scrollEnabled = NO;
    
    [self getAboutinfo:@""];
}

#pragma mark UITableView delegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *array = [NSArray arrayWithObjects:@"版本更新",@"欢迎页",@"客服热线", nil];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 30)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = array[indexPath.row];
    [cell addSubview:titleLabel];
    
    if (indexPath.row == 1) {
        cell.selectionStyle = UITableViewCellStateShowingEditControlMask;
    }else if (indexPath.row == 2) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 160, 30)];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"028-65260204";
        label.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:label];
    }
    
    return cell;
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        updatealert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定要更新到该版本？"
delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [updatealert show];
    }
    else if (indexPath.row == 1) {
        
    }
    else if (indexPath.row == 2) {
        
       [self CallPhone];
    }
}

//拨号
-(void)CallPhone{
    NSString *phoneNum = @"028-65260204";// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc]initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来 效果跟方法二一样 但是这个方法是合法的
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

//服务协议
- (IBAction)aboutButton:(id)sender {
    NSLog(@"小区帮帮软件许可及服务协议");
}

#pragma mark UIAlertView delegate
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == updatealert) {
        if (buttonIndex == 0) {
            
        }
    }
}

#pragma mark 数据
- (void)getAboutinfo:(NSString *)url {
    
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *strurl = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString *urlstr =[[NSString alloc] initWithFormat:@"%@/services/upgrade/info",strurl] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
    
    NSDictionary *data = [weatherDic objectForKey:@"data"];
    NSLog(@"%@",data);
}


@end
