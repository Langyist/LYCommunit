//
//  LYconvenienceMain.m
//  incommunit
//  周边便民
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYconvenienceMain.h"
#import "LYSqllite.h"
#import "LY_FeaturedCell.h"
#import "LY_DeliveryCell.h"
#import "LYShop.h"
#import "XHFriendlyLoadingView.h"
#import "LYSelectCommunit.h"
#import "StoreOnlineNetworkEngine.h"
#import "AppDelegate.h"
#import "UIView+Clone.h"
#import "LYFunctionInterface.h"
#define REDCOLOR colorWithRed:255.0/255.0 green:230.0/255.0 blue:201.0/255.0 alpha:1

@interface LYconvenienceMain ()
{
    UISearchBar *m_deliverSearch;
    UISearchBar *m_shopSearch;
    UISearchBar *m_microShop;
    NSInteger lastIndex;
    UIView *footerView;
}

@end

@implementation LYconvenienceMain

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_pagesize = 5;
    m_pageoffset= 0;
    
    self->locationManager = [[CLLocationManager alloc] init];
    self->locationManager.delegate = self;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //[self->locationManager requestWhenInUseAuthorization];
    }
    self->locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self->locationManager.distanceFilter = 1000.0f;
    if ([CLLocationManager locationServicesEnabled]) {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [self->locationManager startUpdatingLocation];
    }
    else
    {
        NSLog(@"请开启定位功能！");
    }
    
    StoreType = @"";
    orderstr  = @"";
    
    [self.m_segment setMaskForItem:@[@"1", @"2"]];
    [LYSqllite CreatShoppingcart];
    [self.m_segment addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    self._scrollView.contentSize = CGSizeMake(self._scrollView.frame.size.width * 3, self._scrollView.frame.size.height);
    self._scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self._scrollView.pagingEnabled = YES;
    self._scrollView.delegate = self;
    
    //精选
    m_Featuredtableview = [[AWaterfallTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self._scrollView.frame.size.height)];
    m_Featuredtableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    m_Featuredtableview.dataSource = self;
    m_Featuredtableview.delegate = self;
    m_Featuredtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_Featuredtableview.canRefresh = NO;
    m_Featuredtableview.canMore = NO;
    [m_Featuredtableview setContentInset:UIEdgeInsetsMake(7, 0, 0, 0)];
    [self._scrollView addSubview:m_Featuredtableview];
    
    UINib *nib = [UINib nibWithNibName:@"FeaturedCell" bundle:nil];
    [m_Featuredtableview registerNib:nib forCellReuseIdentifier:@"FeaturedCellidentifier"];
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(m_Featuredtableview.frame), 1)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    footerView.clipsToBounds = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 101, 83, 95)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [imageView setImage:[UIImage imageNamed:@"周边便民--未开店--帮帮娃_03"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(139, 107, 160, 89)];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    [label setText:@"亲，帮帮娃玩命加载失败，没有数据"];
    label.font = [UIFont boldSystemFontOfSize:15.0f];
    label.textColor = SPECIAL_GRAY;
    
    [footerView addSubview:imageView];
    [footerView addSubview:label];
    
    [m_Featuredtableview setBackgroundColor:BK_GRAY];
    m_Featuredtableview.tableFooterView = footerView;
    
    /*
    送餐送货
     */
    m_deliverSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self._scrollView.frame.size.width, 40)];
    m_deliverSearch.delegate = self;
    m_deliverSearch.placeholder = @"搜索店铺";
    
    /*
     搜索
     */
    m_shopSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self._scrollView.frame.size.width, 40)];
    m_shopSearch.delegate = self;
    m_shopSearch.placeholder = @"搜索店铺";
    
    /*
     小区微店
     */
    m_microShop = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self._scrollView.frame.size.width, 40)];
    m_microShop.delegate = self;
    m_microShop.placeholder = @"搜索店铺";
    
    m_Deliverytableview = [self addTableViewWithIndex:1 searchBar:m_deliverSearch];
    m_ShopDaquan = [self addTableViewWithIndex:2 searchBar:m_shopSearch];
    m_CellmicroShop = [self addTableViewWithIndex:3 searchBar:m_microShop];
    CGSize size = CGSizeMake(CGRectGetMaxX(m_CellmicroShop.frame), 0);
    [self._scrollView setContentSize:size];
}

