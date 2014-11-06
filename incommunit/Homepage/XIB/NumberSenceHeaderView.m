//
//  NumberSenceHeaderView.m
//  incommunit
//
//  Created by 李忠良 on 14/11/6.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "NumberSenceHeaderView.h"

@interface NumberSenceHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation NumberSenceHeaderView

- (void)awakeFromNib {
    self.colorView.layer.cornerRadius = 5.0f;
}

- (void)setName:(NSString *)name {
    [self.nameLabel setText:name];
}

@end
