//
//  LYFunctionInterface.m
//  incommunit
//  功能主界面
//  Created by LANGYI on 14/10/26.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYFunctionInterface.h"
#import "LYSelectCommunit.h"
#import "CustomToolbarItem.h"
#import "LYUserloginView.h"
#import "StoreOnlineNetworkEngine.h"
#import "Sqllite/LYSqllite.h"
@interface LYFunctionInterface () {
    UIBarButtonItem *mapItem;
    UIBarButtonItem *mineItem;
    UIBarButtonItem *toolItem;
}
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@end
@implementation LYFunctionInterface
static NSMutableDictionary *Competence;//模块开通
static NSDictionary *Communit;


static NSMutableArray    * m_order;
@synthesize bar,m_imageScrollView,m_page,m_imageView,m_View;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bar.delegate = self;
    [NSThread detachNewThreadSelector:@selector(Getdata:) toTarget:self withObject:nil];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    
    [_titleButton setTitle: [[LYSqllite currentCommnit] objectForKey:@"communitname"] forState: UIControlStateNormal];
    mapItem = [self createCustomItem:@"地图模式" imageName:@"4" selector:@selector(jumpToPage:) tag:100];
    mineItem = [self createCustomItem:@"我的主页" imageName:@"2" selector:@selector(jumpToPage:) tag:101];
    toolItem = [self createCustomItem:@"工具" imageName:@"3" selector:@selector(jumpToPage:) tag:102];
    NSArray *array = [NSArray arrayWithObjects:
                      [self createFixableItem:17]
                      ,mapItem
                      ,[self createFixableItem:0]
                      ,mineItem
                      ,[self createFixableItem:0]
                      ,toolItem
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

//我的社区
-(IBAction)GoMycommunit:(id)sender
{
    [self performSegueWithIdentifier:@"GoLYMyCommunit" sender:self];
}

//跳转到物业管理
- (IBAction)GoManagebutton:(id)sender
{
    if(![[[NSString alloc]initWithFormat:@"%@",[[Competence objectForKey:@"modb"] objectForKey:@"checked"]]isEqualToString:@"1"])
    {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"功能暂未开通敬请期待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alview show];
    }else if ([LYUserloginView Getourist])
    {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前是游客登录是否登录？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"取消", nil];
        [alview show];
    }else
    {
        [self performSegueWithIdentifier:@"GoLYProManagementMain" sender:self];
    }
}
//周边便民
-(IBAction)ConvenienceMian:(id)sender
{
    if(![[[NSString alloc]initWithFormat:@"%@",[[Competence objectForKey:@"moda"] objectForKey:@"checked"]]isEqualToString:@"1"])
    {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"功能暂未开通敬请期待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alview show];
    }else
    {
        [self performSegueWithIdentifier:@"GoLYconvenienceMain" sender:self];
    }
}
// 邻里互助
- (IBAction)NCMain:(id)sender {
    if(![[[NSString alloc]initWithFormat:@"%@",[[Competence objectForKey:@"modc"] objectForKey:@"checked"]]isEqualToString:@"1"])
    {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"功能暂未开通敬请期待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alview show];
    }else if ([LYUserloginView Getourist])
    {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前是游客登录是否登录？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"取消", nil];
        [alview show];
    }else
    {
        [self performSegueWithIdentifier:@"JumpToNC" sender:self];
    }
}

// 小区交流
- (IBAction)CommunitChat:(id)sender {
    
    NSDictionary *userInfo = [LYSqllite Ruser];
    NSString *isOpenString = [[NSString alloc] initWithFormat:@"%@", [[Competence objectForKey:@"modd"] objectForKey:@"checked"]];
    
    if (![isOpenString isEqualToString:@"1"]) {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"功能暂未开通敬请期待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alview show];
    }
    else if (!userInfo || [[userInfo objectForKey:@"auth_status"] isEqualToString:@"-2"]) {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前是游客登录是否登录？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"取消", nil];
        [alview show];
    }
    else {
        [self performSegueWithIdentifier:@"JumpToNC" sender:self];
    }
}

