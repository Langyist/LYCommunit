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
#import "LYFunctionInterface.h"
@interface LYSelectCommunitCell : UITableViewCell
{
    NSString *Cityname;
}
@end
static  NSString *    m_city_name;
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
    NSMutableDictionary *userinfo =  [LYSqllite Ruser];
    NSMutableDictionary *communitInfo = [LYSqllite currentCommnit];
    if (userinfo != nil && m_bl ==FALSE && ![[userinfo objectForKey:@"auth_status"] isEqualToString:@"-2"] && [[communitInfo objectForKey:@"community_id"] length])
    {
        m_cityinfo = communitInfo;
        [LYFunctionInterface Setcommunitinfo:m_cityinfo];
        [self login:[userinfo objectForKey:@"user"] password:[userinfo objectForKey:@"password"] communitID:[communitInfo objectForKey:@"community_id"]];
    }
    [super viewDidLoad];
    firstloc = TRUE;
    m_Refresh = FALSE;
    m_CommunitylistOF = [[NSMutableArray alloc]init];
    m_CommunitylistON = [[NSMutableArray alloc]init];
    m_data = [[NSMutableDictionary alloc] init];
    m_pagenumber = 0;
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.m_tab.frame), 1)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    footerView.clipsToBounds = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 101, 83, 95)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [imageView setImage:[UIImage imageNamed:@"周边便民--未开店--帮帮娃_03"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(139, 107, 160, 89)];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    [label setText:@"亲，帮帮娃已玩命搜索，未找到你要的小区"];
    label.font = [UIFont boldSystemFontOfSize:15.0f];
    label.textColor = SPECIAL_GRAY;
    
    [footerView addSubview:imageView];
    [footerView addSubview:label];
    
    [self.m_tab setBackgroundColor:BK_GRAY];
    [self.view addSubview:footerView];
    footerView.hidden = YES;
    m_pageSize = 10;
    m_pageOffset = 0;
    self->Serch.delegate=self;
    [selectCityButton addTarget:self action:@selector(GoselectCity) forControlEvents:UIControlEventTouchUpInside];
    [selectCityButton setTitle: @"成都" forState: UIControlStateNormal];
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
        [m_data setValue:CityName forKey:@"name"];
        m_city_name  =CityName;
    }
    [m_tab refreshStart];
    self.view.userInteractionEnabled = YES;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *communitInfo = [m_CommunitylistON objectAtIndex:indexPath.row];
    m_cityinfo = @{
                   @"city_id" : @""
                   ,@"community_id" : [communitInfo objectForKey:@"id"]
                   ,@"communitname" : [communitInfo objectForKey:@"name"]
                   ,@"communitaddress" : [communitInfo objectForKey:@"address"]
                   ,@"communitdistance" : [communitInfo objectForKey:@"distance"]
                   ,@"communitmax_level" : [communitInfo objectForKey:@"max_level"]
                   };
    if ([[[NSString alloc]initWithFormat:@"%@", [communitInfo objectForKey:@"enable"]] isEqualToString:@"1"]) {
        
        NSMutableDictionary * userinfo = [[NSMutableDictionary alloc] init];
        userinfo = [LYSqllite Ruser];
        // TUDO: 检查是否登录
        if (nil == userinfo || [[userinfo objectForKey:@"auth_stauts"] isEqualToString:@"-2"]) {
            [self performSegueWithIdentifier:@"GoLYUserloginView" sender:nil];
        }
        else {
            [self login:[userinfo objectForKey:@"user"] password:[userinfo objectForKey:@"password"] communitID:[[m_cityinfo objectForKey:@"community_id"] stringValue]];
        }
    }
    else if ([[[NSString alloc]initWithFormat:@"%@", [communitInfo objectForKey:@"enable"]] isEqualToString:@"0"]) {
        
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
    m_CommunitylistON = [[NSMutableArray alloc] init];
    m_CommunitylistOF = [[NSMutableArray alloc] init];
    [self GetCommunity:TRUE];
}

//搜索小区
-(void)GetCommunity:(BOOL)serchbarOn
{
    NSDictionary *dic;
    m_CommunityName = Serch.text;
    [Serch resignFirstResponder];
    NSString *Key =@"city_id";
    NSString * key;
    if (m_data) {
        if (m_data.count>1) {
            Key = @"city_id";
            key = @"id";
        }else if (m_data.count>0)
        {
            Key = @"city_name";
            key = @"name";
            m_city_name =[m_data objectForKey:@"name"];
        }
    }
    if(m_data.count>0)
    {
        dic = @{Key : [m_data objectForKey:key]
                ,@"name" : m_CommunityName
                ,@"longitude" : [[NSString alloc] initWithFormat:@"%f",longitude]
                ,@"latitude" : [[NSString alloc] initWithFormat:@"%f",latitude]
                ,@"pageSize" : [[NSString alloc] initWithFormat:@"%d",m_pageSize]
                ,@"pageOffset" : [[NSString alloc] initWithFormat:@"%d",m_pageOffset]
                };
    }
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/community/search"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:NO
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               m_CommunitylistON = [[NSMutableArray alloc] init];
                                                               m_CommunitylistOF = [[NSMutableArray alloc] init];
                                                               if (m_tab.status== AWaterfallTableViewRefreshing )
                                                               {
                                                                   [m_tab reloadData];
                                                                   [m_tab refreshEnd];
                                                               }else if (m_tab.status == AWaterfallTableViewMoring)
                                                               {
                                                                   [m_tab reloadData];
                                                                   [m_tab moreEnd];
                                                               }
                                                               UIAlertView *msalview = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                               [msalview show];
                                                           }else if(bValidJSON)
                                                           {
                                                               CommunitylistON = [result objectForKey:@"communities"];
                                                               CommunitylistOF = [result objectForKey:@"refCommunities"];
                                                               if(CommunitylistON.count>0)
                                                               {
                                                                   m_tab.hidden = NO;
                                                                   footerView.hidden = YES;
                                                                   //m_pageOffset = []
                                                                   [m_CommunitylistON addObjectsFromArray:CommunitylistON];
                                                                   [m_CommunitylistOF addObjectsFromArray:CommunitylistOF];
                                                                   [m_tab reloadData];
                                                                   if (m_tab.status== AWaterfallTableViewRefreshing )
                                                                   {
                                                                       [m_tab reloadData];
                                                                       [m_tab refreshEnd];
                                                                   }else if (m_tab.status == AWaterfallTableViewMoring)
                                                                   {
                                                                       [m_tab reloadData];
                                                                       [m_tab moreEnd];
                                                                   }
                                                               }else if(serchbarOn)
                                                               {
                                                                   m_tab.hidden = YES;
                                                                   footerView.hidden = NO;
                                                               }
                                                           }
                                                       }];
}

