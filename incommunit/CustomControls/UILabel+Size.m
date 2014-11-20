//
//  UILabel+Size.m
//  incommunit
//
//  Created by 李忠良 on 14/11/20.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "UILabel+Size.h"
#import "NSString+Size.h"

@implementation UILabel(Size)

- (CGSize)resizeFixedWidth:(BOOL)isFixedWidth {
    CGRect bounds = self.bounds;
    if (isFixedWidth) {
        bounds.size.height = [self.text height:bounds.size font:self.font];
    }
    else {
        bounds.size.width = [self.text width:bounds.size font:self.font];
    }
    self.bounds = bounds;
    return self.bounds.size;
}

@end