-(void)pageTurn:(UIPageControl *)aPageControl
{
    int whichPage = (int)aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [m_imageScrollView setContentOffset:CGPointMake(self.view.frame.size.width * whichPage, 0) animated:YES];
    [UIView commitAnimations];
    m_page.currentPage = m_timer;
}

//定时滚动
-(void)scrollTimer{
    m_timer ++;
    if (m_timer == m_picearry.count) {
        m_timer = 0;
    }
    [m_imageScrollView setContentOffset:CGPointMake(m_timer * self.view.frame.size.width,0) animated:YES];
    m_page.currentPage = m_timer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"GoConvenience_mian"])
    {
        //        LY_Featured_view *detailViewController = (LY_Featured_view*) segue.destinationViewController;
        //        detailViewController->m_Communityid = self->m_Community_ID;
    }
}

-(void)jumpToPage:(CustomToolbarItem *)sender
{
    switch (sender.tag) {
        case 101: {
            NSDictionary *userInfo = [LYSqllite Ruser];
            if (userInfo && ![[userInfo objectForKey:@"auth_status"] isEqualToString:@"-2"]) {
                [self performSegueWithIdentifier:@"GoHomepageMain" sender:self];
            }
            else {
                UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前是游客登录是否登录？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"取消", nil];
                [alview show];
            }
        }
            break;
        case 102:
            [self performSegueWithIdentifier:@"GoTools" sender:self];
            break;
        case 100:
            [self performSegueWithIdentifier:@"GoLYBaiduMap" sender:self];
            break;
        default:
            break;
    }
}
//获取网络数据
-(void)Getdata:(NSString *)url
{
    NSDictionary *dic = @{@"id" : [[LYSqllite currentCommnit] objectForKey:@"community_id"]};
    
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/community/index"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                          activity:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                               [alview show];
                                                           }else
                                                           {
                                                               NSDictionary *tem = [result objectForKey:@"community"];
                                                               Competence = [result objectForKey:@"level2"];
                                                               m_picearry = [tem objectForKey:@"images"];
                                                               
                                                               NSDictionary *sdic = [[[Competence objectForKey:@"moda" ] objectForKey:@"sub"] objectAtIndex:1];
                                                               m_order = [sdic objectForKey:@"sort"];
                                                               
                                                               [self updata];
                                                           }
                                                       }];
    
}

-(void)updata{
    m_imageScrollView.contentSize = CGSizeMake(m_picearry.count * self.m_imageScrollView.frame.size.width,0);
    m_imageScrollView.pagingEnabled = YES;
    m_imageScrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < m_picearry.count; i++)
    {
        m_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.m_imageView.frame.size.width, m_imageView.frame.size.height)];
        NSString *imageUrl = [[m_picearry objectAtIndex:i] objectForKey:@"path"];
        if (imageUrl!=nil && ![imageUrl isEqualToString:@""])
        {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [m_imageView setImageWithURL:url placeholderImage:nil];
        }
        [m_imageScrollView addSubview:m_imageView];
    }
    m_page = [[UIPageControl alloc] initWithFrame:CGRectMake(m_imageScrollView.frame.size.width-80, m_imageScrollView.frame.size.height-30, 60, 30)];
    m_page.tintColor = [UIColor grayColor];
    m_page.currentPageIndicatorTintColor = [UIColor colorWithRed:(238.0/255) green:(183.0/255) blue:(88.0/255) alpha:1.0];
    [m_View addSubview:m_page];
    m_page.numberOfPages = m_picearry.count;
    m_page.currentPage = 0;
    [m_page addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    m_timer = 0;
}

+(void)Setcommunitinfo :(NSDictionary *)dic
{
    Communit =dic;
}
+(NSDictionary *)Getcommunitinfo
{
    return Communit;
}

+(NSMutableArray *)Getorder
{
    return m_order;
}

@end
