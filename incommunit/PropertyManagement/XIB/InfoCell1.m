//
//  InfoCell1.m
//  incommunit
//
//  Created by 李忠良 on 14/11/20.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "InfoCell1.h"
#import "AppDelegate.h"

@interface InfoCell1 ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *isGetLabel;

@end

@implementation InfoCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)name {
    [self.nameLabel setText:name];
}

- (void)setNumber:(NSString *)number {
    NSString *numberString = [NSString stringWithFormat:@"%@", number];
    NSInteger numberInt = [numberString integerValue];
    numberString = [NSString stringWithFormat:@"%d件", numberInt];
    [self.numberLabel setText:numberString];
}

- (void)setIsGet:(NSString *)isGet {
    NSString *isGetString = [NSString stringWithFormat:@"%@", isGet];
    NSInteger statusInt = [isGetString integerValue];
    if (statusInt == 0) {
        [self.isGetLabel setText:@"领取"];
        [self.isGetLabel setTextColor:[UIColor whiteColor]];
        [self.isGetLabel setBackgroundColor:SPECIAL_GREEN];
        self.isGetLabel.clipsToBounds = YES;
        self.isGetLabel.layer.cornerRadius = 3.0f;
    }
    else {
        [self.isGetLabel setText:@"已领取"];
        [self.isGetLabel setTextColor:[UIColor darkGrayColor]];
        [self.isGetLabel setBackgroundColor:[UIColor clearColor]];
    }
}

@end
