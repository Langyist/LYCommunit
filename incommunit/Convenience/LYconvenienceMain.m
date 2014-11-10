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
#define REDCOLOR colorWithRed:255.0/255.0 green:230.0/255.0 blue:201.0/255.0 alpha:1

@interface LYconvenienceMain ()
{
    UISearchBar *m_deliverSearch;
    UISearchBar *m_shopSearch;
    UISearchBar *m_microShop;
    UIView *background;//
    UIView *grayView;
    
    UIView *shopdownView;
    UIView *shopgrayView;
    
    UIView *m_backView;
    UIView *m_shopView;
    BOOL m_in;
    UITableView *m_backtable;
    UITableView *m_backtable1;
    UITableView *m_shoptable;
    UITableView *m_shoptable1;
    UIButton *m_deviButton;
    UIButton *m_shopButton;
    NSInteger lastIndex;
    NSInteger selectCount;
    NSMutableArray *arrow;
    
    UIView *footerView;
}

@property (nonatomic, strong) XHFriendlyLoadingView *friendlyLoadingView;
@end

@implementation LYconvenienceMain
@synthesize m_textfiled,m_segment,m_view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_pagesize = 5;
    m_pageoffset= 0;
    self->locationManager = [[CLLocationManager alloc] init];
    self->locationManager.delegate = self;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        //[self->locationManager requestWhenInUseAuthorization];
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
    // Do any additional setup after loading the view, typically from a nib.
    if ([CLLocationManager locationServicesEnabled])
    {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        [self->locationManager startUpdatingLocation];
    }
    else
    {
        NSLog(@"请开启定位功能！");
    }
    
    arrow = [[NSMutableArray alloc] init];
    StoreType = @"";
    orderstr  = @"";
    
    self.friendlyLoadingView = [[XHFriendlyLoadingView alloc] initWithFrame:self.view.bounds];
    [self.friendlyLoadingView showFriendlyLoadingViewWithText:@"正在加载..." loadingAnimated:YES];
    [self.view addSubview:self.friendlyLoadingView];
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.m_segment setBackgroundImage:transparentImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.m_segment setTitleTextAttributes:@{
                                             NSForegroundColorAttributeName : [UIColor colorWithRed:63/255.0f green:62/255.0f blue:62/255.0f alpha:1]
                                             }
                                  forState:UIControlStateNormal];
    [self.m_segment setTitleTextAttributes:@{
                                             NSForegroundColorAttributeName : [UIColor colorWithRed:230/255.0f green:163/255.0f blue:44/255.0f alpha:1]
                                             }
                                  forState:UIControlStateSelected];
    
    [LYSqllite CreatShoppingcart];
    m_textfiled.delegate=self;
    [m_segment addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    self._scrollView.contentSize = CGSizeMake(self._scrollView.frame.size.width * 3, self._scrollView.frame.size.height);
    [__scrollView setScrollEnabled:NO];
    //精选
    m_view01 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self._scrollView.frame.size.height)];
    m_Featuredtableview = [[AWaterfallTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self._scrollView.frame.size.height)];
    m_Featuredtableview.dataSource = self;
    m_Featuredtableview.delegate = self;
    m_Featuredtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_Featuredtableview.canRefresh = NO;
    m_Featuredtableview.canMore = NO;
    [m_view01 addSubview:m_Featuredtableview];
    [self._scrollView addSubview:m_view01];
    
    UIImageView *buttonimageView = [[UIImageView alloc] initWithFrame:CGRectMake(148, 14, 10, 10)];
    buttonimageView.image = [UIImage imageNamed:@"小三角_11"];
    [m_segment addSubview:buttonimageView];
    buttonimageView.tag = @"1";
    [arrow addObject:buttonimageView];
    
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
    m_view02 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self._scrollView.frame.size.height)];
    m_Deliverytableview =[[AWaterfallTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    m_Deliverytableview.dataSource = self;
    m_Deliverytableview.delegate = self;
    [m_view02 addSubview:m_Deliverytableview];
    [self._scrollView addSubview:m_view02];
    
  
    m_deliverSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, m_view02.frame.size.width, 40)];
    m_deliverSearch.delegate = self;
    m_deliverSearch.placeholder = @"搜索店铺";
    m_Deliverytableview.tableHeaderView = m_deliverSearch;
    
    //送餐送货下拉菜单View
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, m_view02.frame.size.height)];
    background.backgroundColor = [UIColor clearColor];
    [m_view02 addSubview:background];
    
    m_backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_view02.frame.size.width, self.view.frame.size.height-250)];
    m_backView.backgroundColor = [UIColor whiteColor];
    [background addSubview:m_backView];
    
    grayView = [[UIView alloc] initWithFrame:CGRectMake(0, m_backView.frame.size.height, self.view.frame.size.width, m_view02.frame.size.height - m_backView.frame.size.height)];
    grayView.backgroundColor = [UIColor grayColor];
    grayView.alpha = 0.5;
    [background addSubview:grayView];
    //添加阴影手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clackgrayView)];
    [grayView addGestureRecognizer:gestureRecognizer];
    //中间分割线
    UIImageView *centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(m_backView.frame.size.width /2 - 1, 5, 1, m_backView.frame.size.height - 10)];
    centerImage.image = [UIImage imageNamed:@"上面分割线_03"];
    [m_backView addSubview:centerImage];
    //信息查询tableView
    m_backtable = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, m_backView.frame.size.width / 2 - 1, m_backView.frame.size.height - 55)];
    m_backtable.delegate = self;
    m_backtable.dataSource = self;
    m_backtable.backgroundColor = [UIColor whiteColor];
    m_backtable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [m_backView addSubview:m_backtable];
    
    m_backtable1 = [[UITableView alloc] initWithFrame:CGRectMake(m_backView.frame.size.width / 2, 30, m_backView.frame.size.width / 2, m_backView.frame.size.height - 65)];
    m_backtable1.delegate = self;
    m_backtable1.dataSource = self;
    m_backtable1.backgroundColor = [UIColor whiteColor];
    m_backtable1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [m_backView addSubview:m_backtable1];
    
    UIButton *m_backButton = [[UIButton alloc] initWithFrame:CGRectMake(m_backView.frame.size.width - 40, m_backView.frame.size.height - 40, 30, 30)];
    [m_backButton setImage:[UIImage imageNamed:@"ic_dismiss"] forState:UIControlStateNormal];
    [m_backButton addTarget:self action:@selector(downBackViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [m_backView addSubview:m_backButton];
    
    for (int i = 0; i < 2; i ++) {
        NSArray *labelarray = [NSArray arrayWithObjects:@"信息查询",@"排列顺序", nil];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5 + m_backView.frame.size.width / 2 * i, 5, m_backView.frame.size.width / 2 - 5, 25)];
        label.text = labelarray[i];
        label.font = [UIFont systemFontOfSize:16];
        [m_backView addSubview:label];
    }
