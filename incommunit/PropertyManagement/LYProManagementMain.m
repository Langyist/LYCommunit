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
//#import "LYReplyMessage.h"
#import "LYSelectCommunit.h"
#import "LY_AnnouncementNoCell.h"
#import "MessageContentTableViewCell.h"
#import "CommentTableViewCell.h"
#import "InfoHeader.h"
@interface LYProManagementMain () {
    UIView *m_liuView;
}
@end
@implementation LYProManagementMain
@synthesize m_segment;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0];
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
    [self.m_scrollView setScrollEnabled:NO];
    //物业公告
    m_view01 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_scrollView.frame.size.width, self.m_scrollView.frame.size.height)];
    m_AnntableVeiw = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.m_scrollView.frame.size.height)];
    UINib *nib = [UINib nibWithNibName:@"AnnouncementCellNo" bundle:nil];
    [m_AnntableVeiw registerNib:nib forCellReuseIdentifier:@"AnnouncementNoCellidentifier"];
    UINib *nib1 = [UINib nibWithNibName:@"AnnouncementCell" bundle:nil];
    [m_AnntableVeiw registerNib:nib1 forCellReuseIdentifier:@"AnnouncementCellidentifier"];
    m_AnntableVeiw.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_AnntableVeiw.delegate = self;
    m_AnntableVeiw.dataSource = self;
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
    //物业交流
    m_view03 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.m_scrollView.frame.size.width, self.view.frame.size.height)];
    [m_view03 setBackgroundColor:[UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1]];
    UIView *m_ACView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, 320, 100)];
    [m_ACView setBackgroundColor:[UIColor whiteColor]];
    m_ACView.layer.cornerRadius = 0.1;
    
    NSDictionary *temp = [propertyExchangeArray objectAtIndex:0];
    UILabel *m_medthedLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 20)];
    m_medthedLabel.text = @"物管联系方式";
    m_medthedLabel.font = [UIFont boldSystemFontOfSize:15];
    [m_ACView addSubview:m_medthedLabel];
    
    UIView *Gview = [[UIView alloc] initWithFrame:CGRectMake(15, m_medthedLabel.frame.size.height+21, self.view.frame.size.width - 30, 1)];
    Gview.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1];
    [m_ACView addSubview:Gview];
    
    UILabel *m_QQLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 30, 150, 20)];
    m_QQLabel.text = [temp objectForKey:@"contact"];
    m_QQLabel.font = [UIFont boldSystemFontOfSize:13];
    [m_QQLabel setTextColor:[UIColor grayColor]];
    [m_ACView addSubview:m_QQLabel];
    
    UILabel *m_phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 50, 150, 20)];
    m_phoneLabel.text = @"电话:123456798"; //接口没有该数据
    m_phoneLabel.font = [UIFont boldSystemFontOfSize:13];
    [m_phoneLabel setTextColor:[UIColor grayColor]];
    [m_ACView addSubview:m_phoneLabel];
    
    [m_view03 addSubview:m_ACView];
    
    m_liuView = [[UIView alloc] initWithFrame:CGRectMake(0, m_ACView.frame.size.height+12, 320, 35)];
    m_liuView.backgroundColor = [UIColor whiteColor];
    m_liuView.layer.borderWidth = 0.1;
    
    UILabel *liuLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
    liuLabel.text = @"留言薄";
    liuLabel.font = [UIFont boldSystemFontOfSize:15];
    [m_liuView addSubview:liuLabel];
    
    UIButton * m_liuButton = [[UIButton alloc] initWithFrame:CGRectMake(222, 7, 80, 26)];
    [m_liuButton setTitle:@"我要留言" forState:UIControlStateNormal];
    [m_liuButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [m_liuButton addTarget:self action:@selector(liuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    m_liuButton.backgroundColor = [UIColor colorWithRed:(188/255.0f) green:(210/255.0f) blue:(94/255.0f) alpha:1.0];
    m_liuButton.layer.cornerRadius = 5;
    m_liuButton.layer.borderWidth = 0.1;
    [m_liuView addSubview:m_liuButton];
    [m_view03 addSubview:m_liuView];
    
    m_ACtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, m_liuView.frame.origin.y+m_liuView.frame.size.height, m_view03.frame.size.width, m_view03.frame.size.height - 50)];
    m_ACtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [m_ACtableView registerNib:[UINib nibWithNibName:@"MessageContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageContentTableViewCell"];
    [m_ACtableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentTableViewCell"];
    m_view03.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1];
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
    
    UIButton *repairButton = [[UIButton alloc] initWithFrame:CGRectMake(0, m_view04.frame.size.height - 150, 150, 50)];
    repairButton.backgroundColor = [UIColor greenColor];
    repairButton.layer.cornerRadius = 3;
    repairButton.alpha = 0.7;
    [repairButton addTarget:self action:@selector(repairButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [m_view04 addSubview:repairButton];
    
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 30)];
    ImageView.image = [UIImage imageNamed:@"删除_03"];
    [repairButton addSubview:ImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 30)];
    label.text = @"我要报修";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:20];
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
    
    [NSThread detachNewThreadSelector:@selector(GetInfomationInquiryData:) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(GetPropertyExchangeData:) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(GetPropertyServiceData:) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(Getnotification:) toTarget:self withObject:nil];
}

