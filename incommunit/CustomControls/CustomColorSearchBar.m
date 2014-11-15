//
//  CustomColorSearchBar.m
//  incommunit
//
//  Created by 李忠良 on 14/11/10.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "CustomColorSearchBar.h"
#import "AppDelegate.h"
@implementation CustomColorSearchBar

- (void)customizeInterface {
    self.barTintColor = BK_GRAY;
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [BK_GRAY CGColor];
}

- (void)awakeFromNib {
    [self customizeInterface];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customizeInterface];
    }
    return self;
}


@end
