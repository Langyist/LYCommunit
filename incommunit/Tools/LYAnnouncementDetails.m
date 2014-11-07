//
//  LYAnnouncementDetailsViewController.m
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYAnnouncementDetails.h"

@interface LYAnnouncementDetails ()

@end

@implementation LYAnnouncementDetails
@synthesize m_image;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:[m_announMessage objectForKey:@"image_path"]];
    if (url!=nil&&![url isEqual:@""])
    {
        [m_image setImageWithURL:url placeholderImage:nil];
    }
    [self.titleLabel setText:[m_announMessage objectForKey:@"name"]];
    [self setTextContent:[m_announMessage objectForKey:@"content"]];
    [self setTimestamp:@"create_time"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self.contentLabel setAttributedText:attrString];
    
    CGFloat height =[self heightOfLabel:@[text] size:CGSizeMake(CGRectGetWidth(self.contentLabel.frame), CGFLOAT_MAX) font:[UIFont systemFontOfSize:14]];
    
    CGRect rect = self.contentLabel.frame;
    rect.size.height = height;
    self.contentLabel.frame = rect;
    
    CGRect timeLabelFrame = self.timeLabel.frame;
    timeLabelFrame.origin.y = CGRectGetMaxY(rect) + 20;
    self.timeLabel.frame= timeLabelFrame;
    
    [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(timeLabelFrame) + 50)];
}

- (void)setTimestamp:(NSString *)timestamp {
    if (!timestamp) {
        [self.timeLabel setText:@""];
    }
    
    long long timestampInt = [timestamp longLongValue];
    timestampInt /= 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy年MM月dd日";
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
