//
//  LYPrivacySettings.m
//  incommunit
// 隐私设置界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYPrivacySettings.h"
#import "AppDelegate.h"

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
    [NSThread detachNewThreadSelector:@selector(getprivacysetting:) toTarget:self withObject:nil];
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
        m_address = [NSMutableArray arrayWithArray:[data objectForKey:@"address"]];
        m_album = [NSMutableArray arrayWithArray:[data objectForKey:@"album"]];
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
    return NO;
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