//    m_Deliverytableview.tableFooterView = footerView;
    /*
     店铺大全
     */
    m_view03 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self._scrollView.frame.size.width, self._scrollView.frame.size.height)];
    m_ShopDaquan = [[AWaterfallTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self._scrollView.frame.size.height)];
    m_ShopDaquan.dataSource = self;
    m_ShopDaquan.delegate = self;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(m_view03.frame.size.width/3+10, m_view03.frame.size.height/3, 80, 80)];
    [imageview setImage:[UIImage imageNamed:@"ic_default_no_data.png"]];
    [m_view03 addSubview:imageview];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(m_view03.frame.size.width/3, m_view03.frame.size.height/3+imageview.frame.size.height, 200, 30)];
    lable.text = @"没有加载到数据";
    lable.textColor = [UIColor orangeColor];
    [lable setFont:[UIFont systemFontOfSize:15]];
    [m_view03 addSubview:lable];
    [m_view03 addSubview:m_ShopDaquan];
    [self._scrollView addSubview:m_view03];
    
    UIImageView *shopimageView = [[UIImageView alloc] initWithFrame:CGRectMake(228, 14, 10, 10)];
    shopimageView.image = [UIImage imageNamed:@"小三角_11"];
    shopimageView.tag = @"2";
    [arrow addObject:shopimageView];
    [m_segment addSubview:shopimageView];
    //搜索
    m_shopSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, m_view03.frame.size.width, 40)];
    m_shopSearch.delegate = self;
    m_shopSearch.placeholder = @"搜索店铺";
    m_ShopDaquan.tableHeaderView = m_shopSearch;
    
    //店铺大全下拉菜单
    
    shopdownView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_view03.frame.size.width, m_view03.frame.size.height)];
    shopdownView.backgroundColor = [UIColor clearColor];
    [m_view03 addSubview:shopdownView];
    
    m_shopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_view03.frame.size.width, m_view03.frame.size.height / 5 *3)];
    m_shopView.backgroundColor = [UIColor whiteColor];
    [shopdownView addSubview:m_shopView];
    
    shopgrayView = [[UIView alloc] initWithFrame:CGRectMake(0, m_shopView.frame.size.height, shopdownView.frame.size.width, shopdownView.frame.size.height - m_shopView.frame.size.height)];
    shopgrayView.backgroundColor = [UIColor grayColor];
    shopgrayView.alpha = 0.5;
    [shopdownView addSubview:shopgrayView];
    
    //添加阴影手势
    UITapGestureRecognizer *shopgestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopclackgrayView)];
    [shopgrayView addGestureRecognizer:shopgestureRecognizer];
    
    //中间分割线
    UIImageView *shopcenterImage = [[UIImageView alloc] initWithFrame:CGRectMake(m_shopView.frame.size.width /2 - 1, 5, 1, m_shopView.frame.size.height - 30)];
    shopcenterImage.image = [UIImage imageNamed:@"上面分割线_03"];
    [m_shopView addSubview:shopcenterImage];
    //下拉tableView
    m_shoptable = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, m_shopView.frame.size.width / 2 - 1, m_shopView.frame.size.height -55)];
    m_shoptable.delegate = self;
    m_shoptable.dataSource = self;
    m_shoptable.backgroundColor = [UIColor whiteColor];
    m_shoptable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [m_shopView addSubview:m_shoptable];
    
    m_shoptable1 = [[UITableView alloc] initWithFrame:CGRectMake(m_shopView.frame.size.width / 2, 30, m_shopView.frame.size.width / 2, m_shopView.frame.size.height -55)];
    m_shoptable1.delegate = self;
    m_shoptable1.dataSource = self;
    m_shoptable1.backgroundColor = [UIColor whiteColor];
    m_shoptable1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [m_shopView addSubview:m_shoptable1];
    //关闭弹出框
    UIButton *m_shopdownButton = [[UIButton alloc] initWithFrame:CGRectMake(m_shopView.frame.size.width- 40, m_shopView.frame.size.height - 40, 30, 30)];
    [m_shopdownButton setImage:[UIImage imageNamed:@"ic_dismiss"] forState:UIControlStateNormal];
    [m_shopdownButton addTarget:self action:@selector(shopdownBackViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [m_shopView addSubview:m_shopdownButton];
    
    for (int i = 0; i < 2; i ++)
    {
        NSArray *labelarray = [NSArray arrayWithObjects:@"信息查询",@"排列顺序", nil];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5 + m_shopView.frame.size.width / 2 * i, 5, m_shopView.frame.size.width / 2 - 5, 25)];
        label.text = labelarray[i];
        label.font = [UIFont systemFontOfSize:16];
        [m_shopView addSubview:label];
    }
    
    /*
     小区微店
     */
    m_view04 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 3, 0, self._scrollView.frame.size.width, self._scrollView.frame.size.height)];
    m_CellmicroShop = [[AWaterfallTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self._scrollView.frame.size.height)];
    m_CellmicroShop.dataSource = self;
    m_CellmicroShop.delegate = self;
    [m_view04 addSubview:m_CellmicroShop];
    [self._scrollView addSubview:m_view04];
    //搜索
    m_microShop = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, m_view04.frame.size.width, 40)];
    m_microShop.delegate = self;
    m_microShop.placeholder = @"搜索店铺";
    m_CellmicroShop.tableHeaderView = m_microShop;
    
    m_Deliverytableview = [self addTableViewWithIndex:1];
    m_ShopDaquan = [self addTableViewWithIndex:2];
    m_CellmicroShop = [self addTableViewWithIndex:3];
    CGSize size = CGSizeMake(CGRectGetMaxX(m_CellmicroShop.frame), 0);
    [self._scrollView setContentSize:size];
    
    //切换页面手势
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view01leftSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [m_view01 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view02leftSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [m_view02 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view02rightSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [m_view02 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view03leftSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [m_view03 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view03rightSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [m_view03 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view04rightSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [m_view04 addGestureRecognizer:recognizer];

}

- (AWaterfallTableView *)addTableViewWithIndex:(NSInteger)index {
    AWaterfallTableView *tableView = [m_Featuredtableview clone];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.canRefresh = NO;
    tableView.canMore = NO;
    
    tableView.tableFooterView = [footerView clone];
    
    CGRect frame = m_Featuredtableview.frame;
    frame.origin.x = frame.size.width * index;
    tableView.frame = frame;
    
    [self._scrollView addSubview:tableView];
    
    return tableView;
}
//点击阴影关闭弹出框
- (void)clackgrayView {
    
    background.hidden = YES;
}

//点击阴影关闭弹出框
- (void)shopclackgrayView {
    
    shopdownView.hidden = YES;
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
#pragma mark -- 界面切换
-(void)m_view01leftSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self._scrollView setContentOffset:CGPointMake(1* self.view.frame.size.width,0) animated:YES];
            
            background.hidden = YES;
            m_segment.selectedSegmentIndex = 1;
            if (m_Deliverylist.count<1) {
                
            }
        }];}
    }
}

