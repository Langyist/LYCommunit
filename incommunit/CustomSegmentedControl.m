//
//  CustomSegmentedControl.m
//  incommunit
//
//  Created by 李忠良 on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "CustomSegmentedControl.h"

#define TITNCOLOR [UIColor colorWithRed:227/255.0f green:225/255.0f blue:225/255.0f alpha:1]
#define TEXTCOLOR [UIColor colorWithRed:63/255.0f green:62/255.0f blue:62/255.0f alpha:1]
#define SELECTEDTEXTCOLOR [UIColor colorWithRed:230/255.0f green:163/255.0f blue:44/255.0f alpha:1]

@implementation CustomSegmentedControl {
    NSMutableArray *tagItemIndex;
}

- (void)awakeFromNib {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setTintColor:TITNCOLOR];
    [self setBackgroundImage:transparentImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName : TEXTCOLOR
                                             }
                                  forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName : SELECTEDTEXTCOLOR
                                             }
                                  forState:UIControlStateSelected];
    
    [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    for (UIView * segment in self.subviews) {
//        NSLog(@"%@", NSStringFromClass([segment class]));
        
        CGRect segmentRect = segment.frame;
        
        NSInteger itemIndex = CGRectGetMinX(segmentRect) / CGRectGetWidth(segmentRect);
        
        if (![tagItemIndex containsObject:[NSNumber numberWithInt:itemIndex]]) {
            continue;
        }
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint   (ctx, CGRectGetMaxX(segmentRect) - 14, CGRectGetHeight(rect) - 7);
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(segmentRect) - 7, CGRectGetHeight(rect) - 7);
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(segmentRect) - 7, CGRectGetHeight(rect) - 14);
        CGContextClosePath(ctx);
        
        CGFloat r = 63/255.0f;
        CGFloat g = 62/255.0f;
        CGFloat b = 62/255.0f;
        if (self.selectedSegmentIndex == itemIndex) {
            r = 230/255.0f;
            g = 163/255.0f;
            b = 44/255.0f;
        }
        CGContextSetRGBFillColor(ctx, r, g, b, 1);
        
        CGContextFillPath(ctx);
    }
}

- (void)valueChanged:(CustomSegmentedControl *)seg {
    [self setNeedsDisplay];
}

- (void)setMaskForItem:(NSArray *)itemArray {
    tagItemIndex = [[NSMutableArray alloc] init];
    for (NSString *itemString in itemArray) {
        NSInteger index = [itemString integerValue];
        if (index < self.numberOfSegments && ![tagItemIndex containsObject:[NSNumber numberWithInt:index]]) {
            [tagItemIndex addObject:[NSNumber numberWithInteger:index]];
        }
    }
}

@end