- (AWaterfallTableView *)addTableViewWithIndex:(NSInteger)index searchBar:(UISearchBar *)searchBar {
    
    AWaterfallTableView *tableView = [m_Featuredtableview clone];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.canRefresh = NO;
    tableView.canMore = NO;
    
    tableView.tableHeaderView = searchBar;
    tableView.tableFooterView = [footerView clone];
    
    CGRect frame = m_Featuredtableview.frame;
    frame.origin.x = frame.size.width * index;
    tableView.frame = frame;
    
    UINib *nib = [UINib nibWithNibName:@"DeliveryCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"DeliveryCellidentifiter"];
    
    [self._scrollView addSubview:tableView];
    
    return tableView;
}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    latitude=newLocation.coordinate.latitude;
    longitude=newLocation.coordinate.longitude;
    [manager stopUpdatingLocation];// 停止位置更新
    [self GetData];
    [self GetdataDelivery];
    [self GetShopDaquandata];
    [self GetCellmicroShopdata];
    [self GetShoptype];
    [locationManager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Plain Segmented Control 协议函数
-(void)doSomethingInSegment:(CustomSegmentedControl *)Seg
{
    if (lastIndex == Seg.selectedSegmentIndex) {
        for (NSString *maskIndex in Seg.maskForItem) {
            if ([maskIndex integerValue] == Seg.selectedSegmentIndex) {
                [ColMenu showMenuInView:self.view fromRect:Seg.superview.frame delegate:self];
                break;
            }
        }
    }
    
    CGFloat offsetX = Seg.selectedSegmentIndex * self.view.frame.size.width;
    [self._scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    lastIndex = Seg.selectedSegmentIndex;
}

#pragma mark - tableview 协议函数
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRowsInSection = 0;
    
    if (tableView == m_Featuredtableview) {
        numberOfRowsInSection = m_Featuredlist.count;
    }
    else if(tableView == m_Deliverytableview) {

        numberOfRowsInSection = m_Deliverylist.count;

    }
    else if (tableView == m_ShopDaquan) {
        numberOfRowsInSection = m_ShopDaquanlist.count;
    }
    else if (tableView == m_CellmicroShop) {
        numberOfRowsInSection = m_CellmicroShoplist.count;
    }
    
    tableView.tableFooterView.hidden = !(numberOfRowsInSection == 0);
    
    return numberOfRowsInSection;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *retCell = nil;
    NSArray *dataList = nil;
    if (tableView == m_Featuredtableview) {
        
        NSDictionary *Featinfo = [m_Featuredlist objectAtIndex:indexPath.row];
        LY_FeaturedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeaturedCellidentifier" forIndexPath:indexPath];
        NSString *imageUrl = [Featinfo objectForKey:@"cool_path"];
        if ([imageUrl length]) {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [cell.m_imageview setImageWithURL:url placeholderImage:nil];
        }
        
        retCell = cell;
    }
    else if (tableView == m_Deliverytableview) {
        
        dataList = m_Deliverylist;
    }
    else if (tableView == m_ShopDaquan) {
        
        dataList = m_ShopDaquanlist;
    }
    else if (tableView == m_CellmicroShop) {
        
        dataList = m_CellmicroShoplist;
    }
    
    if (nil == retCell) {
        
        LY_DeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryCellidentifiter"];
        retCell = cell;
        
        if (indexPath.row < [dataList count]) {
            
            NSDictionary *Featinfo = [dataList objectAtIndex:indexPath.row];
            
            NSString *imageUrl = [Featinfo objectForKey:@"logo"];
            if ([imageUrl length]) {
                NSURL *url = [NSURL URLWithString:imageUrl];
                [cell.m_imageview setImageWithURL:url placeholderImage:nil];
            }
            [cell setStoreName:[Featinfo objectForKey:@"name"]];
            [cell setCallNumber:[[Featinfo objectForKey:@"call_number"] integerValue]];
            [cell setDistance:[[Featinfo objectForKey:@"distance"] floatValue]];
            
            if ([[Featinfo objectForKey:@"sendable"] boolValue]) {
                cell.m_sendable.text = [NSString stringWithFormat:@"支持配送/%@", [Featinfo objectForKey:@"send_info"]];
            }
            else {
                cell.m_sendable.text = [NSString stringWithFormat:@"不支持配送/%@", [Featinfo objectForKey:@"send_info"]];
            }
            
            cell.m_hui.hidden = ![[Featinfo objectForKey:@"hui"] boolValue];
        }
    }
    
    return retCell;
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyForID = @"";
    NSArray *dataList = nil;
    if (tableView == m_Featuredtableview) {
        
        dataList = m_Featuredlist;
        keyForID = @"shop_id";
    }
    else if (tableView == m_Deliverytableview) {
        
        dataList = m_Deliverylist;
        keyForID = @"id";
    }
    else if (tableView == m_ShopDaquan) {
        
        dataList = m_ShopDaquanlist;
        keyForID = @"id";
    }
    else if (tableView == m_CellmicroShop) {
        
        dataList = m_CellmicroShoplist;
        keyForID = @"id";
    }
    if (indexPath.row < [dataList count])
    {
        NSDictionary *dataInfo = [dataList objectAtIndex:indexPath.row];
        m_Storesid = [[NSString alloc]initWithFormat:@"%@", [dataInfo objectForKey:keyForID]];
        [self performSegueWithIdentifier:@"Gostoresinfo" sender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRowAtIndexPath = 0;
    if (tableView == m_Featuredtableview) {
        heightForRowAtIndexPath = 138;
    }
    else if (tableView == m_Deliverytableview) {
        heightForRowAtIndexPath = 86;
    }
    else if (tableView == m_ShopDaquan) {
        heightForRowAtIndexPath = 86;
    }
    else if (tableView == m_CellmicroShop) {
        heightForRowAtIndexPath = 86;
    }
    return heightForRowAtIndexPath;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self._scrollView) {
        NSInteger index = lroundf(self._scrollView.contentOffset.x / self._scrollView.frame.size.width);
        self.m_segment.selectedSegmentIndex = index;
    }
}

#pragma mark - 获取数据
//获取精选数据
-(void)GetData
{
    NSDictionary *dic = @{@"community_id" : [[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"]};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/shop/cool"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                               [aler show];
                                                           }else
                                                           {
                                                               m_Featuredlist =result;
                                                               [m_Featuredtableview reloadData];
                                                           }
                                                       }];
}

//获取送餐送货数据
-(void)GetdataDelivery
{
    
    NSDictionary *dic = @{@"sendable" : @"1"
                          ,@"order" : orderstr
                          ,@"longitude" : [[NSString alloc] initWithFormat:@"%f",longitude]
                          ,@"latitude" : [[NSString alloc] initWithFormat:@"%f",latitude]
                          ,@"pagesize" : [[NSString alloc] initWithFormat:@"%d",m_pagesize]
                          ,@"pageoffset" : [[NSString alloc] initWithFormat:@"%d",m_pageoffset]
                          ,@"type_id" :StoreType
                          ,@"search_kw" : m_deliverSearch.text};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/shop/list"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               NSLog(@"error %@",errorMsg);
                                                           }else
                                                           {
                                                               m_Deliverylist =result;
                                                               [m_Deliverytableview reloadData];
                                                           }
                                                       }];
    
}

