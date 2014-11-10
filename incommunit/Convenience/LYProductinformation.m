//
//  LYProductinformation.m
//  incommunit
//  商品信息
//  Created by LANGYI on 14/10/29.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYProductinformation.h"
#import "CustomToolbarItem.h"
@interface LYProductinformation ()

@end

@implementation LYProductinformation
@synthesize m_iamgeview,m_GoodsName,m_Introduction,m_Price,m_textField,m_ProductDetails;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSThread *myThread01 = [[NSThread alloc] initWithTarget:self
                                         selector:@selector(GetProductDetails:)
                                           object:self];
    [myThread01 start];
    
    UIBarButtonItem *homePage = [self createCustomItem:@"首页" imageName:@"首页" selector:nil tag:100];
    UIBarButtonItem *persionalPage = [self createCustomItem:@"个人主页" imageName:@"2" selector:nil tag:101];
    UIBarButtonItem *shoppingCartPage = [self createCustomItem:@"购物车" imageName:@"购物车" selector:nil tag:102];
    UIBarButtonItem *orderPage = [self createCustomItem:@"我的订单" imageName:@"订单" selector:nil tag:103];
    NSArray *array = [NSArray arrayWithObjects:
                      [self createFixableItem:17]
                      ,homePage
                      ,[self createFixableItem:0]
                      ,persionalPage
                      ,[self createFixableItem:0]
                      ,shoppingCartPage
                      ,[self createFixableItem:0]
                      ,orderPage
                      ,[self createFixableItem:17]
                      ,nil];
    [self setToolbarItems:array animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES];
}

- (UIBarButtonItem *)createFixableItem:(NSInteger)width {
    UIBarButtonItem *item = nil;
    UIBarButtonSystemItem type = UIBarButtonSystemItemFlexibleSpace;
    if (width > 0) {
        type = UIBarButtonSystemItemFixedSpace;
    }
    item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:nil action:nil];
    item.width = width;
    return item;
}

- (UIBarButtonItem *)createCustomItem:(NSString *)title imageName:(NSString *)imageName selector:(SEL)selector tag:(NSInteger)tag {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"CustomToolbarItem" owner:self options:nil];
    CustomToolbarItem *customItem = [nibViews objectAtIndex:0];
    customItem.tag = tag;
    customItem.autoresizingMask = UIViewAutoresizingNone;
    [customItem setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [customItem setTitle:title forState:UIControlStateNormal];
    [customItem addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customItem];
    return item;
}

-(void)ClickView
{
    [m_textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - 获取网络数据
-(void)GetProductDetails:(LYProductinformation *)obj
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/shop/commodity_detail?id=%@",url,m_GoodsID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(response!=nil)
    {
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSString *status = [weatherDic objectForKey:@"status"];
        NSLog(@"%@",status);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self Updata:[weatherDic objectForKey:@"data"]];
        });
    }
}

-(IBAction)SetChan:(NSString *)URL
{
//    if ([[[NSString alloc]initWithFormat:@"%@",[m_ProductDetails objectForKey:@"isLike"]]isEqual:@"1"])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你已经赞过该商品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消赞", nil];
//        [alert show];
//    }else
//    {
//        NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
//        NSLog(@"plistDic = %@",plistDic);
//        NSString *url = [plistDic objectForKey: @"URL"];
//        NSError *error;
//        NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/shop/commodity_like?id=%@",url,m_GoodsID];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
//        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        if (response!=nil)
//        {
//            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//            NSString *status = [weatherDic objectForKey:@"status"];
//            if (![[weatherDic objectForKey:@"status"]isEqual:@"200"])
//            {
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//            NSLog(@"%@",status);
//            m_ProductDetails = [weatherDic objectForKey:@"data"];
//        }
//    }
}

//刷新数据
-(void)Updata:(NSDictionary *)dic
{
    if(dic!=nil)
    {
        m_GoodsName.text = [dic objectForKey:@"name"];
        m_Price.text = [[NSString alloc]initWithFormat:@"￥%@.00",[dic objectForKey:@"price"]];
        m_Introduction.text = [dic objectForKey:@"description"];
       // m_Introduction.editable =NO;
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickView)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self.view addGestureRecognizer:singleRecognizer];
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
