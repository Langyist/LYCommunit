//
//  InsetTextField.m
//  LALA
//
//  Created by 李忠良 on 14-8-15.
//  Copyright (c) 2014年 BigChance. All rights reserved.
//

#import "InsetTextField.h"

@implementation InsetTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textInset = UIEdgeInsetsZero;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:212/255.0f green:210/255.0f blue:210/255.0f alpha:1] CGColor]);
    CGContextSetLineWidth(context, 1.0);
    //top line
    CGContextMoveToPoint(context, 0.0, 0.0);
    CGContextAddLineToPoint(context, self.frame.size.width, 0.0);
    CGContextDrawPath(context, kCGPathStroke);
    //bottom line
    CGContextMoveToPoint(context, 0.0, CGRectGetHeight(self.frame));
    CGContextAddLineToPoint(context, self.frame.size.width, CGRectGetHeight(self.frame));
    CGContextDrawPath(context, kCGPathStroke);
}


- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect textRectForBounds = [super textRectForBounds:bounds];
    textRectForBounds = UIEdgeInsetsInsetRect(textRectForBounds, _textInset);
    return textRectForBounds;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect placeholderRectForBounds = [super placeholderRectForBounds:bounds];
    //placeholderRectForBounds = UIEdgeInsetsInsetRect(placeholderRectForBounds, _textInset);
    return placeholderRectForBounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect editingRectForBounds = [super textRectForBounds:bounds];
    editingRectForBounds = UIEdgeInsetsInsetRect(editingRectForBounds, _textInset);
    return editingRectForBounds;
}

@end
