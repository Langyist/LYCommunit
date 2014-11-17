//
//  HLineLabel.m
//  incommunit
//
//  Created by 李忠良 on 14/11/17.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "HLineLabel.h"

@implementation HLineLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGFloat lineWidth = 0.2f;
    CGFloat space = CGRectGetHeight(rect) - lineWidth;
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, lineWidth);
    
    CGContextMoveToPoint(context, 0, space); //start at this point
    
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), space); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end
