//
//  LYShop.m
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYShop.h"
#import "LMContainsLMComboxScrollView.h"
#import "LYSqllite.h"
#define kDropDownListTag 1000
@interface LYShop ()
{
    LMContainsLMComboxScrollView *bgScrollView;
    NSMutableArray *tempgoodstype;
    NSString *categoryid ;
    NSString *order;
}

@end

@implementation LYShop

@synthesize m_tableview,m_imageScrollView,m_imageView,Item,m_tabBar;
- (void)viewDidLoad
{
    [super viewDidLoad];
    tempgoodstype = [[NSMutableArray alloc] init];
    m_stores = [[NSMutableDictionary alloc] init];
    [m_stores  setValue:m_StoresID forKey:@"id"];
    Properties = [[NSArray alloc]initWithObjects:@"智能排序",@"点赞次数",nil];
    Goodstype = [[NSArray alloc] init];
    categoryid = @"";
    order = @"";
    [self Getstoresdata:@""];
    //[NSThread detachNewThreadSelector:@selector(Getstoresdata:) toTarget:self withObject:nil];
    //[self Getstoresdata:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableView协议函数
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_Goodslist.count+2;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init] ;
    switch (indexPath.row) {
        case 0:
        {
            
            m_StoreIntroduction = [[UILabel alloc] init];
            m_DistributionRules = [[UILabel alloc] init];
            m_Address = [[UIButton alloc] init];
            m_Phone = [[UIButton alloc] init];
            cell = [tableView dequeueReusableCellWithIdentifier:@"storesinfo"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            m_imageScrollView = (UIScrollView *)[cell viewWithTag:105];
            NSMutableArray *temparray = [m_storesinfo objectForKey:@"commodities"];
            m_imageScrollView.contentSize = CGSizeMake(temparray.count * 320.0f, m_imageScrollView.frame.size.height);
            m_imageScrollView.pagingEnabled = YES;
            m_imageScrollView.showsHorizontalScrollIndicator = NO;
            m_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f,  0.0f, m_imageScrollView.frame.size.width, m_imageScrollView.frame.size.height)];
            
            for (int i = 0; i<temparray.count; i++)
            {
                NSDictionary *tempdic = [temparray objectAtIndex:i];
                NSString *imageUrl = [tempdic objectForKey:@"cover_path"];
                if (imageUrl!=nil && ![imageUrl isEqualToString:@""])
                {
                    NSURL *url = [NSURL URLWithString:imageUrl];
                    [m_imageView setImageWithURL:url placeholderImage:nil];
                }
                [m_imageScrollView addSubview:m_imageView];
            }
            m_StoreIntroduction = (UILabel *)[cell viewWithTag:100];
            m_DistributionRules = (UILabel *)[cell viewWithTag:101];
            m_Address = (UIButton *)[cell viewWithTag:102];
            m_Phone=(UIButton *)[cell viewWithTag:103];
            m_StoreIntroduction .text =  [m_storesinfo objectForKey:@"description"];
            m_DistributionRules.text = [m_storesinfo objectForKey:@"send_info"];
            [m_Address setTitle: [[NSString alloc] initWithFormat:@"地址：%@",[m_storesinfo objectForKey:@"address"]] forState: UIControlStateNormal];
            [m_Phone setTitle: [[NSString alloc]initWithFormat:@"电话：%@",[m_storesinfo objectForKey:@"phone"]] forState: UIControlStateNormal];
        }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"storesselect"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //            UIButton *allButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 6, 150, 30)];
            //            [cell addSubview:allButton];
            //
            //            UILabel *allLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, allButton.frame.size.width, allButton.frame.size.height)];
            //            allLabel.text = @"全部";
            //            [allButton addSubview:allLabel];
            //
            //            UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(allButton.frame.size.width - 20, allButton.frame.size.height - 20, 15, 15)];
            //            image.image = [UIImage imageNamed:@""];
            //            [allButton addSubview:image];
            
            if (tempgoodstype.count>0) {
                [self setUpBgScrollView];
            }
        }
            break;
        default:
        {
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            NSDictionary *Goodsinfo =[m_Goodslist objectAtIndex:indexPath.row-2];
            m_Goodspice = [[UIImageView alloc] init];
            m_GoodsName = [[UILabel alloc] init];
            m_GoodsChan = [[UILabel alloc] init];
            m_ShoppingCartButton = [[UIButton alloc] init];
            m_Price = [[UILabel alloc] init];
            cell = [tableView dequeueReusableCellWithIdentifier:@"storeslist"];
            m_Goodspice=(UIImageView *)[cell viewWithTag:104];
            m_GoodsName = (UILabel *)[cell viewWithTag:105];
            m_GoodsChan =(UILabel *)[cell viewWithTag:106];
            m_Price= (UILabel *)[cell viewWithTag:107];
            m_ShoppingCartButton = (UIButton *)[cell viewWithTag:110];
            m_ShoppingCartButton.tag = indexPath.row-2;
            [m_ShoppingCartButton addTarget:self action:@selector(addShoppingCart:)
                           forControlEvents:UIControlEventTouchUpInside];
            if([self getImageFromURL:[Goodsinfo objectForKey:@"cover_path"]]!=nil)
            {
                [m_Goodspice setImage:[self getImageFromURL:[Goodsinfo objectForKey:@"cover_path"]]];
            }
            m_GoodsName.text = [Goodsinfo objectForKey:@"name"];
            m_GoodsChan.text = [[NSString alloc]initWithFormat:@"点赞次数：%@",[Goodsinfo objectForKey:@"like"]];
            m_Price.text = [[NSString alloc]initWithFormat:@"￥%@.00",[Goodsinfo objectForKey:@"price"]];
        }
            break;
    }
    return cell;
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSLog(@"%lu",(unsigned long)row);
    if (indexPath.row>1) {
        NSMutableDictionary *Goodsinfo =[m_Goodslist objectAtIndex:indexPath.row-2];
        m_Goodsid = Goodsinfo;
        [self performSegueWithIdentifier:@"GoProductDetails" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return 240;
            break;
        case 1:
            return 40;
            break;
        default:
            return 90;
            break;
    }
}

