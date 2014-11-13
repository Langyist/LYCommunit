//
//  LYPrivacySettings.m
//  incommunit
// 隐私设置界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYPrivacySettings.h"
#import "AppDelegate.h"
#import "StoreOnlineNetworkEngine.h"

@interface TitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UISwitch *switchUI;

@end

@implementation TitleCell

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, TOP_BAR_YELLOW.CGColor);
    
    CGFloat linewidth = 2.0f;
    CGFloat space = 15;
    CGContextSetLineWidth(context, linewidth);
    
    CGContextMoveToPoint(context, space, CGRectGetHeight(rect) - linewidth); //start at this point
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - space, CGRectGetHeight(rect) - linewidth);
    
    CGContextStrokePath(context);
}

@end

@interface ContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation ContentCell

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, SEPLINE_GRAY.CGColor);
    
    CGFloat linewidth = 0.2f;
    CGFloat space = 15;
    CGContextSetLineWidth(context, linewidth);
    
    CGContextMoveToPoint(context, space, CGRectGetHeight(rect) - linewidth); //start at this point
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - space, CGRectGetHeight(rect) - linewidth);
    
    CGContextStrokePath(context);
}

@end

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
    
    NSArray *contentTitle;
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
    [self getprivacysetting ];
    contentTitle = @[@"朋友可见"
                     ,@"实名用户可见"
                     ,@"注册用户可见"
                     ,@"所有人可见"
                     ];
    
    m_UIbuttonArry = [[NSMutableArray alloc] init];
    select = [[NSMutableDictionary alloc] init];
    m_UIbutton = [[NSMutableArray alloc] init];
    isselect= YES;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    address = [NSMutableArray arrayWithCapacity:4];
    album = [NSMutableArray arrayWithCapacity:4];
    
    m_address = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @"0"]];
    m_album = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @"0"]];
    m_addfriend = @"0";
}

#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    }
    else {
        return 43;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 5;
    }
    else if (section == 1) {
        return 5;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *retcell = nil;
    
    NSString *title = @"";
    NSArray *data = nil;
    BOOL hideSwitch = YES;
    switch (indexPath.section) {
        case 0: {
            title = @"我的住址";
            data = m_address;
            hideSwitch = YES;
        }
            break;
        case 1: {
            title = @"我的相册";
            data = m_album;
            hideSwitch = YES;
        }
            break;
        case 2: {
            title = @"加我为朋友时是否需要验证";
            data = nil;
            hideSwitch = NO;
        }
            break;
        default:
            break;
    }
    
    if (indexPath.row == 0) {
        TitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell" forIndexPath:indexPath];
        [cell.name setText:title];
        cell.switchUI.hidden = hideSwitch;
        if (!hideSwitch) {
            [cell.switchUI setOn:[m_addfriend boolValue]];
            [cell.switchUI addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.switchUI.tag = indexPath.section;
        }
        retcell = cell;
    }
    else {
        ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        [cell.name setText:[contentTitle objectAtIndex:indexPath.row - 1]];
        
        NSString *value = [data objectAtIndex:indexPath.row - 1];
        NSString *imageName = @"Unselected";
        if([value intValue] == 1) {
            imageName = @"Selected";
        }
        
        [cell.checkImageView setImage:[UIImage imageNamed:imageName]];
        
        retcell = cell;
    }
    
    retcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return retcell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *data = nil;
    switch (indexPath.section) {
        case 0: {
            data = m_address;
        }
            break;
        case 1: {
            data = m_album;
        }
            break;
        default:
            break;
    }
    if (data && indexPath.row != 0) {
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 1:
                    {
                        NSString *value = [data objectAtIndex:indexPath.row - 1];
                        if ([value boolValue]) {
                            address1 = @"0";
                        }
                        else {
                            address1 = @"1";
                        }
                    }
                        
                        break;
                    case 2:
                    {
                        NSString *value = [data objectAtIndex:indexPath.row - 1];
                        if ([value boolValue]) {
                            address2 = @"0";
                        }
                        else {
                            address2 = @"1";
                        }
                    }
                        break;
                    case 3:
                    {
                        NSString *value = [data objectAtIndex:indexPath.row - 1];
                        if ([value boolValue]) {
                            address3 = @"0";
                        }
                        else {
                            address3 = @"1";
                        }
                    }
                        break;
                    case 4:
                    {
                        NSString *value = [data objectAtIndex:indexPath.row - 1];
                        if ([value boolValue]) {
                            address4 = @"0";
                        }
                        else {
                            address4 = @"1";
                        }
                    }
                        break;
                    default:
                        break;
                }
                break;
            case 1:
            {
            
                switch (indexPath.row) {
                    case 1:
                    {
                        NSString *value = [data objectAtIndex:indexPath.row - 1];
                        if ([value boolValue]) {
                            album1 = @"0";
                        }
                        else {
                            album1 = @"1";
                        }
                    }
                        
                        break;
                    case 2:
                    {
                        NSString *value = [data objectAtIndex:indexPath.row - 1];
                        if ([value boolValue]) {
                            album2 = @"0";
                        }
                        else {
                            album2 = @"1";
                        }
                    }
                        break;
                    case 3:
                    {
                        NSString *value = [data objectAtIndex:indexPath.row - 1];
                        if ([value boolValue]) {
                            album3 = @"0";
                        }
                        else {
                            album3 = @"1";
                        }
                    }
                        break;
                    case 4:
                    {
                        NSString *value = [data objectAtIndex:indexPath.row - 1];
                        if ([value boolValue]) {
                            album4 = @"0";
                        }
                        else {
                            album4 = @"1";
                        }
                    }
                        break;
                    default:
                        break;
                }

            }
            default:
                break;
        }
        NSString *value = [data objectAtIndex:indexPath.row - 1];
        if ([value boolValue]) {
            value = @"0";
        }
        else {
            value = @"1";
        }
        [data setObject:value atIndexedSubscript:indexPath.row - 1];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)Submit
{
    NSDictionary *dic =@{@"address" :address1
                        ,@"address" :address2
                        ,@"address" :address3
                        ,@"address" :address4
                        ,@"album" : album1
                        ,@"album" : album2
                        ,@"album" : album3
                        ,@"album" : album4};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/visible_setting/set"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:NO
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
                                                               NSLog(@"%@",errorMsg);
                                                           }else
                                                           {
                                                               addfriend = [result objectForKey:@"add_friend"];
                                                               address = [result objectForKey:@"address"];
                                                               album = [result objectForKey:@"album"];
                                                               [m_tableView reloadData];
                                                           }}];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self Submit];
}

- (void)valueChanged:(UISwitch *)sender {
    if ([m_addfriend boolValue]) {
        m_addfriend = @"0";
    }
    else {
        m_addfriend = @"1";
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
    [m_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
@end
