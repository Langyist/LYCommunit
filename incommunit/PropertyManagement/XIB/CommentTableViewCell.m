//
//  CommentTableViewCell.m
//  incommunit
//
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.colorView.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(NSArray *)contentList {
    //自定义字符串的显示格式，包括字体和颜色
    NSMutableAttributedString *stringNew = [[NSMutableAttributedString alloc] init];
    NSString *username = @"";
    if (contentList.count >= 1) {
        username = [contentList objectAtIndex:0];
    }
    NSString *message = @"";
    if (contentList.count >= 2) {
        message = [contentList objectAtIndex:1];
    }
    
    NSString *string = [NSString stringWithFormat:@"%@：%@", username, message];
    stringNew = [[NSMutableAttributedString alloc] initWithString:string];
    [stringNew addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:85 / 255.0 green:142 / 255.0 blue:209 / 255.0 alpha:1] range:NSMakeRange(0, username.length)];// 用户名
    [stringNew addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(username.length, 1)];// 冒号
    [stringNew addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(username.length + 1, message.length)];// 消息内容
    [stringNew addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(0, string.length)];
    
    [self.contentLabel setAttributedText:stringNew];
    
    CGFloat newHeight = [CommentTableViewCell heightOfLabel:contentList size:self.contentLabel.frame.size font:[UIFont boldSystemFontOfSize:12]];
    CGRect newFrame = self.contentLabel.frame;
    newFrame.size.height = newHeight;
    self.contentLabel.frame = newFrame;
    
    newFrame = self.colorView.frame;
    newFrame.size.height = CGRectGetHeight(self.frame);
    self.colorView.frame = newFrame;
}

+ (CGFloat)cellHeightWithContent:(NSArray *)contentList {
    CGFloat cellHeight = 0;
    cellHeight = [CommentTableViewCell heightOfLabel:contentList size:CGSizeMake(214, 12) font:[UIFont boldSystemFontOfSize:12]] + 20 - 12;
    cellHeight = MAX(20, cellHeight);
    return cellHeight;
}

+ (CGFloat)heightOfLabel:(NSArray *)textList size:(CGSize)size font:(UIFont *)font {
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
+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    if (string.length == 0) {
        return 0;
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

@end
