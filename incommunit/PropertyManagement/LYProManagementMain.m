//
//  LYProManagementMain.m
//  incommunit
//  物业管理主界面
//  Created by LANGYI on 14/10/30.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#import "LYProManagementMain.h"
#import "LY_AnnouncementCell.h"
#import "LY_InfoCell.h"
#import "LY_ACCell1.h"
#import "LY_MaintenanceCell.h"
#import "LYAnnouncementDetails.h"
#import "LYPostcomment.h"
#import "LYSelectCommunit.h"
#import "LY_AnnouncementNoCell.h"
#import "MessageContentTableViewCell.h"
#import "CommentTableViewCell.h"
#import "InfoHeader.h"
#import "XHFriendlyLoadingView.h"
#import "StoreOnlineNetworkEngine.h"
#import "AppDelegate.h"
#import "LYSqllite.h"
#import "LYAnnDetails.h"
#import "LYReplyMessage.h"
#import "RepairDetailViewController.h"
@interface LYProManagementMain () {
    UIView *m_liuView;
    UIButton *repairButton;//我要报修button
    
    UILabel *m_QQLabel;
    UILabel *m_phoneLabel;
    
    NSArray *communicationStyle;
    NSArray *communicationInfo;
    NSArray *communicationInfoRange;
}

@end
@implementation LYProManagementMain
@synthesize m_segment;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_pageOffset = 0;
    m_pageSize = 10;

    [m_segment addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.m_segment setBackgroundImage:transparentImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.m_segment setTitleTextAttributes:@{
                                             NSForegroundColorAttributeName : [UIColor colorWithRed:63/255.0f green:62/255.0f blue:62/255.0f alpha:1]
                                             }
                                  forState:UIControlStateNormal];
    [self.m_segment setTitleTextAttributes:@{
                                             NSForegroundColorAttributeName : [UIColor colorWithRed:230/255.0f green:163/255.0f blue:44/255.0f alpha:1]
                                             }
                                  forState:UIControlStateSelected];
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width * 3, self.m_scrollView.frame.size.height);
    [self.m_scrollView setBackgroundColor:BK_GRAY];
    [self.m_scrollView setScrollEnabled:NO];
    //物业公告
    m_view01 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_scrollView.frame.size.width, self.m_scrollView.frame.size.height)];
    [m_view01 setBackgroundColor:BK_GRAY];
    m_AnntableVeiw = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.m_scrollView.frame.size.height)];
    [m_AnntableVeiw setContentInset:UIEdgeInsetsMake(5, 0, 4, 0)];
    UINib *nib = [UINib nibWithNibName:@"AnnouncementCellNo" bundle:nil];
    [m_AnntableVeiw registerNib:nib forCellReuseIdentifier:@"AnnouncementNoCellidentifier"];
    UINib *nib1 = [UINib nibWithNibName:@"AnnouncementCell" bundle:nil];
    [m_AnntableVeiw registerNib:nib1 forCellReuseIdentifier:@"AnnouncementCellidentifier"];
    m_AnntableVeiw.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_AnntableVeiw.delegate = self;
    m_AnntableVeiw.dataSource = self;
    [m_AnntableVeiw setBackgroundColor:BK_GRAY];
    [m_view01 addSubview:m_AnntableVeiw];
    [self.m_scrollView addSubview:m_view01];
    //信息查询
    m_view02 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.m_scrollView.frame.size.width, self.m_scrollView.frame.size.height)];
    m_InfotableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, m_view02.frame.size.width, m_view02.frame.size.height)];
    [m_InfotableView registerNib:[UINib nibWithNibName:@"InfoCell" bundle:nil] forCellReuseIdentifier:@"InfoCellindentfier"];
    _m_scrollView.backgroundColor = [UIColor grayColor];
    m_InfotableView.delegate = self;
    m_InfotableView.dataSource = self;
    [m_view02 addSubview:m_InfotableView];
    [self.m_scrollView addSubview:m_view02];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(m_InfotableView.frame), 1)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    footerView.clipsToBounds = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 101, 83, 95)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [imageView setImage:[UIImage imageNamed:@"周边便民--未开店--帮帮娃_03"]];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(139, 107, 160, 89)];
    label1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    label1.lineBreakMode = NSLineBreakByCharWrapping;
    label1.numberOfLines = 0;
    [label1 setText:@"亲，只有本小区实名认证用户才能查看哦～～"];
    label1.font = [UIFont boldSystemFontOfSize:15.0f];
    label1.textColor = SPECIAL_GRAY;
    
    [footerView addSubview:imageView];
    [footerView addSubview:label1];
    
    [m_InfotableView setBackgroundColor:BK_GRAY];
    m_InfotableView.tableFooterView = footerView;
    
    //物业交流
    m_view03 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.m_scrollView.frame.size.width, self.view.frame.size.height)];
    [m_view03 setBackgroundColor:BK_GRAY];
    
    m_ACtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 7.5, self.m_scrollView.frame.size.width, self.view.frame.size.height - 7.5)];
    [m_ACtableView setBackgroundColor:BK_GRAY];
    [m_ACtableView setContentInset:UIEdgeInsetsMake(0, 0, -7.5, 0)];
    m_ACtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [m_ACtableView registerNib:[UINib nibWithNibName:@"MessageContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageContentTableViewCell"];
    [m_ACtableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCell"];
    [m_ACtableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ContactCell"];
    m_ACtableView.delegate = self;
    m_ACtableView.dataSource = self;
    [m_view03 addSubview:m_ACtableView];
    
    [self.m_scrollView addSubview:m_view03];
    
    //物业维修
    m_view04 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 3, 0, self.m_scrollView.frame.size.width, self.m_scrollView.frame.size.height)];
    m_MaintableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, m_view04.frame.size.width, m_view04.frame.size.height)];
    [m_MaintableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    m_MaintableView.delegate = self;
    m_MaintableView.dataSource = self;
    [m_view04 addSubview:m_MaintableView];
    
    UINib *nib2 = [UINib nibWithNibName:@"MaintenanceCell" bundle:nil];
    [m_MaintableView registerNib:nib2 forCellReuseIdentifier:@"Maintenanceidentifier"];
    
    //我要报修button
    repairButton = [[UIButton alloc] initWithFrame:CGRectMake(-3, m_view04.frame.size.height - 150, 150, 50)];
    repairButton.backgroundColor = [UIColor colorWithRed:188.0f/255.0f green:210.0f/255.0f blue:94.0f/255.0f alpha:1];
    repairButton.layer.cornerRadius = 3;
    repairButton.alpha = 0.9;
    [repairButton addTarget:self action:@selector(repairButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [m_view04 addSubview:repairButton];
    
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 30)];
    ImageView.image = [UIImage imageNamed:@"删除_03"];
    [repairButton addSubview:ImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 30)];
    label.text = @"我要报修";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    [repairButton addSubview:label];
    
    [m_view04 addSubview:repairButton];
    
    [self.m_scrollView addSubview:m_view04];
    //手势
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view01leftSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [m_view01 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view02leftSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [m_view02 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view02rightSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [m_view02 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view03leftSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [m_view03 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view03rightSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [m_view03 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view04rightSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [m_view04 addGestureRecognizer:recognizer];
    
    [self Getnotification];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGFloat newTableHeight = self.m_scrollView.frame.size.height;
    
    CGRect newFrame = m_AnntableVeiw.frame;
    newFrame.size.height = newTableHeight;
    m_AnntableVeiw.frame = newFrame;
    
    newFrame = m_InfotableView.frame;
    newFrame.size.height = newTableHeight;
    m_InfotableView.frame = newFrame;
    
    newFrame = m_ACtableView.frame;
    newFrame.size.height = newTableHeight - CGRectGetMaxY(m_liuView.frame);
    m_ACtableView.frame = newFrame;
    
    newFrame = m_MaintableView.frame;
    newFrame.size.height = newTableHeight;
    m_MaintableView.frame = newFrame;
}

//手势
-(void)m_view01leftSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self.m_scrollView setContentOffset:CGPointMake(1* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 1;
            [self GetInfomationInquiryData];
        }];}
    }
}

