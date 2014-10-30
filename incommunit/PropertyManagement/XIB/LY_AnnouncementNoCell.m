//
//  LY_AnnouncementCell.m
//  in_community
//
//  Created by LangYi on 14-10-8.
//  Copyright (c) 2014年 LangYi. All rights reserved.
//

#import "LY_AnnouncementNoCell.h"
@implementation LY_AnnouncementNoCell
@synthesize lable1,lable2,lable3,m_imageview,m_iamge,label4;
- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.label4.transform = CGAffineTransformMakeRotation(M_PI/-4);
}

- (void)setImage:(UIImage *)img {
    if (![img isEqual:m_iamge]) {
        m_iamge = [img copy];
        self.m_imageview.image = m_iamge;
    }
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
    
    [lable2 setAttributedText:attrString];
    
    CGFloat height =[self heightOfLabel:@[text] size:CGSizeMake(CGFLOAT_MAX, CGRectGetWidth(lable2.frame)) font:lable2.font];
    
    CGRect rect = lable2.frame;
    rect.size.height = MIN(height, 55);
    lable2.frame = rect;
}

- (void)setTimestamp:(NSString *)timestamp {
    if (!timestamp) {
        [lable3 setText:@""];
    }
    
    long long timestampInt = [timestamp longLongValue];
    timestampInt /= 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *time = [formatter stringFromDate:date];
    if (!time) {
        [lable3 setText:@""];
        return;
    }
    [lable3 setText:time];
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
