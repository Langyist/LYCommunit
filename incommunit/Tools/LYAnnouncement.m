//
//  LYAnnouncement.m
//  incommunit
//  公告界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYAnnouncement.h"
#import "LYPublicMethods.h"
#import "LYAnnouncementDetails.h"
#import "XHFriendlyLoadingView.h"

@interface LYAnnouncementCell ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation LYAnnouncementCell

- (void)setFirst:(BOOL)first {
    UIColor *color = [UIColor whiteColor];
    if (first) {
        color = [UIColor colorWithRed:243/255.0f green:226/255.0f blue:197/255.0f alpha:1];
    }
    [self.contentView setBackgroundColor:color];
}

- (void)setTopTag:(BOOL)top {
    self.topImageView.hidden = !top;
}

- (void)setTitleString:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setContentString:(NSString *)text {
    if (!text) {
        text = @"";
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    //    style.lineSpacing = 10;//增加行高
    //    style.headIndent = 10;//头部缩进，相当于左padding
    //    style.tailIndent = -10;//相当于右padding
    //    style.lineHeightMultiple = 1.5;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 20;//首行头缩进
    //    style.paragraphSpacing = 10;//段落后面的间距
    //    style.paragraphSpacingBefore = 20;//段落之前的间距
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, text.length)];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, text.length)];
    
    [self.contentLabel setAttributedText:attrString];
    
    CGFloat height =[self heightOfLabel:@[text] size:CGSizeMake(CGRectGetWidth(self.contentLabel.frame), CGFLOAT_MAX) font:[UIFont systemFontOfSize:14]];
    
    CGRect rect = self.contentLabel.frame;
    rect.size.height = MIN(height, 52);
    self.contentLabel.frame = rect;
}

- (void)setTimestampString:(NSString *)timestamp {
    if (!timestamp) {
        [self.timeLabel setText:@""];
    }
    
    long long timestampInt = [timestamp longLongValue];
    timestampInt /= 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *time = [formatter stringFromDate:date];
    if (!time) {
        [self.timeLabel setText:@""];
        return;
    }
    [self.timeLabel setText:time];
}

- (CGFloat)heightOfLabel:(NSArray *)textList size:(CGSize)size font:(UIFont *)font {
    int length = 0;
    CGFloat height = 0;
    for (NSString *text in textList) {
        length += (int)[self widthOfString:text withFont:font];
    }
    if (length > 0) {
        int count = (int)(length / size.width);
        height = (count + 1) * font.lineHeight;
    }
    return height;
}

//根据字号计算字符串的宽度
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    if (string.length == 0) {
        return 0;
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width + 20;
}

@end

@interface LYAnnouncement ()

@property (nonatomic, strong) XHFriendlyLoadingView *friendlyLoadingView;


@end
@implementation LYAnnouncement
@synthesize m_tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.friendlyLoadingView = [[XHFriendlyLoadingView alloc] initWithFrame:self.view.bounds];
    [self.friendlyLoadingView showFriendlyLoadingViewWithText:@"正在加载..." loadingAnimated:YES];
    [self.view addSubview:self.friendlyLoadingView];
    
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [NSThread detachNewThreadSelector:@selector(getAnnouncement:) toTarget:self withObject:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [notification count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:@"announcementCell" forIndexPath:indexPath];
    NSDictionary *temp = [notification objectAtIndex:indexPath.section];
    [cell setTitleString:[temp objectForKey:@"name"]];
    [cell setContentString:[temp objectForKey:@"content"]];
    [cell setTimestampString:[temp objectForKey:@"create_time"]];
    [cell setTopTag:[[temp objectForKey:@"top"] boolValue]];
    [cell setFirst:(indexPath.section == 0)];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    m_ANNinfo = [notification objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier:@"GoLYAnnouncementDetails" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: @"GoLYAnnouncementDetails"]) {
        LYAnnouncementDetails *detailViewController = (LYAnnouncementDetails*) segue.destinationViewController;
        detailViewController->m_announMessage = m_ANNinfo;
    }
}

#pragma mark 获取网络数据
-(void)getAnnouncement:(NSString *)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString *urlstr =[[NSString alloc] initWithFormat:@"%@/services/notice/get",url] ;
    //NSString *urlstr = [NSString stringWithFormat:@"%@/inCommunity/services/wuye/notice/list",URL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (response!=nil) {
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSString *status = [weatherDic objectForKey:@"status"];
    if (![status isEqual:@"200"])
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:[weatherDic objectForKey:@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
    notification = [weatherDic objectForKey:@"data"];
    NSLog(@"%@",notification);
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_tableView  reloadData];
            // 更新UI
        });
    
    }
    [self.friendlyLoadingView hideLoadingView];
}

@end
