//
//  LY_AnnouncementCell.m
//  in_community
//
//  Created by LangYi on 14-10-8.
//  Copyright (c) 2014年 LangYi. All rights reserved.
//

#import "LY_AnnouncementCell.h"
@implementation LY_AnnouncementCell
@synthesize lable1,lable2,lable3,m_imageview,m_iamge,label4;
- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.label4.transform = CGAffineTransformMakeRotation(M_PI/-4);
}
- (void)setImage:(UIImage *)img
{
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
    style.lineSpacing = 10;//增加行高
    style.headIndent = 10;//头部缩进，相当于左padding
    style.tailIndent = -10;//相当于右padding
    style.lineHeightMultiple = 1.5;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 20;//首行头缩进
    style.paragraphSpacing = 10;//段落后面的间距
    style.paragraphSpacingBefore = 20;//段落之前的间距
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, text.length)];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:129/255.0f green:129/255.0f blue:129/255.0f alpha:1] range:NSMakeRange(0, text.length)];

    CGSize newSize = [text sizeWithAttributes:@{
                                 NSParagraphStyleAttributeName : style
                                 ,NSFontAttributeName : [UIFont boldSystemFontOfSize:14]
                                 ,NSForegroundColorAttributeName : [UIColor colorWithRed:129/255.0f green:129/255.0f blue:129/255.0f alpha:1]
                                 }];
    
    [lable2 setAttributedText:attrString];
    
    newSize.height = MIN(newSize.height, 55);
    CGRect rect = lable2.frame;
    rect.size.height = newSize.height;
    lable2.frame = rect;
}

@end