- (void)viewDidAppear:(BOOL)animated {
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
        }];}
    }
}

-(void)m_view02leftSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self.m_scrollView setContentOffset:CGPointMake(2* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 2;
        }];}
    }
}

-(void)m_view02rightSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self.m_scrollView setContentOffset:CGPointMake(0* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 0;
        }];}
    }
}

-(void)m_view03leftSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [self.m_scrollView setContentOffset:CGPointMake(3* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 3;
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
        
        return 2;
    }else if (tableView == m_ACtableView) {
        
        return messageBoardListArray.count;
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
    else if (tableView == m_ACtableView)
    {
        NSDictionary *temp = [messageBoardListArray objectAtIndex:section];
        return 1 + [[temp objectForKey:@"replies"] count];
        
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
    else if (tableView == m_ACtableView)
    {
        NSDictionary *temp = [messageBoardListArray objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            return [MessageContentTableViewCell cellHeightWithContent:[temp objectForKey:@"content"]];
        }
        else {
            NSInteger commentIndex = indexPath.row - 1;
            NSDictionary *dic = [[temp objectForKey:@"replies"] objectAtIndex:commentIndex];
            return [CommentTableViewCell cellHeightWithContent:@[[dic objectForKey:@"nick_name"], [dic objectForKey:@"content"]]];
        }
//        NSDictionary *temp = [messageBoardListArray objectAtIndex:indexPath.row];
//        IDNumber = [[temp objectForKey:@"id"] integerValue];
//        [NSThread detachNewThreadSelector:@selector(getMessageDetailData:) toTarget:self withObject:nil];
//        NSInteger repliesCount = [[specifyMessageDictionary objectForKey:@"replies"] count];
//        return 100 + 21*repliesCount;
    }else if (tableView == m_MaintableView)
    {
        return 144;
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
            //NoCell.lable2.text =  [temp objectForKey:@"content"];
            [NoCell setTextContent:[temp objectForKey:@"content"]];
            //NoCell.lable3.text =  [[NSString alloc]initWithFormat:@"%@",[temp objectForKey:@"create_time"]];
            [NoCell setTimestamp:[temp objectForKey:@"create_time"]];
            NoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return NoCell;
            
        }else if ([[[NSString alloc] initWithFormat:@"%@",[temp objectForKey:@"top"]]isEqual:@"1"])
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCellidentifier"];
            cell.lable1.text = [temp objectForKey:@"name"];
            //cell.lable2.text =  [temp objectForKey:@"content"];
            [cell setTextContent:[temp objectForKey:@"content"]];
            //cell.lable3.text =  [[NSString alloc]initWithFormat:@"%@",[temp objectForKey:@"create_time"]];
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
    }else if (tableView == m_ACtableView)
    {
        NSDictionary *temp = [messageBoardListArray objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            MessageContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageContentTableViewCell" forIndexPath:indexPath];
            [cell setImagePath:[temp objectForKey:@"head"]];
            [cell setUserName:[temp objectForKey:@"nick_name"]];
            [cell setTimestamp:[temp objectForKey:@"create_time"]];
            [cell setContent:[temp objectForKey:@"content"]];
            return cell;
        }
        else {
            NSInteger commentIndex = indexPath.row - 1;
            NSDictionary *dic = [[temp objectForKey:@"replies"] objectAtIndex:commentIndex];
            CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
            [cell setContent:@[[dic objectForKey:@"nick_name"], [dic objectForKey:@"content"]]];
            return cell;
        }
    }
    else if (tableView == m_MaintableView)
    {
        NSDictionary *tempDic = [propertyService objectAtIndex:indexPath.row];
        IDNumber =[[tempDic objectForKey:@"id"] integerValue];
        [NSThread detachNewThreadSelector:@selector(GetPropertyServiceDetailData:) toTarget:self withObject:nil];
        UINib *nib = [UINib nibWithNibName:@"MaintenanceCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"Maintenanceidentifier"];
        LY_MaintenanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Maintenanceidentifier"];
        cell.headNameLabel.text = [specifyPropertyService  objectForKey:@"name"];
        NSString *imageUrl = [specifyPropertyService  objectForKey:@"image_path"];
        if (imageUrl!=nil && ![imageUrl isEqualToString:@""])
        {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [cell.avatarImageView setImageWithURL:url placeholderImage:nil];
        }
        cell.nameLabel.text = [specifyPropertyService  objectForKey:@"nick_name"];
        cell.addressLabel.text = [specifyPropertyService objectForKey:@"position"];
        cell.timeLabel.text =  [NSString stringWithFormat:@"%@",[specifyPropertyService objectForKey:@"create_time"]];
        cell.detailLabel.text = [specifyPropertyService  objectForKey:@"description"];
        NSString *statusString = [NSString stringWithFormat:@"%@",[specifyPropertyService objectForKey:@"status"]];
        if ([statusString isEqualToString:@"0"])
        {
            cell.statusLabel.text = @"待审核";
        }
        else if ([statusString isEqualToString:@"1"])
        {
            cell.statusLabel.text = @"维修中";
        }
        else if ([statusString isEqualToString:@"2"])
        {
            cell.statusLabel.text = @"拒绝维修";
        }
        else  if ([statusString isEqualToString:@"3"])
        {
            cell.statusLabel.text = @"维修完";
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"InfoHeader" owner:self options:nil]; //通过这个方法,取得我们的视图
        InfoHeader *headerView = [nibViews objectAtIndex:0];
        return headerView;//将视图（v_headerView）返回
    }
    else if (tableView == m_ACtableView) {
        
        return nil;
    }
    else if (tableView == m_MaintableView){
        
        return nil;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == m_AnntableVeiw) {
        return 0;
    }
    else if (tableView == m_InfotableView) {
        
        return 40;
    }
    else if (tableView == m_ACtableView) {
        
        return 0;
    }
    else if (tableView == m_MaintableView) {
        
        return 0;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == m_AnntableVeiw) {
        selectedDictionary = [notification objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"NInformation" sender:self];
    }
    if(tableView == m_ACtableView)
    {
        [self performSegueWithIdentifier:@"replyMessage" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([[segue identifier] isEqualToString:@"NInformation"])
//    {
//        if (0 != selectedDictionary.count)
//        {
//            [[segue destinationViewController] setDetailData:selectedDictionary];
//        }
//    }
//    if ([[segue identifier] isEqualToString:@"replyMessage"])
//    {
//        if (0 != selectedDictionary.count)
//        {
//            NSString *idString = [NSString stringWithFormat:@"%@",[specifyMessageDictionary objectForKey:@"id"]];
//            [[segue destinationViewController] setMessageID:idString];
//        }
//    }
}

#pragma mark 获取网络数据
//获取物业公告信息
-(BOOL)Getnotification:(NSString *)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlstr =[[NSString alloc] initWithFormat:@"%@/services/wuye/notice/list",url] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSString *status = [weatherDic objectForKey:@"status"];
    if (![status isEqual:@"200"])
    {
        NSLog(@"%@",[weatherDic objectForKey:@"status"]);
        return false;
    }
    NSLog(@"%@",status);
    notification = [weatherDic objectForKey:@"data"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_AnntableVeiw reloadData];
        // 更新UI
    });
    return true;
}

//获取"信息查询"的相关数据
-(BOOL)GetInfomationInquiryData:(NSString *)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    //物业费用
    NSString *urlString = [NSString stringWithFormat:@"%@/services/wuye/base_infor",url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (nil != error)
    {
        return NO;
    }
    NSDictionary *parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (nil != error)
    {
        return NO;
    }
    if (![[parseData objectForKey:@"status"] isEqualToString:@"200"])
    {
        NSLog(@"%@",[parseData objectForKey:@"status"]);
        return NO;
    }
    propertyExpenseArray = [parseData objectForKey:@"data"];
    urlString = nil;
    request = nil;
    responseData = nil;
    parseData = nil;
    
    urlString = [NSString stringWithFormat:@"%@/services/wuye/express_infor",url];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (nil != error)
    {
        return NO;
    }
    parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (nil != error)
    {
        return NO;
    }
    if (![[parseData objectForKey:@"status"] isEqualToString:@"200"])
    {
        NSLog(@"%@",[parseData objectForKey:@"status"]);
        return NO;
    }
    expressInfomationArray = [parseData objectForKey:@"data"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_InfotableView reloadData];
        // 更新UI
    });
    return YES;
}
//获取"物业交流"的相关数据
-(BOOL)GetPropertyExchangeData:(NSString*)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    //物管联系方式
    NSString *urlString = [NSString stringWithFormat:@"%@/services/wuye/contacts",url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (nil != error)
    {
        return NO;
    }
    NSDictionary *parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (nil != error)
    {
        return NO;
    }
    if (![[parseData objectForKey:@"status"] isEqualToString:@"200"])
    {
        NSLog(@"%@",[parseData objectForKey:@"status"]);
        return NO;
    }
    propertyExchangeArray = [parseData objectForKey:@"data"];
    //留言薄
    urlString = nil;
    request = nil;
    responseData = nil;
    urlString = [NSString stringWithFormat:@"%@/services/wuye/message/list",url];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (nil != error)
    {
        return NO;
    }
    parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (nil != error)
    {
        return NO;
    }
    if (![[parseData objectForKey:@"status"] isEqualToString:@"200"])
    {        return NO;
    }
    messageBoardListArray = [parseData objectForKey:@"data"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_ACtableView  reloadData];
        // 更新UI
    });
    return YES;
}
//获取"物业维修"的相关数据
-(BOOL)GetPropertyServiceData:(NSString*)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlString = [NSString stringWithFormat:@"%@/inCommunity/services/wuye/service/list",url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (nil != error)
    {
        return NO;
    }
    NSDictionary *parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (nil != error)
    {
        return NO;
    }
    if (![[parseData objectForKey:@"status"] isEqualToString:@"200"])
    {
        NSLog(@"%@",[parseData objectForKey:@"status"]);
        return NO;
    }
    propertyService= [parseData objectForKey:@"data"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_MaintableView reloadData];
    });
    return YES;
}

-(BOOL)GetPropertyServiceDetailData:(NSString*)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlString = [NSString stringWithFormat:@"%@/services/wuye/service/detail?id=%ld",url,(long)IDNumber];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (nil != error)
    {
        return NO;
    }
    NSDictionary *parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (nil != error)
    {
        return NO;
    }
    if (![[parseData objectForKey:@"status"] isEqualToString:@"200"])
    {
       NSLog(@"%@",[parseData objectForKey:@"status"]);
        return NO;
    }
    specifyPropertyService= [parseData objectForKey:@"data"];
    return YES;
}

-(BOOL)getMessageDetailData:(NSString*)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlString = [NSString stringWithFormat:@"%@/services/wuye/message/detail?id=%ld",url,(long)IDNumber];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (nil != error)
    {
        return NO;
    }
    NSDictionary *parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (nil != error)
    {
        return NO;
    }
    if (![[parseData objectForKey:@"status"] isEqualToString:@"200"])
    {
        NSLog(@"%@",[parseData objectForKey:@"status"]);
        return NO;
    }
    specifyMessageDictionary= [parseData objectForKey:@"data"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [m_AnntableVeiw reloadData];
    });
    return YES;
}
@end