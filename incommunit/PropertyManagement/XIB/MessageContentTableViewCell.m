//
//  MessageContentTableViewCell.m
//  incommunit
//
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "MessageContentTableViewCell.h"
#import "UIImageView+AsyncDownload.h"

@interface MessageContentTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation MessageContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.userPhotoImageView.layer.cornerRadius = CGRectGetHeight(self.userPhotoImageView.frame) / 2;
    self.userPhotoImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImagePath:(NSString *)imagePath {
    if (imagePath!=nil && ![imagePath isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:imagePath];
        [self.userPhotoImageView setImageWithURL:url placeholderImage:nil];
    }
}

- (void)setUserName:(NSString *)userName {
    [self.usernameLabel setText:userName];
}

- (void)setTimestamp:(NSString *)timestampString {
    if (!timestampString) {
        [self.timeLabel setText:@""];
    }
    
    long long timestampInt = [timestampString longLongValue];
    timestampInt /= 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"MM月dd日 HH:mm";
    NSString *time = [formatter stringFromDate:date];
    if (!time) {
        time = @"";
    }
    [self.timeLabel setText:time];
}

- (void)setContent:(NSString *)content {
    if (!content) {
        content = @"";
    }
    [self.contentLabel setText:content];
    
    CGFloat contentHeight = [MessageContentTableViewCell stringHeightWithString:@[content] size:self.contentLabel.frame.size font:self.contentLabel.font];
    CGRect newFrame = self.contentLabel.frame;
    newFrame.size.height = contentHeight;
    self.contentLabel.frame = newFrame;
}

+ (CGFloat)cellHeightWithContent:(NSString *)content {
    CGFloat cellHeight = 0;
    cellHeight = [MessageContentTableViewCell stringHeightWithString:@[content] size:CGSizeMake(222, 21) font:[UIFont boldSystemFontOfSize:14]] + 76 - 21;
    cellHeight = MAX(76, cellHeight);
    return cellHeight;
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

@end
