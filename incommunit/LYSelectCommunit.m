//
//  ViewController.m
//  incommunit
//  选择小区
//  Created by LANGYI on 14/10/25.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYSelectCommunit.h"
#import "LYSelectCity.h"
#import "LYUIview.h"
#import "LYUserloginView.h"
#import "LYSqllite.h"
@interface LYSelectCommunit ()
{
    NSMutableArray * CommunitylistON;
    NSMutableArray * CommunitylistOF;
}

@end
@implementation LYSelectCommunit
@synthesize m_tab,Serch,m_lable_address,m_lable_distance,m_lable_name,m_lable_st;
static BOOL m_Refresh;//是否刷新界面
static NSDictionary *          m_cityinfo;//城市信息
- (void)awakeFromNib
{
    [super awakeFromNib];
}
#pragma mark - 初始化
-(void)viewDidLoad
{
    m_CommunitylistOF = [[NSMutableArray alloc]init];
    m_CommunitylistON = [[NSMutableArray alloc]init];
    NSMutableDictionary *userinfo =  [LYSqllite Ruser];
    if (userinfo != nil&&m_bl ==FALSE)
    {
        [self performSegueWithIdentifier:@"Gomain4" sender:self];
        m_cityinfo = userinfo;
    }
    m_pageSize = 10;
    m_pageOffset = 0;
//[LY_Sqllite CreatShoppingcart]; //创建购物车信息表
    self->Serch.delegate=self;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(238.0/255) green:(183.0/255) blue:(88.0/255) alpha:1.0];
    //m_selectCityButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [_selectCityButton addTarget:self action:@selector(GoselectCity) forControlEvents:UIControlEventTouchUpInside];
    [_selectCityButton setTitle: @"成都" forState: UIControlStateNormal];
    self.navigationItem.titleView = _selectCityButton;
    //m_selectCityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_selectCityButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_selectCityButton setTitleColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0] forState:UIControlStateNormal];
    //[m_selectCityButton.titleLabel setFont:[UIFont fontWithName: @"Helvetica"   size : 17.0 ]];
    self->locationManager = [[CLLocationManager alloc] init];
    self->locationManager.delegate = self;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        [self->locationManager requestWhenInUseAuthorization];
    }
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    self->locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    self->locationManager.distanceFilter = 1000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    if ([CLLocationManager locationServicesEnabled])
    {
        [self->locationManager startUpdatingLocation];
        self.view.userInteractionEnabled = YES;
        [m_View removeFromSuperview];
    }
    else
    {
        NSLog(@"请开启定位功能！");
    }
    [super viewDidLoad];
    
    [m_tab refreshStart];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Segues 协议
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"GoLYUserloginView"])
    {
        LYUserloginView *detailViewController = (LYUserloginView*) segue.destinationViewController;
        detailViewController->m_bool = FALSE;
    }
    if ([segue.identifier isEqualToString: @"GoLYSelectCity"])
    {
        LYSelectCity *detailViewController = (LYSelectCity*) segue.destinationViewController;
        detailViewController->locCityName = m_city_name;
    }
}
#pragma mark - CLLocationManagerDelegate 定位协议函数
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    latitude=newLocation.coordinate.latitude;
    longitude=newLocation.coordinate.longitude;
    [manager stopUpdatingLocation];// 停止位置更新
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error)
     {
         for(CLPlacemark *placemark in placemarks)
         {
             if (m_data.count>0)
             {
                 [_selectCityButton setTitle: [m_data objectForKey:@"name"] forState: UIControlStateNormal];
             }else
             {
                 [_selectCityButton setTitle: [[NSString alloc]initWithFormat:@"%@",[[placemark.addressDictionary objectForKey:@"City"] substringToIndex:2] ] forState: UIControlStateNormal];
                 m_city_name  =[[placemark.addressDictionary objectForKey:@"City"] substringToIndex:2];
             }
             [self.m_tab reloadData];
             self.view.userInteractionEnabled = YES;
         }
     }];
    [NSThread detachNewThreadSelector:@selector(GetCommunity:) toTarget:self withObject:nil];
    [locationManager stopUpdatingLocation];
}
// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}
//跳转到选择城市界面
-(IBAction)GoselectCity
{
    [self performSegueWithIdentifier:@"GoLYSelectCity" sender:self];
}
#pragma mark - tableView 协议函数
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_CommunitylistON.count+m_CommunitylistOF.count;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *Community;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Listcell" forIndexPath:indexPath];
    m_lable_name = (UILabel *)[cell.contentView viewWithTag:100];
    m_lable_address = (UILabel *)[cell.contentView viewWithTag:101];
    m_lable_distance = (UILabel *)[cell.contentView viewWithTag:102];
    m_lable_st=(UILabel *)[cell.contentView viewWithTag:103];
    
    UIColor *color = [UIColor darkTextColor];
    NSString *text = @"已开通";
    if (m_CommunitylistON.count > indexPath.row) {
        Community=[m_CommunitylistON objectAtIndex:indexPath.row];
    }
    else if (m_CommunitylistOF.count > indexPath.row - m_CommunitylistON.count) {
        Community=[m_CommunitylistOF objectAtIndex:indexPath.row - m_CommunitylistON.count];
        color = [UIColor lightGrayColor];
        text = @"未开通";
    }
    m_lable_st.text = text;
    m_lable_st.textColor = color;
    m_lable_name.text =[Community objectForKey:@"name"];
    m_lable_address.text =[Community objectForKey:@"address"];
    CGFloat distance = [[Community objectForKey:@"distance"] floatValue];
    if(distance>1)
    {
        m_lable_distance.text =[NSString stringWithFormat:@"%.2lf  km", distance];
    }else
    {
         m_lable_distance.text =[NSString stringWithFormat:@"%.0lf m", distance*1000];
    }
    return cell;
}


