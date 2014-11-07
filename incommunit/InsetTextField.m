//
//  InsetTextField.m
//  LALA
//
//  Created by 李忠良 on 14-8-15.
//  Copyright (c) 2014年 BigChance. All rights reserved.
//

#import "InsetTextField.h"

@implementation InsetTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _textInset = UIEdgeInsetsZero;
    _showBorderLine = YES;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    if (_showBorderLine) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
        CGFloat lineWidth = 0.2f;
        CGContextSetLineWidth(context, lineWidth);
        //top line
        CGContextMoveToPoint(context, 0.0, lineWidth);
        CGContextAddLineToPoint(context, self.frame.size.width, lineWidth);
        CGContextDrawPath(context, kCGPathStroke);
        //bottom line
        CGContextMoveToPoint(context, 0.0, CGRectGetHeight(self.frame) - lineWidth);
        CGContextAddLineToPoint(context, self.frame.size.width, CGRectGetHeight(self.frame) - lineWidth);
        CGContextDrawPath(context, kCGPathStroke);
    }
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
