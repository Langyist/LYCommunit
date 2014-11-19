//
//  NCDetailTableViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "NCDetailTableViewController.h"
#import "UIImageView+AsyncDownload.h"

@interface NCDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation NCDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"邻里互助详情"];
    [self setDetailLabelText:[m_detailData objectForKey:@"content"]];
    [self setTimestampString:[m_detailData objectForKey:@"create_time"]];
    [self setTitleLabelText:[m_detailData objectForKey:@"title"]];
    [self setContactLabelText:[m_detailData objectForKey:@"contacts"]];
    [self setPhoneLabelText:[m_detailData objectForKey:@"phone"]];
    
    [self setAuthorNameLabelText:[m_detailData objectForKey:@"nick_name"]];
    
    //可能是多张图片
    [self setTitleImageContent:[m_detailData objectForKey:@"images"]];
    [self setAuthorImageViewContent:[m_detailData objectForKey:@"head"]];
    
    
    self.authorImageView.layer.cornerRadius = CGRectGetWidth(self.authorImageView.frame) / 2;
    self.authorImageView.clipsToBounds = YES;
    self.closeButton.layer.cornerRadius = 3.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (IBAction)close:(id)sender{
    
}

-(void)setTitleImageContent:(NSArray *)array{
    if(0 == [array count]){
        return;
    }
    else{
        //目前只显示一张图片
        if ([[[array objectAtIndex:0] objectForKey:@"path"] length]) {
            NSURL *url = [NSURL URLWithString:[[array objectAtIndex:0] objectForKey:@"path"]];
            [_titleImage setImageWithURL:url placeholderImage:nil];
        }
    }
}

-(void)setAuthorImageViewContent:(NSString *)authorImagePath{
    if(0 == [authorImagePath length]){
        return;
    }
    else {
        if ([authorImagePath length])
        {
            NSURL *url = [NSURL URLWithString:authorImagePath];
            [self.authorImageView setImageWithURL:url placeholderImage:nil];
        }
        self.authorImageView.image = [UIImage imageNamed:authorImagePath];
    }
}

- (void)setDetailLabelText:(NSString *)detail {
    CGFloat newHeight = [NCDetailTableViewController stringHeightWithString:@[detail] size:self.detailLabel.frame.size font:self.detailLabel.font];
    newHeight = MIN(newHeight, 64);
    
    CGRect frame = self.detailLabel.frame;
    frame.size.height = newHeight;
    self.detailLabel.frame = frame;
    
    [self.detailLabel setText:detail];
}
-(void)setTitleLabelText:(NSString*)text{
    CGFloat newHeight = [NCDetailTableViewController stringHeightWithString:@[text] size:self.detailLabel.frame.size font:self.detailLabel.font];
    newHeight = MIN(newHeight, 64);
    
    CGRect frame = self.detailLabel.frame;
    frame.size.height = newHeight;
    self.detailLabel.frame = frame;
    
    [self.titleLabel setText:text];
}
-(void)setContactLabelText:(NSString*)text{
    CGFloat newHeight = [NCDetailTableViewController stringHeightWithString:@[text] size:self.detailLabel.frame.size font:self.detailLabel.font];
    newHeight = MIN(newHeight, 64);
    
    CGRect frame = self.detailLabel.frame;
    frame.size.height = newHeight;
    self.detailLabel.frame = frame;
    
    [self.contactLabel setText:text];
}

-(void)setPhoneLabelText:(NSString*)text{
    CGFloat newHeight = [NCDetailTableViewController stringHeightWithString:@[text] size:self.detailLabel.frame.size font:self.detailLabel.font];
    newHeight = MIN(newHeight, 64);
    
    CGRect frame = self.detailLabel.frame;
    frame.size.height = newHeight;
    self.detailLabel.frame = frame;
    
    [self.phoneLabel setText:text];
}

-(void)setAuthorNameLabelText:(NSString*)text{
    CGFloat newHeight = [NCDetailTableViewController stringHeightWithString:@[text] size:self.detailLabel.frame.size font:self.detailLabel.font];
    newHeight = MIN(newHeight, 64);
    
    CGRect frame = self.detailLabel.frame;
    frame.size.height = newHeight;
    self.detailLabel.frame = frame;
    
    [self.authorNameLabel setText:text];
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
    formatter.dateFormat = @"MM月dd日";
    NSString *time = [formatter stringFromDate:date];
    if (!time) {
        time = @"";
    }
    [self.timeLabel setText:time];
}

+ (CGFloat)stringHeightWithString:(NSArray *)textList size:(CGSize)size font:(UIFont *)font {
    NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
    for (NSMutableString *text in textList) {
        [string appendString:text];
    }
    NSDictionary *attributes =@{NSFontAttributeName:font};//配置字体类型参数
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;//配置字符绘制规则
    CGRect rect = [string boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX) options:options attributes:attributes context:NULL];//计算文本大小
    
    return rect.size.height;
}

-(void)setDetailData:(NSDictionary*)dictionary
{
    m_detailData = dictionary;
}

@end
