//
//  ArrowButton.m
//  incommunit
//
//  Created by 李忠良 on 14/11/6.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "ArrowButton.h"

@implementation ArrowButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat width = [self widthOfString:self.titleLabel.text withFont:self.titleLabel.font];
    CGFloat x = CGRectGetMinX(self.titleLabel.frame)
                + (CGRectGetWidth(self.titleLabel.frame) - width) / 2
                + CGRectGetWidth(self.titleLabel.frame)
                + 13;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    // Draw them with a 1.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.5f);
    
    CGContextMoveToPoint(context, x, self.titleLabel.center.y - 2); //start at this point
    
    CGContextAddLineToPoint(context, x + 4, self.titleLabel.center.y + 2); //draw to this point
    
    CGContextAddLineToPoint(context, x + 8, self.titleLabel.center.y - 2); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    if (string.length == 0) {
        return 0;
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width + 20;
}

@end
