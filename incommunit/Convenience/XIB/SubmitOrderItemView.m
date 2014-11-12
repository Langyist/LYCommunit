//
//  SubmitOrderItemView.m
//  incommunit
//
//  Created by 李忠良 on 14/11/11.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "SubmitOrderItemView.h"

@interface SubmitOrderItemView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation SubmitOrderItemView

- (void)setName:(NSString *)name {
    [self.nameLabel setText:name];
}

- (void)setPrice:(CGFloat)price {
    NSString *priceString = [NSString stringWithFormat:@"￥%.2f", price];
    [self.priceLabel setText:priceString];
}

- (void)setNumber:(NSInteger)number {
    NSString *numberString = [NSString stringWithFormat:@"x%ld", (long)number];
    [self.numberLabel setText:numberString];
}

@end