- (void)userLocation:(Location *)userLocation
             locInfo:(NSDictionary *)locInfo
{
    
}

#pragma mark - 切换界面进入协议函数
-(void)viewDidAppear:(BOOL)animated
{
    self->locationManager = [[CLLocationManager alloc] init];
    self->locationManager.delegate = self;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        [self->locationManager requestWhenInUseAuthorization];
    }
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    //启动LocationService
    [locService startUserLocationService];
    self->locationManager.desiredAccuracy = kCLLocationAccuracyBest;
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
    
    m_CommunitylistOF = [[NSMutableArray alloc] init];
    m_CommunitylistON = [[NSMutableArray alloc] init];
    footerView.hidden = YES;
    if (!firstloc)
    {
        m_data = [LYSelectCity CityInfo];
        if (m_Refresh)
        {
            m_pageOffset = 0;
            if ([CLLocationManager locationServicesEnabled])
            {
                [self->locationManager startUpdatingLocation];
            }
            else
            {
                NSLog(@"请开启定位功能！");
            }
            m_CommunityName = @"";
            Serch.text= @"";
            [m_tab refreshStart];
            Serch.placeholder = @"搜索小区";
            m_Refresh = NO;
        }else if(m_data.count>0)
        {
            Serch.text= @"";
            Serch.placeholder = @"输入关键字搜索";
        }else if(m_data.count<1)
        {
            Serch.placeholder = @"搜索小区";
            [m_data setValue:m_city_name forKey:@"name"];
            [m_tab refreshStart];
        }
    }
    [self.m_tab reloadData];
    firstloc = FALSE;
}

- (void)refresh:(AWaterfallTableView *)tableView
{
    m_CommunitylistON = [[NSMutableArray alloc] init];
    m_CommunitylistOF = [[NSMutableArray alloc] init];
    m_pageOffset = 0;
    [self GetCommunity:FALSE];
}
- (void)more:(AWaterfallTableView *)tableView
{
    if(CommunitylistON.count==m_pageSize)
    {
        m_pagenumber++;
        m_pageOffset = m_pageSize*m_pagenumber;
        [self GetCommunity:FALSE];
    }
}

//login 登录函数
-(void)login:(NSString*)user password:(NSString *)password communitID:(NSString *)Communitid
{
    user = [user length] ? user : @"";
    password = [password length] ? password : @"";
    Communitid = [Communitid length] ? Communitid : @"";
    
    NSMutableDictionary * userinfo = [[NSMutableDictionary alloc] init];
    
    [userinfo setValue:user forKey:@"user"];
    [userinfo setValue:password forKey:@"password"];
    
    // 登录结果处理
    AnalyzeResponseResult result = ^(BOOL bValidJSON, NSString *errorMsg, id result) {
        if(!bValidJSON) {
            [self performSegueWithIdentifier:@"GoLYUserloginView" sender:nil];
        }
        else {
            [LYSqllite WriteComunitInfo:m_cityinfo];
            
            [userinfo setValue:[[result objectForKey:@"user_id"] stringValue] forKey:@"user_id"];
            [userinfo setValue:[[result objectForKey:@"auth_status"] stringValue] forKey:@"auth_status"];

            [LYSqllite  wuser:userinfo];
            BOOL isMember = YES;
            if ([[userinfo objectForKey:@"auth_status"] isEqualToString:@"-1"]) {
                isMember = NO;
            }
            if (isMember) {
                [LYFunctionInterface Setcommunitinfo:m_cityinfo];
                [self performSegueWithIdentifier:@"Gomain4" sender:self];
            }
            else {
                [self performSegueWithIdentifier:@"GoLYaddCommunit" sender:self];
            }
        }
    };
    
    // 登录请求
    NSDictionary *loginInfo = @{
                                @"username" : user
                                ,@"password" : password
                                ,@"community_id" : Communitid
                                };
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/login"
                                                            params:loginInfo
                                                            repeat:YES
                                                             isGet:NO
                                                          activity:YES
                                                       resultBlock:result];
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
@end