-(void)m_view02leftSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        { [UIView animateWithDuration:0.3 animations:^{
            [self.m_scrollView setContentOffset:CGPointMake(2* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 2;
            [self GetPropertyExchangeData];
            [self getMessageList];
        }];}
    }
}

-(void)m_view02rightSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self.m_scrollView setContentOffset:CGPointMake(0* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 0;
            [self Getnotification];
        }];}
    }
}

-(void)m_view03leftSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self.m_scrollView setContentOffset:CGPointMake(3* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 3;
            [self GetPropertyServiceData];
        }];}
    }
}

-(void)m_view03rightSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self.m_scrollView setContentOffset:CGPointMake(1* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 1;
        }];}
    }
}

-(void)m_view04rightSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    {
        { [UIView animateWithDuration:0.3 animations:^{
            [self.m_scrollView setContentOffset:CGPointMake(2* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 2;
        }];}
    }
}

//我要留言
- (void)liuButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"Postcomment" sender:self];
    NSLog(@"我要留言");
}
//我要报修
- (void)repairButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"repair" sender:self];
    NSLog(@"我要报修");
}

#pragma mark - Plain Segmented Control 协议函数
-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    switch (Seg.selectedSegmentIndex)
    {
        case 0:
        {
            [self.m_scrollView setContentOffset:CGPointMake(0* self.view.frame.size.width,0) animated:YES];
        }
            break;
        case 1:
        {
            [self.m_scrollView setContentOffset:CGPointMake(1* self.view.frame.size.width,0) animated:YES];
        }
            break;
        case 2:
        {
            [self.m_scrollView setContentOffset:CGPointMake(2* self.view.frame.size.width,0) animated:YES];
        }
            break;
        case 3:
        {
            [self.m_scrollView setContentOffset:CGPointMake(3* self.view.frame.size.width,0) animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == m_AnntableVeiw) {
        return 1;
    }else if (tableView == m_InfotableView) {
        
        NSDictionary *userInfo = [LYSqllite Ruser];
        tableView.tableFooterView.hidden = YES;
        if (userInfo && ![[userInfo objectForKey:@"auth_status"] isEqualToString:@"2"]) {
            tableView.tableFooterView.hidden = NO;
            return 0;
        }
        else {
            return 2;
        }
        
    }
    else if (tableView == m_ACtableView) {
        return 2;
    }
    else if (tableView == m_MaintableView) {
        
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == m_AnntableVeiw)
    {
        return notification.count;
    }
    else if (tableView == m_InfotableView) {
        
        switch (section) {
            case 0:
                return propertyExpenseArray.count;
                break;
            default:
                return 2;//expressInfomationArray.count;
                break;
        }
    }
    else if (tableView == m_ACtableView) {
        switch (section) {
            case 0: {
                return communicationStyle.count;
            }
                break;
            case 1: {
                return communicationInfo.count;
            }
                break;
            default: {
                return 0;
            }
                break;
        }
    }else if (tableView == m_MaintableView)
    {
        return propertyService.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == m_AnntableVeiw) {
        return 133;
    }
    else if (tableView == m_InfotableView) {
        
        switch (indexPath.row) {
            case 0:
            {
                return 60;
            }
                break;
            case 1:
            {
                return 70;
            }
            default:
                return 70;
                break;
        }
    }
    else if (tableView == m_ACtableView) {
        
        CGFloat heightForRowAtIndexPath = 0;
        switch (indexPath.section) {
            case 0: {
                heightForRowAtIndexPath = 28;
            }
                break;
            case 1: {
                
                if (indexPath.row < communicationInfo.count) {
                    NSNumber *indexNumber = [NSNumber numberWithInteger:indexPath.row];
                    NSDictionary *info = [communicationInfo objectAtIndex:indexPath.row];
                    if ([communicationInfoRange containsObject:indexNumber]) {
                        heightForRowAtIndexPath = [MessageContentTableViewCell cellHeightWithContent:[info objectForKey:@"content"]];
                    }
                    else {
                        heightForRowAtIndexPath = [CommentTableViewCell cellHeightWithContent:@[[info objectForKey:@"nick_name"], [info objectForKey:@"content"]]];
                    }
                }
                else {
                    return 0;
                }
            }
                break;
            default: {
                return 0;
            }
                break;
        }
        
        return heightForRowAtIndexPath;
    }
    else if (tableView == m_MaintableView) {
        return 171;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == m_AnntableVeiw)
    {
        NSDictionary *temp = [notification objectAtIndex:indexPath.row];
        LY_AnnouncementCell *cell;
        LY_AnnouncementNoCell *NoCell;
        if ([[[NSString alloc] initWithFormat:@"%@",[temp objectForKey:@"top"]]isEqual:@"0"]) {
            
            NoCell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementNoCellidentifier"];
            NoCell.lable1.text = [temp objectForKey:@"name"];
            [NoCell setTextContent:[temp objectForKey:@"content"]];
            [NoCell setTimestamp:[temp objectForKey:@"create_time"]];
            NoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return NoCell;
            
        }else if ([[[NSString alloc] initWithFormat:@"%@",[temp objectForKey:@"top"]]isEqual:@"1"])
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCellidentifier"];
            cell.lable1.text = [temp objectForKey:@"name"];
            [cell setTextContent:[temp objectForKey:@"content"]];
            [cell setTimestamp:[temp objectForKey:@"create_time"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
    }else if (tableView == m_InfotableView)
    {
        switch (indexPath.section) {
            case 0:
            {
                NSDictionary *temp = [propertyExpenseArray objectAtIndex:indexPath.row];

                UINib *nib = [UINib nibWithNibName:@"InfoCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:@"InfoCellindentfier"];
                LY_InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCellindentfier"];
                cell.nameLabel.text = [temp objectForKey:@"name"];
                cell.costLabel.text = [NSString stringWithFormat:@"%@",[temp objectForKey:@"price"]];
                cell.timeLabel.text = [NSString stringWithFormat:@"%@",[temp objectForKey:@"time"]];   //时间需要转换
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            default:
            {
                //NSDictionary *temp = [expressInfomationArray objectAtIndex:indexPath.row];
                UINib *nib = [UINib nibWithNibName:@"InfoCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:@"InfoCellindentfier"];
                LY_InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCellindentfier"];
                //                cell.nameLabel.text = [temp objectForKey:@"name"];
                //                cell.numberLabel.text = [NSString stringWithFormat:@"%@件",[temp objectForKey:@"count"]];
                //                if ([[temp objectForKey:@"status"] isEqualToString:@"0"])
                //                {
                //                    cell.statusLabel.text = @"已领";
                //                }
                //                else if([[temp objectForKey:@"status"] isEqualToString:@"1"])
                //                {
                //                    cell.statusLabel.text = @"未领";
                //                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
        }
    }
    else if (tableView == m_ACtableView) {
        switch (indexPath.section) {
            case 0: {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
                NSString *contactText = @"";
                if (indexPath.row < communicationStyle.count) {
                    NSDictionary *contactInfo = [communicationStyle objectAtIndex:indexPath.row];
                    contactText = [contactInfo objectForKey:@"contact"];
                }
                [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
                [cell.textLabel setTextColor:[UIColor grayColor]];
                [cell.textLabel setText:contactText];
                
                return cell;
            }
                break;
            case 1: {
                if (indexPath.row < communicationInfo.count) {
                    NSNumber *indexNumber = [NSNumber numberWithInteger:indexPath.row];
                    NSDictionary *info = [communicationInfo objectAtIndex:indexPath.row];
                    if ([communicationInfoRange containsObject:indexNumber]) {
                        MessageContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageContentTableViewCell" forIndexPath:indexPath];
                        [cell setImagePath:[info objectForKey:@"head"]];
                        [cell setUserName:[info objectForKey:@"nick_name"]];
                        [cell setTimestamp:[info objectForKey:@"create_time"]];
                        [cell setContent:[info objectForKey:@"content"]];
                        return cell;
                    }
                    else {
                        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
                        [cell setContent:@[[info objectForKey:@"nick_name"], [info objectForKey:@"content"]]];
                        return cell;
                    }
                }
                else {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    return cell;
                }
            }
                break;
            default: {
                return 0;
            }
                break;
        }
    }
    else if (tableView == m_MaintableView) {
        
        LY_MaintenanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Maintenanceidentifier" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (propertyService.count > indexPath.row) {
            
            NSDictionary *tempDic = [propertyService objectAtIndex:indexPath.row];
            
            cell.headNameLabel.text = [tempDic objectForKey:@"name"];
            
            NSString *statusString = [NSString stringWithFormat:@"%@", [tempDic objectForKey:@"status"]];
            NSString *imageName = @"repair_status1";
            if ([statusString isEqualToString:@"0"]) {
                imageName = @"";
            }
            else if ([statusString isEqualToString:@"1"]) {
                imageName = @"repair_status1";
            }
            else if ([statusString isEqualToString:@"2"]) {
                imageName = @"status_closed";
            }
            else  if ([statusString isEqualToString:@"3"]) {
                imageName = @"repair_status2";
            }
            [cell.statusImageView setImage:[UIImage imageNamed:imageName]];
            
            NSString *imageUrl = [specifyPropertyService  objectForKey:@"image_path"];
            if (imageUrl != nil && ![imageUrl isEqualToString:@""]) {
                NSURL *url = [NSURL URLWithString:imageUrl];
                [cell.avatarImageView setImageWithURL:url placeholderImage:nil];
            }
            else {
                [cell.avatarImageView setImage:[UIImage imageNamed:@"default_icon"]];
            }
            
            cell.nameLabel.text = [tempDic objectForKey:@"nick_name"];
            cell.addressLabel.text = [tempDic objectForKey:@"position"];
            cell.timeLabel.text =  [NSString stringWithFormat:@"%@", [tempDic objectForKey:@"create_time"]];
            cell.detailLabel.text = [tempDic  objectForKey:@"description"];
        }
        
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == m_AnntableVeiw)
    {
        return nil;
    }
    else if (tableView == m_InfotableView)
    {
        NSArray *titleArray = [NSArray arrayWithObjects:@"费用信息",@"快递信息", nil];
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"InfoHeader" owner:self options:nil]; //通过这个方法,取得我们的视图
        InfoHeader *headerView = [nibViews objectAtIndex:0];
        headerView.titleLabel = titleArray[section];
        return headerView;//将视图（v_headerView）返回
    }
    else if (tableView == m_ACtableView) {
        switch (section) {
            case 0: {
                
                CGFloat move = 13.5f;
                
                CGRect rect = tableView.frame;
                rect.origin = CGPointMake(0, 0);
                rect.size.height = 47;
                UIView *header = [[UIView alloc] initWithFrame:rect];
                [header setBackgroundColor:[UIColor whiteColor]];
                
                UILabel *m_medthedLabel = [[UILabel alloc] initWithFrame:CGRectMake(move, 0, 150, 40)];
                m_medthedLabel.text = @"物管联系方式";
                m_medthedLabel.font = [UIFont systemFontOfSize:16];
                [header addSubview:m_medthedLabel];
                
                UIView *Gview = [[UIView alloc] initWithFrame:CGRectMake(move, CGRectGetMaxY(m_medthedLabel.frame), CGRectGetWidth(rect) - move * 2, 1)];
                Gview.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1];
                [header addSubview:Gview];
                
                return header;
            }
                break;
            case 1: {
                CGFloat move = 13.5f;
                
                CGRect rect = tableView.frame;
                rect.origin = CGPointMake(0, 0);
                rect.size.height = 40;
                UIView *header = [[UIView alloc] initWithFrame:rect];
                [header setBackgroundColor:[UIColor whiteColor]];
                
                UILabel *liuLabel = [[UILabel alloc] initWithFrame:CGRectMake(move, 8, 80, 30)];
                liuLabel.text = @"留言薄";
                liuLabel.font = [UIFont systemFontOfSize:16];
                [header addSubview:liuLabel];
                
                rect = CGRectMake(222, 10, 80, 26);
                rect.origin.x = CGRectGetWidth(tableView.frame) - move - CGRectGetWidth(rect);
                UIButton * m_liuButton = [[UIButton alloc] initWithFrame:rect];
                [m_liuButton setTitle:@"我要留言" forState:UIControlStateNormal];
                [m_liuButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [m_liuButton addTarget:self action:@selector(liuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                m_liuButton.backgroundColor = [UIColor colorWithRed:(188/255.0f) green:(210/255.0f) blue:(94/255.0f) alpha:1.0];
                m_liuButton.layer.cornerRadius = 5;
                m_liuButton.layer.borderWidth = 0.1;
                [header addSubview:m_liuButton];
                
                return header;
            }
                break;
            default: {
                return nil;
            }
                break;
        }
    }
    else if (tableView == m_MaintableView)
    {
        return nil;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = nil;
    if (tableView == m_ACtableView) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 7.5)];
        [footerView setBackgroundColor:BK_GRAY];
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == m_AnntableVeiw) {
        return 0;
    }
    else if (tableView == m_InfotableView) {
        
        return 40;
    }
    else if (tableView == m_ACtableView) {
        switch (section) {
            case 0:
                return 47;
                break;
            case 1:
                return 40;
                break;
            default:
                break;
        }
    }
    else if (tableView == m_MaintableView) {
        
        return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat heightForFooterInSection = 0;
    if (tableView == m_ACtableView) {
        
        heightForFooterInSection = 7.5;
    }
    return heightForFooterInSection;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == m_AnntableVeiw) {
        selectedDictionary = [notification objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"NInformation" sender:self];
    }
    else if (tableView == m_ACtableView) {
        NSInteger row = indexPath.row;
        for (NSNumber *index in communicationInfoRange) {
            if (row <= [index integerValue]) {
                row = [index integerValue];
                break;
            }
        }
        specifyMessageDictionary = [communicationInfo objectAtIndex:row];
        [self performSegueWithIdentifier:@"replyMessage" sender:self];
    }
    else if (tableView == m_MaintableView) {
        specifyPropertyService = [propertyService objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"RepairDetail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"NInformation"])
    {
        if (0 != selectedDictionary.count)
        {
            [[segue destinationViewController] setDetailData:selectedDictionary];
        }
    }
    else if ([[segue identifier] isEqualToString:@"replyMessage"])
    {
        if (0 != specifyMessageDictionary.count)
        {
            NSString *idString = [NSString stringWithFormat:@"%@", [specifyMessageDictionary objectForKey:@"id"]];
            [((LYReplyMessage *)segue.destinationViewController) setMessageID:idString];
        }
    }
    else if ([[segue identifier] isEqualToString:@"RepairDetail"])
    {
        if (0 != specifyPropertyService.count)
        {
            NSString *idString = [NSString stringWithFormat:@"%@", [specifyPropertyService objectForKey:@"id"]];
            [((RepairDetailViewController *)segue.destinationViewController) setRepairID:idString];
        }
    }
}
//开始滑动隐藏button
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == m_MaintableView) {
        repairButton.hidden = YES;
    }
}
//结束滑动显示button
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == m_MaintableView) {
        repairButton.hidden = NO;
    }
}

#pragma mark 获取网络数据
//获取物业公告信息
-(void)Getnotification
{
    NSDictionary* dic = @{@"pageSize" : [[NSString alloc] initWithFormat:@"%d",m_pageSize]
                          ,@"pageOffset" : [[NSString alloc] initWithFormat:@"%d",m_pageOffset]
                          };
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/notice/list"
                                                        params:dic
                                                        repeat:NO
                                                         isGet:YES
                                                   resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                       if(!bValidJSON)
                                                       {
                                                           UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self
                                                                                                  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                           [alview show];
                                                           
                                                       }else
                                                       {
                                                           notification =result;
                                                           [m_AnntableVeiw reloadData];
                                                       }
                                                   }];
}

//获取"信息查询"的相关数据
-(void)GetInfomationInquiryData
{

    NSDictionary* dic = @{@"pageSize" : [[NSString alloc] initWithFormat:@"%d",m_pageSize]
                          ,@"pageOffset" : [[NSString alloc] initWithFormat:@"%d",m_pageOffset]
                          };
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/express_infor"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self
                                                                                                      cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                               [alview show];
                                                               
                                                           }else
                                                           {
                                                               expressInfomationArray =result;
                                                               [m_InfotableView reloadData];
                                                           }
                                                       }];
}
//获取"物业交流"的相关数据
-(void)GetPropertyExchangeData
{
    NSDictionary *dic = @{};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/contacts"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if (!bValidJSON) {
                                                               NSLog(@"%@",errorMsg);
                                                               
                                                           }
                                                           else {
                                                               communicationStyle = result;
                                                               [m_ACtableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                                           }
                                                       }];

    
}
//获取"物业维修"的相关数据
-(void)GetPropertyServiceData
{
    NSDictionary *dic = @{};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/service/list"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               NSLog(@"%@",errorMsg);
                                                               
                                                           }else
                                                           {
                                                               propertyService = result;
                                                               [m_MaintableView reloadData];
                                                           }
                                                       }];
    
    
}