//获取店铺大全数据
-(void)GetShopDaquandata
{
    NSDictionary *dic = @{@"category" : @"1"
                          ,@"order" : orderstr
                          ,@"longitude" : [[NSString alloc] initWithFormat:@"%f",longitude]
                          ,@"latitude" : [[NSString alloc] initWithFormat:@"%f",latitude]
                          ,@"pagesize" : [[NSString alloc] initWithFormat:@"%d",m_pagesize]
                          ,@"pageoffset" : [[NSString alloc] initWithFormat:@"%d",m_pageoffset]
                          ,@"type_id" :StoreType
                          ,@"search_kw" : m_shopSearch.text};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/shop/list"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               NSLog(@"error %@",errorMsg);
                                                           }else
                                                           {
                                                               m_ShopDaquanlist =result;
                                                               [m_ShopDaquan reloadData];
                                                           }
                                                       }];
}

-(void)GetCellmicroShopdata
{

    NSDictionary *dic = @{@"category" : @"2"
                          ,@"order" : orderstr
                          ,@"longitude" : [[NSString alloc] initWithFormat:@"%f",longitude]
                          ,@"latitude" : [[NSString alloc] initWithFormat:@"%f",latitude]
                          ,@"pagesize" : [[NSString alloc] initWithFormat:@"%d",m_pagesize]
                          ,@"pageoffset" : [[NSString alloc] initWithFormat:@"%d",m_pageoffset]
                          ,@"type_id" :StoreType
                          ,@"search_kw" : m_microShop.text};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/shop/list"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               NSLog(@"error %@",errorMsg);
                                                           }else
                                                           {
                                                               m_CellmicroShoplist =result;
                                                               [m_CellmicroShop reloadData];
                                                           }
                                                       }];
}

