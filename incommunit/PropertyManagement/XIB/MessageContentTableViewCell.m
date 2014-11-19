//
//  MessageContentTableViewCell.m
//  incommunit
//
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "MessageContentTableViewCell.h"
#import "UIImageView+MKNetworkKitAdditions.h"

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
        [self.userPhotoImageView setImageFromURL:url placeHolderImage:[UIImage imageNamed:@"default_icon"]];
    }
    else {
        [self.userPhotoImageView setImage:[UIImage imageNamed:@"default_icon"]];
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
    
    CGFloat contentHeight = [MessageContentTableViewCell heightOfLabel:@[content] size:self.contentLabel.frame.size font:self.contentLabel.font];
    CGRect newFrame = self.contentLabel.frame;
    newFrame.size.height = contentHeight;
    self.contentLabel.frame = newFrame;
}

+ (CGFloat)cellHeightWithContent:(NSString *)content {
    CGFloat cellHeight = 0;
    if (!content) {
        content = @"";
    }
    cellHeight = [MessageContentTableViewCell heightOfLabel:@[content] size:CGSizeMake(230, 21) font:[UIFont boldSystemFontOfSize:14]] + 70 - 21;
    cellHeight = MAX(70, cellHeight);
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
