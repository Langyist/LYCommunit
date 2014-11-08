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
#import "AppDelegate.h"
#import "StoreOnlineNetworkEngine.h"
@interface LYSelectCommunitCell : UITableViewCell
{
    NSString *Cityname;
}
@end
@implementation LYSelectCommunitCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGFloat lineWidth = 0.2f;
    CGFloat move = 1.0f - lineWidth;
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, lineWidth);
    
    CGContextMoveToPoint(context, 0.0f, CGRectGetHeight(rect) - move); //start at this point
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect) - move); //draw to this point
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end
@interface LYSelectCommunit ()
{
    NSMutableArray * CommunitylistON;
    NSMutableArray * CommunitylistOF;
}
@end
@implementation LYSelectCommunit
@synthesize m_tab,Serch,m_lable_address,m_lable_distance,m_lable_name,m_lable_st,selectCityButton;
static BOOL m_Refresh;//是否刷新界面
static NSDictionary *   m_cityinfo;//城市信息
- (void)awakeFromNib
{
    [super awakeFromNib];
}
#pragma mark - 初始化
-(void)viewDidLoad
{
    [super viewDidLoad];
    m_CommunitylistOF = [[NSMutableArray alloc]init];
    m_CommunitylistON = [[NSMutableArray alloc]init];
    NetParameters = [[NSMutableDictionary alloc] init];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.m_tab.frame), 1)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    footerView.clipsToBounds = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 130, 150)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [imageView setImage:[UIImage imageNamed:@"周边便民--未开店--帮帮娃_03"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 100, 150, 100)];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    [label setText:@"亲，帮帮娃玩命加载失败，此功能尚未开启"];
    label.font = [UIFont boldSystemFontOfSize:17.0f];
    label.textColor = SPECIAL_GRAY;
    
    [footerView addSubview:imageView];
    [footerView addSubview:label];
    
    [self.m_tab setBackgroundColor:BK_GRAY];
    self.m_tab.tableFooterView = footerView;
    
    NSMutableDictionary *userinfo =  [LYSqllite Ruser];
    if (userinfo != nil&&m_bl ==FALSE) {
        [self performSegueWithIdentifier:@"Gomain4" sender:self];
        m_cityinfo = userinfo;
    }
    m_pageSize = 1000;
    m_pageOffset = 0;
    self->Serch.delegate=self;
    [selectCityButton addTarget:self action:@selector(GoselectCity) forControlEvents:UIControlEventTouchUpInside];
    [selectCityButton setTitle: @"成都" forState: UIControlStateNormal];
    self->locationManager = [[CLLocationManager alloc] init];
    self->locationManager.delegate = self;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        [self->locationManager requestWhenInUseAuthorization];
    }
    //NSDictionary * temp = [Location shareLocation].GetLocation;
    //初始化BMKLocationService
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    //启动LocationService
    [locService startUserLocationService];

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
        detailViewController->selectcity = selectCityButton;
    }
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    latitude =userLocation.location.coordinate.latitude;
    longitude =userLocation.location.coordinate.longitude;
    BMKGeoCodeSearch *_geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    //初始化逆地理编码类
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    //需要逆地理编码的坐标位置
    reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    [locService stopUserLocationService];
  //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
   // NSString *cityname = result.addressDetail.city;
    NSString *CityName = [result.addressDetail.city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    if (m_data.count>0)
    {
        [selectCityButton setTitle: [m_data objectForKey:@"name"] forState: UIControlStateNormal];
     }else{
        [selectCityButton setTitle: CityName forState: UIControlStateNormal];
         m_city_name  =CityName;
    }
    [m_tab refreshStart];
    //[self.m_tab reloadData];
    self.view.userInteractionEnabled = YES;
    //BMKReverseGeoCodeResult是编码的结果，包括地理位置，道路名称，uid，城市名等信息
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
    NSInteger numberOfRowsInSection = m_CommunitylistON.count+m_CommunitylistOF.count;
    if (numberOfRowsInSection == 0) {
        self.m_tab.tableFooterView.hidden = NO;
    }
    else {
        self.m_tab.tableFooterView.hidden = YES;
    }
    return numberOfRowsInSection;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *Community;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Listcell" forIndexPath:indexPath];
    m_lable_name = (UILabel *)[cell.contentView viewWithTag:100];
    m_lable_address = (UILabel *)[cell.contentView viewWithTag:101];
    m_lable_distance = (UILabel *)[cell.contentView viewWithTag:102];
    m_lable_st=(UILabel *)[cell.contentView viewWithTag:103];
    UIColor *color = [UIColor darkTextColor];
    NSString *text = @"未开通";
    color = [UIColor lightGrayColor];
    if (m_CommunitylistON.count > indexPath.row)
    {
        Community=[m_CommunitylistON objectAtIndex:indexPath.row];
        if ([[[NSString alloc]initWithFormat:@"%@",[Community objectForKey:@"enable"]]isEqualToString:@"1"]) {
            text = @"已开通";
            color = [UIColor blackColor];
        }
    }
    else if (m_CommunitylistOF.count > indexPath.row - m_CommunitylistON.count) {
        Community=[m_CommunitylistOF objectAtIndex:indexPath.row - m_CommunitylistON.count];
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
     m_cityinfo = [m_CommunitylistON objectAtIndex:indexPath.row];
    if ([[[NSString alloc]initWithFormat:@"%@",[m_cityinfo objectForKey:@"enable"]]isEqualToString:@"1"])
    {
        [self performSegueWithIdentifier:@"GoLYUserloginView" sender:self];
        
    }else if ([[[NSString alloc]initWithFormat:@"%@",[m_cityinfo objectForKey:@"enable"]]isEqualToString:@"0"])
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
    [NetParameters setValue:[m_data objectForKey:@"id"] forKey:@"city_id"];
    [NetParameters setValue:m_CommunityName forKey:@"name"];
    [NetParameters setValue:[[NSString alloc] initWithFormat:@"%f",longitude]forKey:@"longitude"];
    [NetParameters setValue:[[NSString alloc] initWithFormat:@"%f",latitude]forKey:@"latitude"];
    [NetParameters setValue:[[NSString alloc] initWithFormat:@"%d",m_pageSize]forKey:@"m_pageSize"];
    [NetParameters setValue:[[NSString alloc] initWithFormat:@"%d",m_pageOffset]forKey:@"m_pageOffset"];
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/community/search"
                                                            params:NetParameters
                                                            repeat:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           NSDictionary *data = [result objectForKey:@"data"];
                                                           m_CommunitylistON = [data objectForKey:@"communities"];
                                                           m_CommunitylistOF = [data objectForKey:@"refCommunities"];
                                                       }];
    [self.m_tab reloadData];
    self.view.userInteractionEnabled = YES;
    [m_View removeFromSuperview];
}

