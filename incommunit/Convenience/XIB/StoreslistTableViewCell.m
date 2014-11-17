//
//  StoreslistTableViewCell.m
//  incommunit
//
//  Created by 李忠良 on 14/10/30.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "StoreslistTableViewCell.h"
#import "AppDelegate.h"

@implementation StoreslistTableViewCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, SPECIAL_GRAY.CGColor);
    
    CGFloat linewidth = 0.2f;
    CGContextSetLineWidth(context, linewidth);
    
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect) - linewidth);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect) - linewidth);
    
    CGContextStrokePath(context);
}

- (void)awakeFromNib {
    // Initialization code
    
    self.oreginPriceLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOreginPrice:(NSString *)price {
    self.oreginPriceLabel.hidden = !price;
    [self.oreginPriceLabel setText:price];
}

@end
