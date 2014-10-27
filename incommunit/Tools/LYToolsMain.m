//
//  LYToolsMain.m
//  incommunit
//  工具主界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYToolsMain.h"

@interface LYToolsMain ()

@end

@implementation LYToolsMain

@synthesize m_cell,m_table,m_lable,m_exitbutton;
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
    [m_exitbutton.layer setMasksToBounds:YES];
    [m_exitbutton.layer setCornerRadius:3.0];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0]];
    [customLab setText:@"工具"];
    customLab.font = [UIFont boldSystemFontOfSize:17];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0];
    // Do any additional setup after loading the view.
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
    return 3;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
        case 2:
            return 3;
        default:
            return 0;
            break;
    }
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    m_cell = [[UITableViewCell alloc] init] ;
    m_cell = [tableView dequeueReusableCellWithIdentifier:@"Tcell"];
    m_lable = [[UILabel alloc] init];
    m_lable = (UILabel *)[m_cell viewWithTag:101];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    m_lable.text= @"通用设置";
                    break;
                case 1:
                    m_lable.text= @"隐私设置";
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    m_lable.text= @"帮帮公告";
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                    m_lable.text= @"版本更新";
                    break;
                case 1:
                    m_lable.text= @"意见反馈";
                    break;
                case 2:
                    m_lable.text= @"关于小区帮帮";
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
    return m_cell;
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSLog(@"%lu",(unsigned long)row);
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"GoUniversal" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"GoLYPrivacySettings" sender:self];
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            {
                switch (indexPath.row) {
                    case 0:
                        [self performSegueWithIdentifier:@"GoAnnouncement" sender:self];
                        break;
                    default:
                        break;
                }
            }
            break;
        }
        case 2:
        {
            {
                switch (indexPath.row) {
                    case 1:
                        [self performSegueWithIdentifier:@"GoLYFeedback" sender:self];
                        break;
                    case 2:
                        [self performSegueWithIdentifier:@"GoLYAbout" sender:self];
                        break;
                    default:
                        break;
                }
            }
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 30.0)];
    customView.backgroundColor = [UIColor colorWithRed:(211/255.0) green:(211/255.0) blue:(211/255.0) alpha:1.0];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:(65/255.0) green:(65/255.0) blue:(64/255.0) alpha:1.0];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.frame = CGRectMake(20.0, 10.0, self.view.frame.size.width, 15.0);
    switch (section) {
        case 0:
            headerLabel.text = @"设置";
            [customView addSubview:headerLabel];
            return customView;
            break;
        case 1:
            headerLabel.text = @"公告";
            [customView addSubview:headerLabel];
            return customView;
            break;
        case 2:
        {
            headerLabel.text = @"其他";
            [customView addSubview:headerLabel];
            return customView;
        }
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}
-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"移除");}];
}

-(IBAction)Exit:(id)sender
{
    [self performSegueWithIdentifier:@"GoLogin" sender:self];
}
@end