//获取店铺类型接口
-(void)GetShoptype
{
    NSDictionary *dic = @{};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/shop/type"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                          activity:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               NSLog(@"error %@",errorMsg);
                                                           }else
                                                           {
                                                               m_shoptypelist = result;
                                                           }
                                                       }];
}

#pragma UIStoryboardSegue 协议函数
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"Gostoresinfo"])
    {
        LYShop *detailViewController = (LYShop*) segue.destinationViewController;
        detailViewController->m_StoresID = self->m_Storesid;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(searchBar == m_deliverSearch)
    {
        [self GetdataDelivery];
    }
    if(searchBar == m_shopSearch)
    {
        [self GetShopDaquandata];
    }
    if (searchBar == m_microShop) {
        [self GetCellmicroShopdata];
    }
    m_tempb =searchBar;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //[searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if(searchBar == m_deliverSearch)
    {
        [self GetdataDelivery];
    }
    if(searchBar == m_shopSearch)
    {
        [self GetShopDaquandata];
    }
    if (searchBar == m_microShop) {
        [self GetCellmicroShopdata];
    }

}


#pragma mark -
#pragma mark ColMenuDelegate
- (NSInteger)sectionOfColMenu:(ColMenu *)colMenu {
    NSInteger sectionOfColMenu = 0;
    switch (self.m_segment.selectedSegmentIndex) {
        case 1:
            sectionOfColMenu = 2;
            break;
        case 2:
            sectionOfColMenu = 2;
            break;
        default:
            break;
    }
    return sectionOfColMenu;
}

- (NSInteger)colMune:(ColMenu *)colMenu numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRowsInSection = 0;
            switch (section) {
                case 0:
                    numberOfRowsInSection = m_shoptypelist.count+1;
                    break;
                case 1:
                    numberOfRowsInSection = [LYFunctionInterface Getorder].count+1;
                    break;
                default:
                    break;
            }
    return numberOfRowsInSection;
}

- (NSString *)colMune:(ColMenu *)colMenu titleForItemOfSection:(NSInteger)section row:(NSInteger)row
{

    NSDictionary *dictemp;
    NSString *str;
            switch (section) {
                case 0:
                    if (row == 0) {
                        str = @"全部";
                    }else
                    {
                        dictemp = [m_shoptypelist objectAtIndex:row-1];
                        str =  [dictemp objectForKey:@"name"];
                    }
                    break;
                case 1:
                    if (row == 0) {
                        str = @"默认排序";
                    }else
                    {
                        str = [[[LYFunctionInterface Getorder] objectAtIndex:row - 1] objectForKey:@"order_name"];
                    }
                    break;
                default:
                    break;
            }
           return str;

}

- (void)colMune:(ColMenu *)colMenu didSelectItemOfSection:(NSInteger)section row:(NSInteger)row {
    switch (self.m_segment.selectedSegmentIndex) {
        case 1: {
            switch (section) {
                case 0:
                    if (row == 0) {
                        StoreType = @"";
                    }else
                    {
                        StoreType = [[m_shoptypelist objectAtIndex:row-1] objectForKey:@"id"];
                    }
                    [self GetdataDelivery];
                    break;
                case 1:
                    if(row == 0)
                    {
                        orderstr = @"";
                    }else
                    {
                        orderstr = [[[LYFunctionInterface Getorder] objectAtIndex:row-1] objectForKey:@"order_id"];
                    }
                    [self GetdataDelivery];
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
            switch (section) {
                case 0:
                    if (row == 0) {
                        StoreType = @"";
                    }else
                    {
                        StoreType = [[m_shoptypelist objectAtIndex:row-1] objectForKey:@"id"];
                    }
                    [self GetShopDaquandata];
                    break;
                case 1:
                    if(row == 0)
                    {
                        orderstr = @"";
                    }else
                    {
                        orderstr = [[[LYFunctionInterface Getorder] objectAtIndex:row-1] objectForKey:@"order_id"];
                    }
                    [self GetShopDaquandata];
                    break;
                default:
                    break;
            }
    }

}

@end
