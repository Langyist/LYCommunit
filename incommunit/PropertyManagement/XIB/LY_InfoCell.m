//
//  LY_InfoCell.m
//  in_community
//
//  Created by LangYi on 14-10-9.
//  Copyright (c) 2014年 LangYi. All rights reserved.
//

#import "LY_InfoCell.h"
#import "UILabel+Size.h"
#import "NSString+Size.h"

@interface LY_InfoCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;

@property (strong, nonatomic) IBOutlet UILabel *costLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation LY_InfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNameText:(NSString *)name {
    [self.nameLabel setText:name];
    [self.nameLabel resizeFixedWidth:YES];
    CGRect rect = self.infoImageView.frame;
    rect.origin.x = CGRectGetMaxX(self.nameLabel.frame) + 3;
    self.infoImageView.frame = rect;
}

- (void)setCostText:(NSString *)cost {
    NSString *costString = [NSString stringWithFormat:@"%@", cost];
    CGFloat costNumber = [costString floatValue];
    costString = [NSString stringWithFormat:@"￥%.2f", costNumber];
    [self.costLabel setText:costString];
}

- (void)setTimeText:(NSString *)timestamp {
    NSString *timeString = @"";
    if (timestamp) {
        timeString = [timestamp convertTimeStampWithFormat:@"MM月dd日 HH:mm"];
    }
    [self.timeLabel setText:timeString];
}

@end
