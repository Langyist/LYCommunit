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
            [self performSegueWithIdentifier:@"GoLYPrivacySettings" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"GoAnnouncement" sender:self];
            break;
        case 6:
            //[self performSegueWithIdentifier:@"GoAnnouncement" sender:self];
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

-(IBAction)Exit:(id)sender
{
    [self performSegueWithIdentifier:@"GoLogin" sender:self];
}

@end