-(void)GetPropertyServiceDetailData
{
    NSDictionary *dic = @{@"id" : [[NSString alloc] initWithFormat:@"%ld",(long)IDNumber]};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/service/detail"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               NSLog(@"%@",errorMsg);
                                                               
                                                           }else
                                                           {
                                                               specifyPropertyService = result;
                                                               
                                                           }
                                                       }];
}

-(void)getMessageDetailData
{
    
    NSDictionary *dic = @{@"id" : [[NSString alloc] initWithFormat:@"%ld",(long)IDNumber]};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/message/detail"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               NSLog(@"%@",errorMsg);
                                                               
                                                           }else
                                                           {
                                                               specifyMessageDictionary = result;
                                                                [m_AnntableVeiw reloadData];
                                                               
                                                           }
                                                       }];
}

-(void)getMessageList {
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/message/list"
                                                            params:@{
                                                                     @"pageSize" : [NSString stringWithFormat:@"%d", 20]
                                                                     ,@"pageOffset" : [NSString stringWithFormat:@"%d", 0]
                                                                     }
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if (!bValidJSON) {
                                                               NSLog(@"%@", errorMsg);
                                                           }
                                                           else {
                                                               NSMutableArray *resultTemp = [[NSMutableArray alloc] init];
                                                               NSMutableArray *rangelist = [[NSMutableArray alloc] init];
                                                               NSInteger location = 0;
                                                               for (NSDictionary *message in result) {
                                                                   
                                                                   [rangelist addObject:[NSNumber numberWithInteger:location]];
                                                                   
                                                                   [resultTemp addObject:message];
                                                                   location += 1;
                                                                   
                                                                   NSArray *replies = [message objectForKey:@"replies"];
                                                                   if (replies) {
                                                                       [resultTemp addObjectsFromArray:[message objectForKey:@"replies"]];
                                                                   }
                                                                   location += replies.count;
                                                               }
                                                               
                                                               communicationInfo = resultTemp;
                                                               communicationInfoRange = rangelist;
                                                               
                                                               [m_ACtableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                                                           }
                                                       }];
}

@end