-(void)m_view02leftSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self._scrollView setContentOffset:CGPointMake(2* self.view.frame.size.width,0) animated:YES];
            shopdownView.hidden = YES;
            m_segment.selectedSegmentIndex = 2;
            if (m_ShopDaquanlist.count<1) {
            }
        }];}
    }
}

-(void)m_view02rightSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self._scrollView setContentOffset:CGPointMake(0* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 0;
        }];}
    }
}

-(void)m_view03leftSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self._scrollView setContentOffset:CGPointMake(3* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 3;
            if (m_CellmicroShoplist.count<1) {
                
            }
        }];}
    }
}

-(void)m_view03rightSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self._scrollView setContentOffset:CGPointMake(1* self.view.frame.size.width,0) animated:YES];
            
            background.hidden = YES;
            m_segment.selectedSegmentIndex = 1;
        }];}
    }
}

-(void)m_view04rightSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        { [UIView animateWithDuration:0.3 animations:^{
            [self._scrollView setContentOffset:CGPointMake(2* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 2;
        }];}
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Plain Segmented Control 协议函数
-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    for (UIImageView *imageView in arrow) {
        if ([imageView.tag integerValue] == Seg.selectedSegmentIndex) {
            [imageView setImage:[UIImage imageNamed:@"黄色小三角_03"]];
        }
        else {
            [imageView setImage:[UIImage imageNamed:@"小三角_11"]];
        }
    }
    
    background.hidden = YES;
    shopdownView.hidden = YES;
    [m_deviButton removeFromSuperview];
    [m_shopButton removeFromSuperview];
    
    switch (Seg.selectedSegmentIndex)
    {
        case 0:
        {
            [self._scrollView setContentOffset:CGPointMake(0* self.view.frame.size.width,0) animated:YES];
        }
            break;
        case 1:
        {
            [self._scrollView setContentOffset:CGPointMake(1* self.view.frame.size.width,0) animated:YES];
            background.hidden = YES;
            
            m_deviButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 67, 80, 29)];
            m_deviButton.backgroundColor = [UIColor clearColor];
            [m_deviButton addTarget:self action:@selector(m_deviButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            m_in = YES;
            [self.view addSubview:m_deviButton];
            
            if(m_Deliverylist.count<1)
            {
                    [self GetdataDelivery];
            }
            
        }
            break;
        case 2:
        {
            [self._scrollView setContentOffset:CGPointMake(2* self.view.frame.size.width,0) animated:YES];
            shopdownView.hidden = YES;
            m_shopButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 67, 80, 29)];
            m_shopButton.backgroundColor = [UIColor clearColor];
            [m_shopButton addTarget:self action:@selector(m_shopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            m_in = YES;
            [self.view addSubview:m_shopButton];
            
        }
            break;
        case 3:
        {
            [self._scrollView setContentOffset:CGPointMake(3* self.view.frame.size.width,0) animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    lastIndex = Seg.selectedSegmentIndex;
}

- (void)m_deviButtonPressed:(id *)sender {
    if (m_segment.selectedSegmentIndex == 1) {
        
        if (m_in) {
            
            background.hidden = NO;
            m_in = NO;
            
        }else {
            
            background.hidden = YES;
            m_in = YES;
        }
    }else if (m_segment.selectedSegmentIndex == 0) {
        
        m_deviButton.hidden = YES;
        m_in = YES;
    }else if (m_segment.selectedSegmentIndex == 2) {
        m_deviButton.hidden = YES;
        m_in = YES;
    }else if (m_segment.selectedSegmentIndex == 3) {
        m_deviButton.hidden = YES;
        m_in = YES;
    }
    
}

- (void)m_shopButtonPressed:(id *)sender {
    if (m_segment.selectedSegmentIndex == 2) {
        
        if (m_in) {
            
            shopdownView.hidden = NO;
            m_in = NO;
            
        }else {
            
            shopdownView.hidden = YES;
            m_in = YES;
        }
    }else if (m_segment.selectedSegmentIndex == 0) {
        
        m_shopButton.hidden = YES;
        m_in = YES;
    }else if (m_segment.selectedSegmentIndex == 1) {
        m_shopButton.hidden = YES;
        m_in = YES;
    }else if (m_segment.selectedSegmentIndex == 3) {
        m_shopButton.hidden = YES;
        m_in = YES;
    }
    
}

- (void)downBackViewButton:(UIButton *)sender {
    
    if (sender.tag == 1)
    {
        dispatch_queue_t groupBack=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(groupBack, ^{
            [self GetdataDelivery];
        });
    }
    background.hidden = YES;
}

- (void)shopdownBackViewButton:(UIButton *)sender
{
    shopdownView.hidden = YES;
}
#pragma mark - tableview 协议函数
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == m_Featuredtableview )
    {
        NSInteger numberOfRowsInSection = m_Featuredlist.count;
        if (numberOfRowsInSection == 0) {
            m_Featuredtableview.tableFooterView.hidden = NO;
        }
        else {
            m_Featuredtableview.tableFooterView.hidden = YES;
        }
        return numberOfRowsInSection;
        
    }else if(tableView == m_Deliverytableview)
    {
        NSInteger numberOfRowsInSection = m_Deliverylist.count;
        if (numberOfRowsInSection == 0) {
            m_Deliverytableview.tableFooterView.hidden = NO;
        }
        else {
            m_Deliverytableview.tableFooterView.hidden = YES;
        }
        return numberOfRowsInSection;
        
    }if (tableView == m_ShopDaquan) {
        
        NSInteger numberOfRowsInSection = m_ShopDaquanlist.count;
        if (numberOfRowsInSection == 0) {
            m_ShopDaquan.tableFooterView.hidden = NO;
        }
        else {
            m_ShopDaquan.tableFooterView.hidden = YES;
        }
        return numberOfRowsInSection;
    }if (tableView == m_CellmicroShop) {
        
        NSInteger numberOfRowsInSection = m_CellmicroShoplist.count;
        if (numberOfRowsInSection == 0) {
            m_CellmicroShop.tableFooterView.hidden = NO;
        }
        else {
            m_CellmicroShop.tableFooterView.hidden = YES;
        }
        return numberOfRowsInSection;
    }
    else if (tableView == m_backtable) {
        
        return 3;
    }else if (tableView == m_backtable1)
    {
        return 3;
    }else if (tableView == m_shoptable) {
        
        return m_shoptypelist.count + 1;
    }else if (tableView == m_shoptable1) {
        
        return 3;
    }
    else
    {
        return 0;
    }
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == m_Featuredtableview)
    {
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"FeaturedCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"FeaturedCellidentifier"];
            nibsRegistered = YES;
        }
        NSDictionary *Featinfo = [m_Featuredlist objectAtIndex:indexPath.row];
        LY_FeaturedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeaturedCellidentifier"];
        NSString *imageUrl = [Featinfo objectForKey:@"cool_path"];
        if (imageUrl!=nil && ![imageUrl isEqualToString:@""]) {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [cell.m_imageview setImageWithURL:url placeholderImage:nil];
        }
        return cell;
    }else if (tableView == m_Deliverytableview)
    {
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"DeliveryCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"DeliveryCellidentifiter"];
            nibsRegistered = YES;
        }
        NSDictionary *Featinfo = [m_Deliverylist objectAtIndex:indexPath.row];
        LY_DeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryCellidentifiter"];
        cell.m_imageview.layer.cornerRadius = 3;
        cell.m_imageview.clipsToBounds = YES;
        NSString *imageUrl = [Featinfo objectForKey:@"logo"];
        if (imageUrl!=nil && ![imageUrl isEqualToString:@""])
        {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [cell.m_imageview setImageWithURL:url placeholderImage:nil];
        }
        [cell setStoreName:[Featinfo objectForKey:@"name"]];
        [cell setCallNumber:[[Featinfo objectForKey:@"call_number"] integerValue]];
        [cell setDistance:[[Featinfo objectForKey:@"distance"] integerValue]];
        if ([[[NSString alloc] initWithFormat:@"%@",[Featinfo objectForKey:@"sendable"]]isEqualToString:@"1"]) {
            cell.m_sendable.text = [NSString stringWithFormat:@"支持配送/%@", [Featinfo objectForKey:@"send_info"]];
        }else
        {
            cell.m_sendable.text = [NSString stringWithFormat:@"不支持配送/%@", [Featinfo objectForKey:@"send_info"]];
        }
        if ([[[NSString alloc] initWithFormat:@"%@",[Featinfo objectForKey:@"hui"]] isEqualToString:@"1"]) {
            cell.m_hui.hidden = NO;
        }else
        {
            cell.m_hui.hidden = YES;
        }
        return cell;
    }else if (tableView == m_ShopDaquan)
    {
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"DeliveryCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"DeliveryCellidentifiter"];
            nibsRegistered = YES;
        }
        NSDictionary *Featinfo = [m_ShopDaquanlist objectAtIndex:indexPath.row];
        LY_DeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryCellidentifiter"];
        cell.m_imageview.layer.cornerRadius = 3;
        cell.m_imageview.clipsToBounds = YES;
        NSString *imageUrl = [Featinfo objectForKey:@"logo"];
        if (imageUrl!=nil && ![imageUrl isEqualToString:@""])
        {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [cell.m_imageview setImageWithURL:url placeholderImage:nil];
        }
        [cell setStoreName:[Featinfo objectForKey:@"name"]];
        [cell setCallNumber:[[Featinfo objectForKey:@"call_number"] integerValue]];
        [cell setDistance:[[Featinfo objectForKey:@"distance"] integerValue]];
        if ([[[NSString alloc] initWithFormat:@"%@",[Featinfo objectForKey:@"sendable"]]isEqualToString:@"1"]) {
            cell.m_sendable.text = [NSString stringWithFormat:@"支持配送/%@", [Featinfo objectForKey:@"send_info"]];
        }else
        {
            cell.m_sendable.text = [NSString stringWithFormat:@"不支持配送/%@", [Featinfo objectForKey:@"send_info"]];
        }
        if ([[[NSString alloc] initWithFormat:@"%@",[Featinfo objectForKey:@"hui"]] isEqualToString:@"1"]) {
            cell.m_hui.hidden = NO;
        }else
        {
            cell.m_hui.hidden = YES;
        }
        return cell;
    }else if (tableView == m_CellmicroShop)
    {
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"DeliveryCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"DeliveryCellidentifiter"];
            nibsRegistered = YES;
        }
        NSDictionary *Featinfo = [m_CellmicroShoplist objectAtIndex:indexPath.row];
        LY_DeliveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryCellidentifiter"];
        cell.m_imageview.layer.cornerRadius = 3;
        cell.m_imageview.clipsToBounds = YES;
        NSString *imageUrl = [Featinfo objectForKey:@"logo"];
        if (imageUrl!=nil && ![imageUrl isEqualToString:@""])
        {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [cell.m_imageview setImageWithURL:url placeholderImage:nil];
        }
        [cell setStoreName:[Featinfo objectForKey:@"name"]];
        [cell setCallNumber:[[Featinfo objectForKey:@"call_number"] integerValue]];
        [cell setDistance:[[Featinfo objectForKey:@"distance"] integerValue]];
        if ([[[NSString alloc] initWithFormat:@"%@",[Featinfo objectForKey:@"sendable"]]isEqualToString:@"1"]) {
            cell.m_sendable.text = [NSString stringWithFormat:@"支持配送/%@", [Featinfo objectForKey:@"send_info"]];
        }else
        {
            cell.m_sendable.text = [NSString stringWithFormat:@"不支持配送/%@", [Featinfo objectForKey:@"send_info"]];
        }
        if ([[[NSString alloc] initWithFormat:@"%@",[Featinfo objectForKey:@"hui"]] isEqualToString:@"1"]) {
            cell.m_hui.hidden = YES;
        }else
        {
            cell.m_hui.hidden = NO;
        }
        return cell;
    }
    else if (tableView ==  m_backtable ) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"m_backtablecell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"m_backtablecell"];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"全部";
                break;
            case 1:
                cell.textLabel.text = @"餐饮及水果";
                break;
            case 2:
                cell.textLabel.text = @"超市及百货";
                break;
            default:
                break;
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *m_cellbackView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        m_cellbackView.backgroundColor = [UIColor REDCOLOR];
        cell.selectedBackgroundView = m_cellbackView;
        return cell;
    }
    else if (tableView ==  m_backtable1 ) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"m_backtablecell1"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"m_backtablecell1"];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"智能排序";
                break;
            case 1:
                cell.textLabel.text = @"拨打次数排序";
                break;
            case 2:
                cell.textLabel.text = @"距离排序";
                break;
            default:
                break;
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *m_cellbackView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        m_cellbackView.backgroundColor = [UIColor REDCOLOR];
        cell.selectedBackgroundView = m_cellbackView;
        return cell;
    }
    else if (tableView ==  m_shoptable ) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"m_shoptablecell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"m_shoptablecell"];
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"所有";
        }
        else
        {
            NSDictionary * temp = [m_shoptypelist objectAtIndex:indexPath.row-1];
            cell.textLabel.text = [temp objectForKey:@"name"];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *m_cellbackView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        m_cellbackView.backgroundColor = [UIColor REDCOLOR];
        cell.selectedBackgroundView = m_cellbackView;
        return cell;
    }
    else if (tableView == m_shoptable1) {
        
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"m_shoptablecell1"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"m_shoptablecell1"];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"智能排序";
                break;
            case 1:
                cell.textLabel.text = @"拨打次数排序";
                break;
            case 2:
                cell.textLabel.text = @"距离排序";
                break;
            default:
                break;
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        UIView *m_cellbackView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        m_cellbackView.backgroundColor = [UIColor REDCOLOR];
        cell.selectedBackgroundView = m_cellbackView;
        //默认选中第一行