//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSLog(@"%lu",(unsigned long)row);
    if (m_CommunitylistON.count>indexPath.row)
    {
        m_cityinfo = [m_CommunitylistON objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"GoLYUserloginView" sender:self];
        
    }else if (m_CommunitylistOF.count>indexPath.row - m_CommunitylistON.count)
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"小区暂未开通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//tableView滚动事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [Serch resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    m_pageOffset = 0;
    m_CommunityName = Serch.text;
    [Serch resignFirstResponder];
    [NSThread detachNewThreadSelector:@selector(GetCommunity:) toTarget:self withObject:nil];
    [self.m_tab reloadData];
    self.view.userInteractionEnabled = YES;
    [m_View removeFromSuperview];
}

#pragma mark - 获取网络数据
//搜索小区
-(void)GetCommunity:(NSString*)URL
{
    int pagesize = 0;
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *urlstr = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *str;
    NSString *URLstr =[[NSString alloc] initWithFormat:@"%@/services/community/search",urlstr];
    NSURL *url = [NSURL URLWithString:URLstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    if (m_data.count>1)
    {
        m_city_id =[m_data objectForKey:@"id"];
        str = @"city_id=";//设置参数
        str = [str stringByAppendingFormat:@"%@&name=%@&longitude=%f&latitude=%f&pageSize=%d&pageOffset=%d", m_city_id,m_CommunityName,longitude,latitude,m_pageSize,m_pageOffset];
    }else if([[m_data objectForKey:@"id"] isEqualToString:@""]||[m_data objectForKey:@"id"] == nil)
    {
        if (m_CommunityName == nil)
        {
            m_CommunityName = @"";
        }
        if ([m_data objectForKey:@"name"]!=nil||m_data!=nil) {
            m_city_name =[m_data objectForKey:@"name"];
        }
        str = @"city_name=";//设置参数
         str = [str stringByAppendingFormat:@"%@&name=%@&longitude=%f&latitude=%f&pageSize=%d&pageOffset=%d", m_city_id,m_CommunityName,longitude,latitude,m_pageSize,m_pageOffset];
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(received!=nil)
    {
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
        pagesize = [[weatherDic objectForKey:@"pageSize"] intValue];
        m_pageOffset = [[weatherDic objectForKey:@"pageOffset"] intValue];
        if(weatherDic!=nil)
        {
            NSString *status = [weatherDic objectForKey:@"status"];
            NSLog(@"%@",status);
            if(![status isEqual:@"200"])
            {
                UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接网络失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [ale show];
            }else
            {
                NSDictionary *data1 = [weatherDic objectForKey:@"data"];
                CommunitylistON = [data1 objectForKey:@"communities"];
                CommunitylistOF = [data1 objectForKey:@"refCommunities"];
            }
            [m_CommunitylistON addObjectsFromArray:CommunitylistON];
            [m_CommunitylistOF addObjectsFromArray:CommunitylistOF];
            [m_tab reloadData];
        }
        else
        {
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取网络数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [ale show];
        }
    }
    
     if (pagesize < m_pageSize) {
        m_tab.canMore = NO;
     }
     else {
        m_tab.canMore = YES;
     }
    if (m_tab.status == AWaterfallTableViewRefreshing) {
        [m_tab refreshEnd];
        m_pageOffset = 0;
    }
    else if (m_tab.status == AWaterfallTableViewMoring) {
        [m_tab moreEnd];
        m_pageOffset++;
    }
    
}

#pragma mark - 切换界面进入协议函数
-(void)viewDidAppear:(BOOL)animated
{
    if (m_Refresh)
    {
        if ([CLLocationManager locationServicesEnabled])
        {
            [self->locationManager startUpdatingLocation];
        }
        else
        {
            NSLog(@"请开启定位功能！");
        }
        m_CommunityName = @"";
        m_data = [LYSelectCity CityInfo];
        [_selectCityButton setTitle: [m_data objectForKey:@"name"] forState: UIControlStateNormal];
        self.view.userInteractionEnabled = YES;
        [m_tab refreshStart];
        
        [self.m_tab reloadData];
        Serch.text= @"";
        m_Refresh = NO;
    }
}
#pragma  mark -获取小区ID
+(NSDictionary *)GetCommunityInfo
{
    return m_cityinfo;
}
#pragma mark - 刷新界面
+(void)Updata:(BOOL)sender
{
    m_Refresh =  sender;
}

- (void)refresh:(AWaterfallTableView *)tableView {
    [self GetCommunity:@""];
}

- (void)more:(AWaterfallTableView *)tableView
{
    [self GetCommunity:@""];
}

@end