#pragma mark - 界面切换传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"GoProductDetails"])
    {
//        LYProductDetails *detailViewController = (LYProductDetails*) segue.destinationViewController;
//        detailViewController->m_GoodsID = self->m_Goodsid;
//        detailViewController->m_storesinfo = self->m_stores;
    }
}

#pragma mark - 获取数据
-(IBAction)Getstoresdata:(NSString *)URL
{
    // m_viewms = [LYSelectCommunity showProgressAlert:self.view sms:@"正在获取店铺信息"];
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    
    NSError *error;
    //    加载一个NSURL对象
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/shop/detail?id=%@",url,m_StoresID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSString *status = [weatherDic objectForKey:@"status"];
    NSLog(@"%@",status);
    //    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:status delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [aler show];
    m_storesinfo = [weatherDic objectForKey:@"data"];
    m_Goodslist = [m_storesinfo objectForKey:@"commodities"];
    Goodstype  =[m_storesinfo objectForKey:@"categories"];
    [tempgoodstype addObject:@"全部"];
    for (int i=0; i<Goodstype.count; i++)
    {
        NSDictionary *temp = [Goodstype objectAtIndex:i];
        [tempgoodstype addObject:[temp  objectForKey:@"name"]];
    }
    [m_stores setValue:[m_storesinfo objectForKey:@"name"] forKey:@"name"];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0]];
    [customLab setText:[m_storesinfo objectForKey:@"name"]];
    customLab.font = [UIFont boldSystemFontOfSize:17];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;
    m_tabBar.delegate = self;
    
    [NSThread detachNewThreadSelector:@selector(serachGoods:) toTarget:self withObject:nil];
}

-(void)serachGoods:(NSString *)URL
{
    //m_viewms = [LYSelectCommunity showProgressAlert:self.view sms:@"正在获取商品列表"];
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/shop/commodity_list?shop_id=%@&category_id=%@&order=%@&pageSize=10&pageOffset=0",url,m_StoresID,categoryid,order];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSString *status = [weatherDic objectForKey:@"status"];
    m_Goodslist = [weatherDic objectForKey:@"data"];
    NSLog(@"%@",status);
    [m_tableview reloadData];
}
//获取网络图片
-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    NSLog(@"执行图片下载函数");
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
    
}
//返回
-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"移除");}];
}

#pragma mark 添加购物车
-(IBAction)addShoppingCart:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSMutableDictionary *stored =[m_Goodslist objectAtIndex:btn.tag];
    [LYSqllite addShoppingcart:stored number:@"1" StoresID:m_StoresID Storesname:[m_storesinfo objectForKey:@"name"] selectState:@"1"];
    m_addshopcatalert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功将商品加入了购物车" delegate:self cancelButtonTitle:@"继续购物" otherButtonTitles:@"去购物车结算", nil];
    [m_addshopcatalert show];
}

-(IBAction)CellPhone:(id)sender
{
    NSString  *phonenumber =[[NSString alloc]initWithFormat:@"tel:%@",[m_storesinfo objectForKey:@"phone"]];
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:phonenumber];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view  addSubview:callWebview];
}
#pragma mark alertView 协议函数
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == m_addshopcatalert && buttonIndex == 1)
    {
        [self performSegueWithIdentifier:@"GoMyCatshop" sender:self];
    }
}

-(void)setUpBgScrollView
{
    for(NSInteger i=0;i<2;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2*i+15, 3, self.view.frame.size.width/2-20, 32)];
        comBox.backgroundColor = [UIColor whiteColor];
        comBox.arrowImgName = @"down_dark0.png";
        NSMutableArray  *itemsArray = [[NSMutableArray alloc]initWithCapacity:1];
        switch (i) {
            case 0:
                if (tempgoodstype.count>0)
                {
                    [itemsArray addObjectsFromArray:tempgoodstype];
                }
                break;
            case 1:
                if (Properties.count>0)
                {
                    [itemsArray addObjectsFromArray:Properties];
                }
                break;
            default:
                break;
        }
        comBox.titlesList = itemsArray;
        comBox.delegate = self;
        comBox.supView = bgScrollView;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        [bgScrollView addSubview:comBox];
    }
}

#pragma mark UItabBar 协议函数
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 100:
            [self performSegueWithIdentifier:@"BackMian" sender:self];
            break;
        case 101:
            [self performSegueWithIdentifier:@"GoTools" sender:self];
            break;
        case 102:
            [self performSegueWithIdentifier:@"GoMyCatshop" sender:self];
            break;
        case 103:
            [self performSegueWithIdentifier:@"GoTools" sender:self];
            break;
        default:
            break;
    }
}
#pragma mark inCombox 协议函数
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    NSDictionary *temp;
    switch (_combox.tag) {
        case 1000:
            if (index>0) {
                temp= [Goodstype objectAtIndex:index-1];
                categoryid =[temp objectForKey:@"id"];
            }else
            {
                categoryid = @"";
            }
            [NSThread detachNewThreadSelector:@selector(serachGoods:) toTarget:self withObject:nil];
            break;
        case 1001:
            categoryid = [[NSString alloc] initWithFormat:@"%d",index+1];
            break;
        default:
            break;
    }
}


@end
