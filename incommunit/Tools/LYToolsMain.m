//
//  LYToolsMain.m
//  incommunit
//  工具主界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYToolsMain.h"
#import "LYUserloginView.h"
@interface LYToolsMain ()
{
 LYPrivacySettings *privacy;
}

@end

@implementation LYToolsMain

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
     privacy= [[LYPrivacySettings alloc] init];
    [self.m_exitbutton.layer setMasksToBounds:YES];
    [self.m_exitbutton.layer setCornerRadius:3.0];
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

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSLog(@"%lu",(unsigned long)row);
    switch (row) {
        case 1:
            [self performSegueWithIdentifier:@"GoUniversal" sender:self];
            break;
        case 2:
            if ([privacy getprivacysetting:@""]) {
                [self performSegueWithIdentifier:@"GoLYPrivacySettings" sender:self];
            }
            else
            {
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起，你现在是游客登陆状态，无法使用此功能。是否登陆/注册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [al show];
            }
            break;
        case 4:
            [self performSegueWithIdentifier:@"GoAnnouncement" sender:self];
            break;
        case 6:
        {
            UIAlertView *alview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存清除成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alview show];
        }
            break;
        case 7:
            [self performSegueWithIdentifier:@"GoLYFeedback" sender:self];
            break;
        case 8:
            [self performSegueWithIdentifier:@"GoLYAbout" sender:self];
            break;
        default:
            break;
    }
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"GoLogin"])
    {
        LYUserloginView *detailViewController = (LYUserloginView*) segue.destinationViewController;
        detailViewController->m_bool = TRUE;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self performSegueWithIdentifier:@"GoLogin" sender:self];
    }
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
}
-(IBAction)Exit:(id)sender
{
    [self performSegueWithIdentifier:@"GoLogin" sender:self];
}

@end
