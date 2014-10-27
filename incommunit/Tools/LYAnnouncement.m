//
//  LYAnnouncement.m
//  incommunit
//  公告界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYAnnouncement.h"
#import "LYPublicMethods.h"
#import "LYAnnouncementDetails.h"
@interface LYAnnouncement ()

@end

@implementation LYAnnouncement

@synthesize m_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self getAnnouncement:@""];
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return [notification count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"announcementCell"];
    NSDictionary *temp = [notification objectAtIndex:indexPath.section];
    m_IngLab = (UILabel *)[cell viewWithTag:100];
    m_IngLab.transform = CGAffineTransformMakeRotation(M_PI/8);
    
    UILabel * title = (UILabel *)[cell viewWithTag:102];
    title.text =[[NSString alloc]initWithFormat:@"%@",[temp objectForKey:@"name"]];
    
    UILabel *msmlab = (UILabel *)[cell viewWithTag:103];
    msmlab.text =[[NSString alloc]initWithFormat:@"%@",[temp objectForKey:@"content"]];
    
    UILabel *time = (UILabel *)[cell viewWithTag:104];
    NSString *times = [[NSString alloc]initWithFormat:@"%@",[temp objectForKey:@"create_time"]];
    times = [LYPublicMethods timeFormatted:[times intValue]];
    time.text = times;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     m_ANNinfo = [notification objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier:@"GoLYAnnouncementDetails" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        if ([segue.identifier isEqualToString: @"GoLYAnnouncementDetails"])
        {
            LYAnnouncementDetails *detailViewController = (LYAnnouncementDetails*) segue.destinationViewController;
            detailViewController->m_announMessage = m_ANNinfo;
        }
}


#pragma mark 获取网络数据
-(void)getAnnouncement:(NSString *)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString *urlstr =[[NSString alloc] initWithFormat:@"%@/services/notice/get",url] ;
    //NSString *urlstr = [NSString stringWithFormat:@"%@/inCommunity/services/wuye/notice/list",URL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSString *status = [weatherDic objectForKey:@"status"];
    if (![status isEqual:@"200"])
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
    notification = [weatherDic objectForKey:@"data"];
    NSLog(@"%@",notification);
}

@end
