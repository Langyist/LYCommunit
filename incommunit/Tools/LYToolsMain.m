//
//  LYToolsMain.m
//  incommunit
//  工具主界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYToolsMain.h"
#import "LYUserloginView.h"
#import "StoreOnlineNetworkEngine.h"
#import "LYPrivacySettings.h"
@interface LYToolsMain ()
{
    LYPrivacySettings *privacy;
    
}

@end
static NSString *addfriend;
static NSMutableArray * address ;
static NSMutableArray *album;
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
            [self getprivacysetting];
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


#pragma mark getdata
- (void)getprivacysetting
{
    NSDictionary *dic =@{};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/visible_setting/get"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起，你现在是游客登陆状态，无法使用此功能。是否登陆/注册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                                               [al show];
                                                           }else
                                                           {
                                                               [self performSegueWithIdentifier:@"GoLYPrivacySettings" sender:self];
                                                               addfriend = [result objectForKey:@"add_friend"];
                                                               address = [result objectForKey:@"address"];
                                                               album = [result objectForKey:@"album"];
                                             }}];
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"GoLogin"])
    {
        LYUserloginView *detailViewController = (LYUserloginView*) segue.destinationViewController;
        detailViewController->m_bool = TRUE;
    }
    if ([segue.identifier isEqualToString: @"GoLYPrivacySettings"])
    {
        LYPrivacySettings *PrivacySettings = (LYPrivacySettings*) segue.destinationViewController;
        PrivacySettings->m_addfriend = addfriend;
        PrivacySettings->m_address = address;
        PrivacySettings->m_album = album;
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
