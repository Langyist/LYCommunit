//
//  LYProductinformation.m
//  incommunit
//
//  Created by LANGYI on 14/10/29.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYProductinformation.h"

@interface LYProductinformation ()

@end

@implementation LYProductinformation
@synthesize m_iamgeview,m_GoodsName,m_Introduction,m_Price,m_textField;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self GetProductDetails:@""];
    if(m_ProductDetails!=nil)
    {
    m_GoodsName.text = [m_ProductDetails objectForKey:@"name"];
    m_Price.text = [[NSString alloc]initWithFormat:@"￥%@.00",[m_ProductDetails objectForKey:@"price"]];
    m_Introduction.text = [m_ProductDetails objectForKey:@"description"];
    m_Introduction.editable =NO;
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickView)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    }
    // Do any additional setup after loading the view.
}
-(void)ClickView
{
    [m_textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//返回
-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"移除");}];
}

#pragma mark - 获取网络数据
-(IBAction)GetProductDetails:(NSString *)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/shop/commodity_detail?id=%@",url,m_GoodsID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(response!=nil)
    {
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSString *status = [weatherDic objectForKey:@"status"];
    NSLog(@"%@",status);
    //    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:status delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [aler show];
    m_ProductDetails = [weatherDic objectForKey:@"data"];
    //m_Goodslist = [m_storesinfo objectForKey:@"commodities"];
    }
}

-(IBAction)SetChan:(NSString *)URL
{
    if ([[[NSString alloc]initWithFormat:@"%@",[m_ProductDetails objectForKey:@"isLike"]]isEqual:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你已经赞过该商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消赞", nil];
        [alert show];
    }else
    {
        NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
        NSLog(@"plistDic = %@",plistDic);
        NSString *url = [plistDic objectForKey: @"URL"];
        NSError *error;
        //    加载一个NSURL对象
        NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/shop/commodity_like?id=%@",url,m_GoodsID];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
        //    将请求的url数据放到NSData对象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (response!=nil)
        {
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
            NSString *status = [weatherDic objectForKey:@"status"];
            if (![[weatherDic objectForKey:@"status"]isEqual:@"200"]) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            NSLog(@"%@",status);
            //    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:status delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            //    [aler show];
            m_ProductDetails = [weatherDic objectForKey:@"data"];

        }
        //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
            }
}

-(IBAction)add:(id)sender
{
    m_textField.text = [[NSString alloc]initWithFormat:@"%d",[m_textField.text intValue]+1];
}

-(IBAction)Less:(id)sender
{
    if([m_textField.text intValue]>0)
    {
        m_textField.text = [[NSString alloc]initWithFormat:@"%d",[m_textField.text intValue]-1];
    }
}
@end
