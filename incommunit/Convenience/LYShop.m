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
#import "LYProductinformation.h"
#import "CustomToolbarItem.h"
#import "StoreslistTableViewCell.h"
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
@synthesize m_imageScrollView,m_imageView,Item;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"StoreslistTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"StoreslistTableViewCell"];

    [self Getstoresdata:@""];
    tempgoodstype = [[NSMutableArray alloc] init];
    m_stores = [[NSMutableDictionary alloc] init];
    [m_stores  setValue:m_StoresID forKey:@"id"];
    Properties = [[NSArray alloc]initWithObjects:@"智能排序",@"点赞次数",nil];
    Goodstype = [[NSArray alloc] init];
    categoryid = @"";
    order = @"";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(238.0/255) green:(183.0/255) blue:(88.0/255) alpha:1.0];
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(240.0/255) green:(174.0/255) blue:(64.0/255) alpha:1.0];
    
    UIBarButtonItem *mapItem = [self createCustomItem:@"首页" imageName:@"首页" selector:@selector(jumpToPage:) tag:100];
    UIBarButtonItem *mineItem = [self createCustomItem:@"个人主页" imageName:@"2" selector:@selector(jumpToPage:) tag:101];
    UIBarButtonItem *toolItem = [self createCustomItem:@"购物车" imageName:@"购物车" selector:@selector(jumpToPage:) tag:102];
    UIBarButtonItem *orderItem = [self createCustomItem:@"我的订单" imageName:@"订单" selector:@selector(jumpToPage:) tag:103];
    NSArray *array = [NSArray arrayWithObjects:
                      [self createFixableItem:10]
                      ,mapItem
                      ,[self createFixableItem:0]
                      ,mineItem
                      ,[self createFixableItem:0]
                      ,toolItem
                      ,[self createFixableItem:0]
                      ,orderItem
                      ,[self createFixableItem:10]
                      ,nil];
    [self setToolbarItems:array animated:YES];
    [NSThread detachNewThreadSelector:@selector(Getstoresdata:) toTarget:self withObject:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - tableView协议函数

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_Goodslist.count + 6;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    if (indexPath.row < 6)
    {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        if (m_storesinfo!=nil) {
            switch (indexPath.row) {
                case 1:
                    _shopSummary.text = [m_storesinfo objectForKey:@"description"];
                    break;
                case 2:
                    _youhui.text = [m_storesinfo objectForKey:@"send_info"];
                    break;
                case 3:
                    _address.text = [[NSString alloc] initWithFormat:@"地址：%@",[m_storesinfo objectForKey:@"address"]];
                    break;
                case 4:
                    _phoneNumber.text = [[NSString alloc]initWithFormat:@"电话：%@",[m_storesinfo objectForKey:@"phone"]] ;
                    break;
                case 5:
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
    }
    else
    {
        StoreslistTableViewCell *storeslistTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"StoreslistTableViewCell" forIndexPath:indexPath];
        m_Goodspice=(UIImageView *)[storeslistTableViewCell viewWithTag:104];
        m_GoodsName = (UILabel *)[storeslistTableViewCell viewWithTag:105];
        m_GoodsChan =(UILabel *)[storeslistTableViewCell viewWithTag:106];
        m_Price= (UILabel *)[storeslistTableViewCell viewWithTag:107];
        m_ShoppingCartButton = (UIButton *)[storeslistTableViewCell viewWithTag:110];
        m_ShoppingCartButton.tag = indexPath.row-6;
        [m_ShoppingCartButton addTarget:self action:@selector(addShoppingCart:)
                       forControlEvents:UIControlEventTouchUpInside];
        NSMutableDictionary *Goodsinfo =[m_Goodslist objectAtIndex:indexPath.row-6];
        NSString *imageUrl = [Goodsinfo objectForKey:@"cover_path"];
        if (imageUrl!=nil && ![imageUrl isEqualToString:@""])
        {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [m_Goodspice setImageWithURL:url placeholderImage:nil];
        }
        m_GoodsName.text = [Goodsinfo objectForKey:@"name"];
        m_GoodsChan.text = [[NSString alloc]initWithFormat:@"点赞次数：%@",[Goodsinfo objectForKey:@"like"]];
        m_Price.text = [[NSString alloc]initWithFormat:@"￥%@.00",[Goodsinfo objectForKey:@"price"]];
        cell = storeslistTableViewCell;
    }
    return cell;
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSLog(@"%lu",(unsigned long)row);
    if (indexPath.row > 5) {
        NSMutableDictionary *Goodsinfo =[m_Goodslist objectAtIndex:indexPath.row-6];
        m_Goodsid =  m_Goodsid = [[NSString alloc] initWithFormat:@"%@",[Goodsinfo objectForKey:@"id"]];
        [self performSegueWithIdentifier:@"GoProductDetails" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 6) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else {
        return 88;
    }
}

#pragma mark - overwrite

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.section;
    
    // if dynamic section make all rows the same indentation level as row 0
    if (row < 6) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

#pragma mark - 界面切换传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"GoProductDetails"])
    {
        LYProductinformation *detailViewController = (LYProductinformation*) segue.destinationViewController;
        detailViewController->m_GoodsID = self->m_Goodsid;
       // detailViewController->m_storesinfo = self->m_stores;
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
    if (response!=nil) {
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSString *status = [weatherDic objectForKey:@"status"];
    NSLog(@"%@",status);
    //    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:status delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [aler show];
    m_storesinfo = [weatherDic objectForKey:@"data"];
    m_Goodslist = [m_storesinfo objectForKey:@"commodities"];
   // Goodstype  =[m_storesinfo objectForKey:@"categories"];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            // 更新UI
        });
    [self serachGoods:@""];
    }
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
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(response1!=nil)
    {
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response1 options:NSJSONReadingMutableLeaves error:&error];
        NSString *status = [weatherDic objectForKey:@"status"];
        m_Goodslist = [weatherDic objectForKey:@"data"];
        NSLog(@"%@",status);
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        // 更新UI
    });
    }
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
- (void)jumpToPage:(CustomToolbarItem *)sender
{
    switch (sender.tag) {
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


- (IBAction)all:(id)sender {
}

- (IBAction)autoSort:(id)sender {
}
@end
