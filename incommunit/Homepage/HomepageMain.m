//
//  HomepageMain.m
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "HomepageMain.h"

@interface HomepageMain ()

@end

@implementation HomepageMain
@synthesize m_tableview;
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
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableview 协议函数
#pragma mark - tableView 协议函数
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 2;
            break;
        case 5:
            return 1;
            break;
        case 6:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 110;
    }else
    {
        return 50.0f;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            UILabel *lable_name = [[UILabel alloc] init];
            cell = [[UITableViewCell alloc] init] ;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell01"];
            lable_name = (UILabel *)[cell.contentView viewWithTag:100];
            UIImageView *m_imageview = [[UIImageView alloc] init];
            m_imageview = (UIImageView *)[cell viewWithTag:101];
            CALayer *lay  = m_imageview.layer;//获取ImageView的层
            [lay setMasksToBounds:YES];
            [lay setCornerRadius:40.0];
        }
            break;
        case 1:
        {
            cell = [[UITableViewCell alloc] init] ;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell02"];
            if (indexPath.row ==0) {
                UIImageView *image = [[UIImageView alloc] init];
                image = (UIImageView *)[cell.contentView viewWithTag:100];
                [image setImage:[UIImage imageNamed:@"1_10.png"]];
                UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
                name.text = @"成为实名用户";
            }else if (indexPath.row ==1)
            {
                UIImageView *image = [[UIImageView alloc] init];
                image = (UIImageView *)[cell.contentView viewWithTag:100];
                [image setImage:[UIImage imageNamed:@"2_10.png"]];
                UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
                name.text = @"小区开店";
            }
        }
            break;
        case 2:
        {
            cell = [[UITableViewCell alloc] init] ;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell02"];
            if (indexPath.row ==0) {
                UIImageView *image = [[UIImageView alloc] init];
                image = (UIImageView *)[cell.contentView viewWithTag:100];
                [image setImage:[UIImage imageNamed:@"3_10.png"]];
                UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
                name.text = @"我的相册";
            }else if (indexPath.row ==1)
            {
                UIImageView *image = [[UIImageView alloc] init];
                image = (UIImageView *)[cell.contentView viewWithTag:100];
                [image setImage:[UIImage imageNamed:@"4_10.png"]];
                UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
                name.text = @"朋友圈";
            }else if (indexPath.row ==2)
            {
                UIImageView *image = [[UIImageView alloc] init];
                image = (UIImageView *)[cell.contentView viewWithTag:100];
                [image setImage:[UIImage imageNamed:@"5_10.png"]];
                UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
                name.text = @"通讯录";
            }
        }
            break;
        case 3:
        {
            cell = [[UITableViewCell alloc] init] ;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell02"];
            if (indexPath.row ==0) {
                UIImageView *image = [[UIImageView alloc] init];
                image = (UIImageView *)[cell.contentView viewWithTag:100];
                [image setImage:[UIImage imageNamed:@"6_10.png"]];
                UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
                name.text = @"我的发布";
            }else if (indexPath.row ==1)
            {
                UIImageView *image = [[UIImageView alloc] init];
                image = (UIImageView *)[cell.contentView viewWithTag:100];
                [image setImage:[UIImage imageNamed:@"7_10.png"]];
                UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
                name.text = @"我的收藏";
            }
        }
            break;
        case 4:
        {
            if (indexPath.row ==0) {
                cell = [[UITableViewCell alloc] init] ;
                cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell02"];
                UIImageView *image = [[UIImageView alloc] init];
                image = (UIImageView *)[cell.contentView viewWithTag:100];
                [image setImage:[UIImage imageNamed:@"8_10.png"]];
                UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
                name.text = @"我的购物车";
            }else if(indexPath.row ==1)
            {
                cell = [[UITableViewCell alloc] init] ;
                cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell02"];
                UIImageView *image = [[UIImageView alloc] init];
                image = (UIImageView *)[cell.contentView viewWithTag:100];
                [image setImage:[UIImage imageNamed:@"ic_my_orders.png"]];
                UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
                name.text = @"我的订单";
            }
            
        }
            break;
        case 5:
        {
            cell = [[UITableViewCell alloc] init] ;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell02"];
            UIImageView *image = [[UIImageView alloc] init];
            image = (UIImageView *)[cell.contentView viewWithTag:100];
            [image setImage:[UIImage imageNamed:@"ic_community_phones.png"]];
            UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
            name.text = @"小区号码";
        }
            break;
        case 6:
        {
            cell = [[UITableViewCell alloc] init] ;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell02"];
            UIImageView *image = [[UIImageView alloc] init];
            image = (UIImageView *)[cell.contentView viewWithTag:100];
            [image setImage:[UIImage imageNamed:@"ic_share_to_friends.png"]];
            UILabel* name = (UILabel *)[cell.contentView viewWithTag:101];
            name.text = @"分享给好友";
        }
        default:
            break;
    }
    return cell;
    
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"GoPersonaldata" sender:self];
    }
    else if (indexPath.section == 1) {
        switch (row) {
            case 0:
                [self performSegueWithIdentifier:@"Gocertification" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"Goshop" sender:self];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        switch (row) {
            case 0:
                NSLog(@"我的相册");
                break;
            case 1:
                NSLog(@"朋友圈");
                break;
            case 2:
                NSLog(@"通讯录");
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 3) {
        
        switch (row) {
            case 0:
                NSLog(@"我的发布");
                break;
            case 1:
                [self performSegueWithIdentifier:@"Gocollection" sender:self];
                break;
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"Goselectstore" sender:self];
            NSLog(@"我的购物车");
        }else if (indexPath.row == 1) {
            
            [self performSegueWithIdentifier:@"GoMyorder" sender:self];
            
        }
        
    }
    else if (indexPath.section == 5) {
        
        [self performSegueWithIdentifier:@"Gonumbersense" sender:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"%lu",(unsigned long)row);
}
@end
