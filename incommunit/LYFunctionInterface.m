//
//  LYFunctionInterface.m
//  incommunit
//  功能主界面
//  Created by LANGYI on 14/10/26.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYFunctionInterface.h"
#import "LYSelectCommunit.h"
@interface LYFunctionInterface ()
@end
@implementation LYFunctionInterface
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
    UIButton* m_selectCityButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [m_selectCityButton addTarget:self action:@selector(GoMycommunit:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[LYSelectCommunit GetCommunityInfo] objectForKey:@"name"] isEqual:@""]||[[LYSelectCommunit GetCommunityInfo] objectForKey:@"name"] == nil)
    {
        [m_selectCityButton setTitle: [[LYSelectCommunit GetCommunityInfo] objectForKey:@"communitname"] forState: UIControlStateNormal];
    }else
    {
        [m_selectCityButton setTitle: [[LYSelectCommunit GetCommunityInfo] objectForKey:@"name"] forState: UIControlStateNormal];
    }
    [m_selectCityButton setTitleColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0] forState:UIControlStateNormal];
    self.navigationItem.titleView = m_selectCityButton;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(238.0/255) green:(183.0/255) blue:(88.0/255) alpha:1.0];
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(240.0/255) green:(174.0/255) blue:(64.0/255) alpha:1.0];
}

//我的社区
-(IBAction)GoMycommunit:(id)sender
{
    [self performSegueWithIdentifier:@"GoLYMyCommunit" sender:self];
}
//跳转到物业管理
- (IBAction)GoManagebutton:(id)sender
{
//    if ( [[[LY_ManageView alloc] init] Getnotification:@""])
//    {
//        [self performSegueWithIdentifier:@"GoManage" sender:self];
//    }
}
-(IBAction)ConvenienceMian:(id)sender
{
    [self performSegueWithIdentifier:@"GoLYconvenienceMain" sender:self];
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

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 101:
            [self performSegueWithIdentifier:@"GoHomepageMain" sender:self];
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
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *urlstr = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urll = [[NSString alloc] initWithFormat:@"%@/services/community/index?id=%@",urlstr,[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"]];
    //    加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urll]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSString *status = [weatherDic objectForKey:@"status"];
    NSLog(@"%@",status);
    NSDictionary *data = [weatherDic objectForKey:@"data"];
    NSDictionary *tem = [data objectForKey:@"community"];
    m_picearry = [tem objectForKey:@"images"];
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
@end