//        [m_shoptable1 selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        return cell;
    }
    else
    {
        return nil;
    }
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == m_Featuredtableview) {
        NSDictionary *Featinfo = [m_Featuredlist objectAtIndex:indexPath.row];
        m_Storesid = [[NSString alloc]initWithFormat:@"%@",[Featinfo objectForKey:@"shop_id"]];
        [self performSegueWithIdentifier:@"Gostoresinfo" sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else if(tableView ==m_Deliverytableview)
    {
        NSDictionary *Featinfo = [m_Deliverylist objectAtIndex:indexPath.row];
        m_Storesid = [[NSString alloc]initWithFormat:@"%@",[Featinfo objectForKey:@"id"]];
        [self performSegueWithIdentifier:@"Gostoresinfo" sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else if (tableView == m_ShopDaquan)
    {
        NSDictionary *Featinfo = [m_ShopDaquanlist objectAtIndex:indexPath.row];
        m_Storesid = [[NSString alloc]initWithFormat:@"%@",[Featinfo objectForKey:@"id"]];
        [self performSegueWithIdentifier:@"Gostoresinfo" sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else if (tableView == m_CellmicroShop)
    {
        
        NSDictionary *Featinfo = [m_CellmicroShoplist objectAtIndex:indexPath.row];
        m_Storesid = [[NSString alloc]initWithFormat:@"%@",[Featinfo objectForKey:@"id"]];
        [self performSegueWithIdentifier:@"Gostoresinfo" sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }else if(tableView == m_backtable||tableView ==  m_shoptable)
    {
        if (indexPath.row == 0) {
            StoreType = @"";
        }else
        {
            NSDictionary * temp  = [m_shoptypelist objectAtIndex:indexPath.row-1];
            StoreType = [temp objectForKey:@"id"];
        }
    }else if(tableView == m_backtable1||tableView == m_shoptable1)
    {
        switch (indexPath.row) {
            case 0:
                orderstr = @"1";
                break;
            case 1:
                orderstr = @"2";
                break;
            case 2:
                orderstr = @"3";
            default:
                break;
        }
    }
    
    
    NSUInteger row = [indexPath row];
    NSLog(@"%lu",(unsigned long)row);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == m_Featuredtableview)
    {
        return 138;
    }else if (tableView == m_Deliverytableview)
    {
        return 79;
    } if (tableView == m_ShopDaquan)
    {
        return 79;
    }if (tableView == m_CellmicroShop)
    {
        return 79;
    }
    else
    {
        return 40;
    }
}

//tableView滚动事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == m_Deliverytableview) {
        [m_deliverSearch resignFirstResponder];
    }
    else if (scrollView == m_ShopDaquan) {
        
        [m_shopSearch resignFirstResponder];
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
-(IBAction)GetdataDelivery
{
    
    NSDictionary *dic = @{@"sendable" : @"1"
                          ,@"order" : orderstr
                          ,@"longitude" : [[NSString alloc] initWithFormat:@"%f",longitude]
                          ,@"latitude" : [[NSString alloc] initWithFormat:@"%f",latitude]
                          ,@"pagesize" : [[NSString alloc] initWithFormat:@"%d",m_pagesize]
                          ,@"pageoffset" : [[NSString alloc] initWithFormat:@"%d",m_pageoffset]
                          ,@"type_id" :StoreType };
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
-(IBAction)GetShopDaquandata
{
    NSDictionary *dic = @{@"category" : @"1"
                          ,@"order" : orderstr
                          ,@"longitude" : [[NSString alloc] initWithFormat:@"%f",longitude]
                          ,@"latitude" : [[NSString alloc] initWithFormat:@"%f",latitude]
                          ,@"pagesize" : [[NSString alloc] initWithFormat:@"%d",m_pagesize]
                          ,@"pageoffset" : [[NSString alloc] initWithFormat:@"%d",m_pageoffset]
                          ,@"type_id" :StoreType };
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

-(IBAction)GetCellmicroShopdata
{

    NSDictionary *dic = @{@"category" : @"2"
                          ,@"order" : orderstr
                          ,@"longitude" : [[NSString alloc] initWithFormat:@"%f",longitude]
                          ,@"latitude" : [[NSString alloc] initWithFormat:@"%f",latitude]
                          ,@"pagesize" : [[NSString alloc] initWithFormat:@"%d",m_pagesize]
                          ,@"pageoffset" : [[NSString alloc] initWithFormat:@"%d",m_pageoffset]
                          ,@"type_id" :StoreType };
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
-(IBAction)GetShoptype
{
    NSDictionary *dic = @{};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/shop/type"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               NSLog(@"error %@",errorMsg);
                                                           }else
                                                           {
                                                               m_shoptypelist =result;
                                                               [m_backtable reloadData];
                                                           }
                                                       }];
   [self.friendlyLoadingView hideLoadingView];
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
    m_tempb =searchBar;
}

@end
