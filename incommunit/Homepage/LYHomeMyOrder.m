//
//  LYMyOrder.m
//  in_community
//  我的订单
//  Created by wangliang on 14-10-22.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYHomeMyOrder.h"

@interface LYHomeMyOrder ()

@end

@implementation LYHomeMyOrder
@synthesize m_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    
    
//    [self getmyorder:@""];
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderCell"];
    
    [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 网络数据
- (void)getmyorder:(NSString *)URL {
    
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString *urlstr =[[NSString alloc] initWithFormat:@"%@/inCommunity/services/order/mylist",url] ;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",weatherDic);
}

@end