#pragma mark - 获取网络数据
//搜索小区
-(void)GetCommunity:(NSString*)URL
{
    int pagesize = 1000;
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
        if ([m_data objectForKey:@"name"]!=nil||m_data!=nil)
        {
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
       // m_pageOffset = [[weatherDic objectForKey:@"pageOffset"] intValue];
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
                m_CommunitylistON = [data1 objectForKey:@"communities"];
                m_CommunitylistOF = [data1 objectForKey:@"refCommunities"];
            }
//          [m_CommunitylistON addObjectsFromArray:CommunitylistON];
//          [m_CommunitylistOF addObjectsFromArray:CommunitylistOF];
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_tab reloadData];
                // 更新UI
            });
          //  [m_tab reloadData];
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
    else if (m_tab.status == AWaterfallTableViewMoring)
    {
        [m_tab moreEnd];
        //m_pageOffset++;
    }
}


- (void)userLocation:(Location *)userLocation
             locInfo:(NSDictionary *)locInfo
{

}


#pragma mark - 切换界面进入协议函数
-(void)viewDidAppear:(BOOL)animated
{
    if (m_Refresh)
    {
        m_pageSize = 1000;
        m_pageOffset = 0;
        m_CommunitylistOF = [[NSMutableArray alloc] init];
        m_CommunitylistON = [[NSMutableArray alloc] init];
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
        //[_selectCityButton setTitle: [m_data objectForKey:@"name"] forState: UIControlStateNormal];
        if(![[m_data objectForKey:@"name"]isEqualToString:m_city_name])
        {
            UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入关键字搜小区" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alview show];
        }
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
   [NSThread detachNewThreadSelector:@selector(GetCommunity:) toTarget:self withObject:nil];
}
- (void)more:(AWaterfallTableView *)tableView
{
    [NSThread detachNewThreadSelector:@selector(GetCommunity:) toTarget:self withObject:nil];
}

@end

