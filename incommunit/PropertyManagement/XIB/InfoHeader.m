//
//  InfoHeader.m
//  incommunit
//
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "InfoHeader.h"
#import "NSString+Size.h"

@interface InfoHeader ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;

@end

@implementation InfoHeader

- (void)awakeFromNib {
    // Initialization code
    
    self.titleBackgroundView.layer.cornerRadius = 5.0f;
    self.titleBackgroundView.clipsToBounds = YES;
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setTime:(NSString *)timestamp {
    NSString *timeString = @"";
    if (timestamp) {
        timestamp = [NSString stringWithFormat:@"%@", timestamp];
        timeString = [timestamp convertTimeStampWithFormat:@"MM月dd日HH:mm"];
    }
    [self.timeLabel setText:timeString];
}

- (void)setAddress:(NSString *)address {
    [self.addressLabel setText:address];
    self.timeLabel.hidden = YES;
}

- (void)setPhone:(NSString *)phone {
    [self.addressLabel setText:phone];
    self.timeLabel.hidden = NO;
}

@end
