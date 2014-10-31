//
//  InfoHeader.m
//  incommunit
//
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "InfoHeader.h"

@interface InfoHeader ()

@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;

@end

@implementation InfoHeader

- (void)awakeFromNib {
    // Initialization code
    
    self.titleBackgroundView.layer.cornerRadius = 5.0f;
    self.titleBackgroundView.clipsToBounds = YES;
}

@end
