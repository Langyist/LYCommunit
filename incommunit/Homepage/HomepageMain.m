//
//  HomepageMain.m
//  incommunit
//  我的主页
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "HomepageMain.h"
#import "LYSqllite.h"
#import "UIImageView+AsyncDownload.h"
@interface HomepageMain ()

@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;

@end

@implementation HomepageMain

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *lay  = self.userPhoto.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:40.0];
    NSURL *url = [NSURL URLWithString:[LYSqllite Getheadiamge]];
    [_userPhoto setImageWithURL: url placeholderImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview 协议函数
#pragma mark - tableView 协议函数
// Customize the number of sections in the table view

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"GoPersonaldata" sender:self];
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"Gocertification" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"MyStores" sender:self];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"该功能尚未开启"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:@"取消", nil];
                [alert show];
            }
                break;
            case 1:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"该功能尚未开启"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:@"取消", nil];
                [alert show];
            }
                break;
            case 2: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"该功能尚未开启"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:@"取消", nil];
                [alert show];
            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 3) {
        
        switch (indexPath.row) {
            case 0:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                                message:@"该功能尚未开启"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:@"取消", nil];
                [alert show];
            }
                break;
            case 1:
                [self performSegueWithIdentifier:@"Gocollection" sender:self];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"Goshopcat" sender:self];
        }else if (indexPath.row == 1) {
            
            [self performSegueWithIdentifier:@"GoMyorder" sender:self];
            
        }
        
    }
    else if (indexPath.section == 5) {
        
        [self performSegueWithIdentifier:@"Gonumbersense" sender:self];
    }
    else if (indexPath.section == 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"该功能尚未开启"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"%lu",(unsigned long)row);
}
@end
