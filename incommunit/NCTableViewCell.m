//
//  NCTableViewCell.m
//  incommunit
//
//  Created by 李忠良 on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "NCTableViewCell.h"
#import "UIImageView+AsyncDownload.h"

@interface NCTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation NCTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.titleImageView.layer.cornerRadius = CGRectGetWidth(self.titleImageView.frame);
    self.titleImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleImagePath:(NSString *)path {
    if (path!=nil && ![path isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:path];
        [self.titleImageView setImageWithURL:url placeholderImage:nil];
    }
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setContent:(NSString *)content {
    
    CGFloat newHeight = [NCTableViewCell stringHeightWithString:@[content] size:self.contentLabel.frame.size font:self.contentLabel.font];
    newHeight = MAX(newHeight, 37);
    
    CGRect frame = self.contentLabel.frame;
    frame.size.height = newHeight;
    self.contentLabel.frame = frame;
    
    [self.contentLabel setText:content];
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

@end
