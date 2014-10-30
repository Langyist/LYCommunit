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
@interface LYProManagementMain ()
@end
@implementation LYProManagementMain
@synthesize m_segment;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0];
    [m_segment addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width * 3, self.m_scrollView.frame.size.height);
    [self.m_scrollView setScrollEnabled:NO];
    //物业公告
    m_view01 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_scrollView.frame.size.width, self.m_scrollView.frame.size.height)];
    m_AnntableVeiw = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    m_AnntableVeiw.delegate = self;
    m_AnntableVeiw.dataSource = self;
    [m_view01 addSubview:m_AnntableVeiw];
    [self.m_scrollView addSubview:m_view01];
    //信息查询
    m_view02 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.m_scrollView.frame.size.width, self.m_scrollView.frame.size.height)];
    m_InfotableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, m_view02.frame.size.width, m_view02.frame.size.height)];
    _m_scrollView.backgroundColor = [UIColor grayColor];
    m_InfotableView.delegate = self;
    m_InfotableView.dataSource = self;
    [m_view02 addSubview:m_InfotableView];
    [self.m_scrollView addSubview:m_view02];
    //物业交流
    m_view03 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.m_scrollView.frame.size.width, self.view.frame.size.height)];
    UIView *m_ACView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, 320, 100)];
    [m_ACView setBackgroundColor:[UIColor whiteColor]];
    m_ACView.layer.cornerRadius = 0.1;
    
    NSDictionary *temp = [propertyExchangeArray objectAtIndex:0];
    UILabel *m_medthedLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 20)];
    m_medthedLabel.text = @"物管联系方式";
    m_medthedLabel.font = [UIFont systemFontOfSize:16];
    [m_ACView addSubview:m_medthedLabel];
    
    UIView *Gview = [[UIView alloc] initWithFrame:CGRectMake(15, m_medthedLabel.frame.size.height+10, self.view.frame.size.width - 30, 1)];
    Gview.backgroundColor = [UIColor grayColor];
    [m_ACView addSubview:Gview];
    
    UILabel *m_QQLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 150, 20)];
    m_QQLabel.text = [temp objectForKey:@"contact"];
    m_QQLabel.font = [UIFont systemFontOfSize:14];
    [m_ACView addSubview:m_QQLabel];
    
    UILabel *m_phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 150, 20)];
    m_phoneLabel.text = @"电话:123456798"; //接口没有该数据
    m_phoneLabel.font = [UIFont systemFontOfSize:14];
    [m_ACView addSubview:m_phoneLabel];
    
    [m_view03 addSubview:m_ACView];
    
    UIView *m_liuView = [[UIView alloc] initWithFrame:CGRectMake(0, m_ACView.frame.size.height+12, 320, 50)];
    m_liuView.backgroundColor = [UIColor whiteColor];
    m_liuView.layer.borderWidth = 0.1;
    
    UILabel *liuLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 80, 30)];
    liuLabel.text = @"留言薄";
    liuLabel.font = [UIFont systemFontOfSize:18];
    [m_liuView addSubview:liuLabel];
    
    UIView *GLview = [[UIView alloc] initWithFrame:CGRectMake(15, liuLabel.frame.size.height+10, self.view.frame.size.width-30, 1)];
    GLview.backgroundColor = [UIColor grayColor];
    [m_liuView addSubview:GLview];
    
    UIButton *m_liuButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 2, 100, 36)];
    [m_liuButton setTitle:@"我要留言" forState:UIControlStateNormal];
    [m_liuButton addTarget:self action:@selector(liuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    m_liuButton.backgroundColor = [UIColor colorWithRed:(118.0/255) green:(238.0/255) blue:(0.0/255) alpha:1.0];
    m_liuButton.layer.cornerRadius = 5;
    m_liuButton.layer.borderWidth = 0.1;
    [m_liuView addSubview:m_liuButton];
    [m_view03 addSubview:m_liuView];
    
    m_ACtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, m_liuView.frame.origin.y+m_liuView.frame.size.height, m_view03.frame.size.width, m_view03.frame.size.height - 50)];
    m_view03.backgroundColor = [UIColor grayColor];
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
        
        return 1;
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
        return messageBoardListArray.count;   //后期数据量多了，需要做分页，否则加载此页面会很慢
        
    }else if (tableView == m_MaintableView)
    {
        return propertyService.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == m_AnntableVeiw) {
        return 145;
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
        NSDictionary *temp = [messageBoardListArray objectAtIndex:indexPath.row];
        IDNumber = [[temp objectForKey:@"id"] integerValue];
        [NSThread detachNewThreadSelector:@selector(getMessageDetailData:) toTarget:self withObject:nil];
        NSInteger repliesCount = [[specifyMessageDictionary objectForKey:@"replies"] count];
        return 100 + 21*repliesCount;
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
            UINib *nib = [UINib nibWithNibName:@"AnnouncementCellNo" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"AnnouncementNoCellidentifier"];
            NoCell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementNoCellidentifier"];
            [UINib nibWithNibName:@"AnnouncementCell" bundle:nil];
            NoCell.lable1.text = [temp objectForKey:@"name"];
            NoCell.lable2.text =  [temp objectForKey:@"content"];
            NoCell.lable3.text =  [[NSString alloc]initWithFormat:@"%@",[temp objectForKey:@"create_time"]];
            NoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return NoCell;
            
        }else if ([[[NSString alloc] initWithFormat:@"%@",[temp objectForKey:@"top"]]isEqual:@"1"])
        {
            UINib *nib = [UINib nibWithNibName:@"AnnouncementCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"AnnouncementCellidentifier"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementCellidentifier"];
            [UINib nibWithNibName:@"AnnouncementCell" bundle:nil];
            cell.lable1.text = [temp objectForKey:@"name"];
            cell.lable2.text =  [temp objectForKey:@"content"];
            cell.lable3.text =  [[NSString alloc]initWithFormat:@"%@",[temp objectForKey:@"create_time"]];
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
    }else if (tableView == m_ACtableView)
    {
        NSDictionary *temp = [messageBoardListArray objectAtIndex:indexPath.row];
        IDNumber = [[temp objectForKey:@"id"] integerValue];
        UINib *nib = [UINib nibWithNibName:@"ACCell1" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"ACCellIdentifier1"];
        LY_ACCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ACCellIdentifier1"];
        NSString *imageUrl = [specifyMessageDictionary objectForKey:@"head"];
        if (imageUrl!=nil && ![imageUrl isEqualToString:@""])
        {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [cell.m_imageView setImageWithURL:url placeholderImage:nil];
        }
        cell.nameLabel.text = [specifyMessageDictionary objectForKey:@"nick_name"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@",[specifyMessageDictionary objectForKey:@"create_time"]];
        cell.contentLabel.text = [specifyMessageDictionary objectForKey:@"content"];
        for (int i = 0; i < [[specifyMessageDictionary objectForKey:@"replies"] count]; ++i)
        {
            NSDictionary *dic = [[specifyMessageDictionary objectForKey:@"replies"] objectAtIndex:i];
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 56 + i * 20, 80, 20)];
            nameLabel.text = [NSString stringWithFormat:@"%@:",[dic objectForKey:@"nick_name"]];
            [cell addSubview:nameLabel];
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 56 + i * 20, 100, 20)];
            contentLabel.text = [dic objectForKey:@"content"]; //需要考虑换行或者显示...
            [cell addSubview:contentLabel];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
        UIView *m_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];//创建一个视图（v_headerView）
        m_headerView.backgroundColor = [UIColor whiteColor];
        UIView *m_downView = [[UIView alloc] initWithFrame:CGRectMake(10, 49, 315, 1)];
        m_downView.backgroundColor = [UIColor redColor];
        [m_headerView addSubview:m_downView];
        UILabel *m_headerLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 80, 48)];
        m_headerLab.layer.cornerRadius = 5;
        m_headerLab.layer.borderWidth = 0.1;
        m_headerLab.layer.borderColor = [[UIColor redColor]CGColor];
        m_headerLab.textColor = [UIColor redColor];
        m_headerLab.font = [UIFont systemFontOfSize:20];
        [m_headerView addSubview:m_headerLab];
        UILabel *m_addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 15, 150, 20)];
        m_addressLabel.textColor = [UIColor blackColor];
        m_addressLabel.font = [UIFont systemFontOfSize:15];
        [m_headerView addSubview:m_addressLabel];
        //设置每组的的标题
        if (section == 0) {
            m_headerLab.text = @"费用信息";
            m_addressLabel.text = [[propertyExpenseArray objectAtIndex:0] objectForKey:@"address"];//地址
        }
        if (section == 1) {
            m_headerLab.text = @"快递信息";
            //m_addressLabel.text = [[expressInfomationArray objectAtIndex:0] objectForKey:@"phone"]; //电话
        }
        return m_headerView;//将视图（v_headerView）返回
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
        
        return 50;
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
        // 更新UI
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
        // 更新UI
    });
    return YES;
}
@end