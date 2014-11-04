//
//  LYPrivacySettings.m
//  incommunit
// 隐私设置界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYPrivacySettings.h"

@interface LYPrivacySettings () {
    
    BOOL isselect;
}
@property (weak, nonatomic) IBOutlet UISwitch *isVisiable;
@end

@implementation LYPrivacySettings
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
    m_UIbuttonArry = [[NSMutableArray alloc] init];
    m_UIbutton = [[NSMutableArray alloc] init];
//  m_address = [[NSMutableArray alloc] init];
//  m_album = [[NSMutableArray alloc] init];
    isselect= NO;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    address = [NSMutableArray arrayWithCapacity:4];
    album = [NSMutableArray arrayWithCapacity:4];
    [NSThread detachNewThreadSelector:@selector(getprivacysetting:) toTarget:self withObject:nil];
}

#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }else if (section == 1) {
        
        return 5;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"addresscellIdentifier"];
        UIButton *addressButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 9, 25, 25)];
        [addressButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
        [addressButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateSelected];
        [addressButton addTarget:self action:@selector(addressedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:addressButton];
        [m_UIbuttonArry addObject:addressButton];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
            {
                UILabel * lab = (UILabel *)[cell viewWithTag:100];
                lab.text =@"朋友可见";
                if([[m_address objectAtIndex:indexPath.row] intValue]==1)
                {
                    addressButton.selected = NO;
                    isselect = NO;
                    address[0]=@"0";
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                    address[0]=@"1";
                }
            }
                break;
            case 1:
            {
                UILabel * lab = (UILabel *)[cell viewWithTag:100];
                lab.text =@"实名用户可见";
                if([[m_address objectAtIndex:indexPath.row] intValue]==1)
                {
                    addressButton.selected = NO;
                    isselect = NO;
                    address[1]=@"0";
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                    address[1]=@"1";
                }
            }
                break;
            case 2:
            {
                UILabel * lab = (UILabel *)[cell viewWithTag:100];
                lab.text =@"注册用户可见";
                if([[m_address objectAtIndex:indexPath.row] intValue]==1)
                {
                    addressButton.selected = NO;
                    isselect = NO;
                    address[2]=@"0";
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                    address[2]=@"1";
                }
            }
                break;
            case 3:
            {
                UILabel * lab = (UILabel *)[cell viewWithTag:100];
                lab.text =@"所有人可见";
                if([[m_address objectAtIndex:indexPath.row] intValue]==1)
                {
                    addressButton.selected = NO;
                    isselect = NO;
                    address[3]=@"0";
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                    address[3]=@"1";
                }
            }
                break;
            default:
                break;
        }
        return cell;
        
    }else if (indexPath.section == 1) {
        
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"addresscellIdentifier"];
        UIButton *addressButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 9, 25, 25)];
        [addressButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
        [addressButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateSelected];
        [addressButton addTarget:self action:@selector(addressedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:addressButton];
        [m_UIbutton addObject:addressButton];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
            {
                UILabel * lab = (UILabel *)[cell viewWithTag:100];
                lab.text =@"朋友可见";
                if([[m_album objectAtIndex:indexPath.row] intValue]==1)
                {
                    addressButton.selected = NO;
                    isselect = NO;
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                }
            }
                break;
            case 1:
            {
                UILabel * lab = (UILabel *)[cell viewWithTag:100];
                lab.text =@"实名用户可见";
                if([[m_album objectAtIndex:indexPath.row] intValue]==1)
                {
                    addressButton.selected = NO;
                    isselect = NO;
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                }
            }
                break;
            case 2:
            {
                UILabel * lab = (UILabel *)[cell viewWithTag:100];
                lab.text =@"注册用户可见";
                if([[m_album objectAtIndex:indexPath.row] intValue]==1)
                {
                    addressButton.selected = NO;
                    isselect = NO;
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                }
            }
                break;
            case 3:
            {
                UILabel * lab = (UILabel *)[cell viewWithTag:100];
                lab.text =@"所有人可见";
                if([[m_album objectAtIndex:indexPath.row] intValue]==1)
                {
                    addressButton.selected = NO;
                    isselect = NO;
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                }
            }
                break;
            default:
                break;
        }
        return cell;
    }else {
        
        return nil;
    }
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
            headerLabel.text = @"我的住址";
            [customView addSubview:headerLabel];
            return customView;
            break;
        case 1:
            headerLabel.text = @"我的相册";
            [customView addSubview:headerLabel];
            return customView;
            break;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *button;
    if (indexPath.section ==0) {
        button = [m_UIbuttonArry objectAtIndex:indexPath.row];
    }else if(indexPath.section == 1)
    {
         button = [m_UIbutton objectAtIndex:indexPath.row];
    }
    if (isselect) {
        button.selected = NO;
        isselect = NO;
    }else{
        
        button.selected = YES;
        isselect = YES;
    }
}
//勾选
- (void)addressedButtonPressed:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (isselect) {
        button.selected = NO;
        isselect = NO;
    }else{
        
        button.selected = YES;
        isselect = YES;
    }
}

#pragma mark getdata
- (BOOL)getprivacysetting:(NSString *)url
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *strurl = [plistDic objectForKey: @"URL"];
    NSError *error;
    //加载一个NSURL对象
    NSString *urlstr =[[NSString alloc] initWithFormat:@"%@/services/visible_setting/get",strurl] ;
    //NSString *urlstr = [NSString stringWithFormat:@"%@/inCommunity/services/wuye/notice/list",URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(response!=nil)
    {
        // iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSDictionary *data = [weatherDic objectForKey:@"data"];
        m_addfriend = [data objectForKey:@"add_friend"];
        m_address = [data objectForKey:@"address"];
        m_album = [data objectForKey:@"album"];
        if ([[weatherDic objectForKey:@"status"] isEqualToString:@"200"]){
            NSString *add_frend = [weatherDic objectForKey:@"add_friend"];
            NSLog(@"add_friend%@",add_frend);
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_tableView reloadData];
                // 更新UI
            });
            return TRUE;
        }else
        {
            return FALSE;
        }
    }
    return nil;
}
@end
