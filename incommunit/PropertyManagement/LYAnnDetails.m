//
//  LYAnnouncementDetails.m
//  in_community
//  物业公告详情
//  Created by LANGYI on 14-10-11.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYAnnDetails.h"
#import "UIImageView+AsyncDownload.h"

@interface LYAnnDetails ()

@end

@implementation LYAnnDetails
@synthesize m_iamgeview,m_infoLabel,m_timeLabel,m_titleLabel;
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
    
    NSURL *url = [NSURL URLWithString:[detailDataDictorynary objectForKey:@"image_path"]];
    if (url!=nil&&![[[NSString alloc] initWithFormat:@"%@",url] isEqual:@""])

    {
        [m_iamgeview setImageWithURL:url placeholderImage:nil];
    }
    
    m_titleLabel.text= [detailDataDictorynary objectForKey:@"name"];
    [self setTextContent:[detailDataDictorynary objectForKey:@"content"]];
    [self setTimestamp:[detailDataDictorynary objectForKey:@"create_time"]];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDetailData:(NSDictionary*)dic {
    detailDataDictorynary = dic;
}

- (void)setTextContent:(NSString *)text {
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
    
    [m_infoLabel setAttributedText:attrString];
    
    CGFloat height =[self heightOfLabel:@[text] size:CGSizeMake(CGRectGetWidth(m_infoLabel.frame), CGFLOAT_MAX) font:[UIFont systemFontOfSize:14]];
    
    CGRect rect = m_infoLabel.frame;
    rect.size.height = height;
    m_infoLabel.frame = rect;
    
    CGRect timeLabelFrame = m_timeLabel.frame;
    timeLabelFrame.origin.y = CGRectGetMaxY(rect) + 20;
    m_timeLabel.frame= timeLabelFrame;
    
    [self.m_scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(timeLabelFrame) + 50)];
}

- (void)setTimestamp:(NSString *)timestamp {
    if (!timestamp) {
        [m_timeLabel setText:@""];
    }
    
    long long timestampInt = [timestamp longLongValue];
    timestampInt /= 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *time = [formatter stringFromDate:date];
    if (!time) {
        [m_timeLabel setText:@""];
        return;
    }
    [m_timeLabel setText:time];
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
