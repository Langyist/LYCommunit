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
    NSString *address1;
    NSString *address2;
    NSString *address3;
    NSString *address4;
    
    NSString *album1;
    NSString *album2;
    NSString *album3;
    NSString *album4;
    NSMutableDictionary *select;
    
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
    select = [[NSMutableDictionary alloc] init];
    m_UIbutton = [[NSMutableArray alloc] init];
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
        
        return 4;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"addresscellIdentifier"];
        UIButton *addressButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 9, 25, 25)];
        [addressButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
        [addressButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateSelected];
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
                    [select setValue:@"1" forKey:@"address1"];
                    address1=@"1";
                }else
                {
                    addressButton.selected = YES;
                    [select setValue:@"0" forKey:@"address1"];
                    isselect = NO;
                    address1=@"0";
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
                    [select setValue:@"1" forKey:@"address2"];
                    isselect = YES;
                    address2=@"1";
                }else
                {
                    addressButton.selected = YES;
                    isselect = NO;
                    [select setValue:@"0" forKey:@"address2"];
                    address2=@"0";
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
                    [select setValue:@"1" forKey:@"address3"];
                    isselect = YES;
                    address3=@"1";
                }else
                {
                    addressButton.selected = YES;
                    [select setValue:@"0" forKey:@"address3"];
                    isselect = NO;
                    address3=@"0";
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
                    [select setValue:@"1" forKey:@"address4"];
                    address4=@"1";
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                    [select setValue:@"0" forKey:@"address4"];
                    address4=@"0";
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
                    [select setValue:@"1" forKey:@"album1"];
                    album1=@"1";
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                    [select setValue:@"0" forKey:@"album1"];
                    album1=@"0";
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
                    [select setValue:@"1" forKey:@"album2"];
                    album2=@"1";
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                    [select setValue:@"0" forKey:@"album2"];
                    album2=@"0";
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
                    [select setValue:@"1" forKey:@"album3"];
                    album3=@"1";
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                    [select setValue:@"0" forKey:@"album3"];
                    album3=@"0";
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
                    [select setValue:@"1" forKey:@"album4"];
                    album4=@"1";
                }else
                {
                    addressButton.selected = YES;
                    isselect = YES;
                    [select setValue:@"0" forKey:@"album4"];
                    album4=@"0";
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
    if (button.selected) {
        if (indexPath.section==0) {
            switch (indexPath.row) {
                case 0:
                    address1=@"1";
                    break;
                case 1:
                    address2=@"1";
                    break;
                case 2:
                    address3=@"1";
                    break;
                case 3:
                    address4=@"1";
                    break;
                default:
                    break;
            }
        }else if(indexPath.section ==1)
        {
            switch (indexPath.row) {
                case 0:
                    album1=@"1";
                    break;
                case 1:
                    album2=@"1";
                    break;
                case 2:
                    album3=@"1";
                    break;
                case 3:
                    album4=@"1";
                    break;
                default:
                    break;
            }
            
        }
        button.selected = YES;
        isselect = YES;
    }else{
        if (indexPath.section ==0) {
            switch (indexPath.row) {
                case 0:
                    address1=@"0";
                    break;
                case 1:
                    address2=@"0";
                    break;
                case 2:
                    address3=@"0";
                    break;
                case 3:
                    address4=@"0";
                    break;
                default:
                    break;
            }
        }else if(indexPath.section ==1)
        {
            switch (indexPath.row) {
                case 0:
                    album1=@"0";
                    break;
                case 1:
                    album2=@"0";
                    break;
                case 2:
                    album3=@"0";
                    break;
                case 3:
                    album4=@"0";
                    break;
                default:
                    break;
            }

        }
        button.selected = NO;
        isselect = NO;
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
-(BOOL)Submit
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *urlstr = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString    *URLString = [NSString stringWithFormat:@"%@/services/visible_setting/set",urlstr];
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"address=";//设置参数
    str = [str stringByAppendingFormat:@"%@&address=%@&address=%@&address=%@&album=%@&album=%@&album=%@&album=%@&add_friend=%@",address1,address2,address3,address4,album1,album2,album3,album4 ,@"1"];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
    if ([[weatherDic objectForKey:@"status"] isEqualToString:@"200"])
    {
        return YES;
    }else
    {
        return NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self Submit];
}
@end
