//
//  LYNumbersense.m
//  in_community
//  小区号码通
//  Created by LANGYI on 14-10-17.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYNumbersense.h"
#import "LYSelectCommunity.h"

@interface LYNumbersense ()

@end

@implementation LYNumbersense

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
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0]];
    [customLab setText:@"小区号码通"];
    customLab.font = [UIFont boldSystemFontOfSize:17];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;
    self.m_tabeView.delegate = self;
    self.m_tabeView.dataSource = self;
    [self getNumbersense:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        
        return 3;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"administrativeCell"];
        return cell;
    }else if (indexPath.section == 1) {
        
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"personalCell"];
        return cell;
    }else {
        
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"行政";
    }else if (section == 1) {
        
        return @"个人";
    }else {
        
        return nil;
    }
}

#pragma mark 网络请求数据
- (void)getNumbersense:(NSString *)url {
    
    NSError *error;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"http://115.29.244.142/inCommunity/services/community/contact_list/community_id=%@",[[LYSelectCommunity GetCommunityInfo] objectForKey:@"id"]];
    //    加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"%@",weatherDic);
}

@end
