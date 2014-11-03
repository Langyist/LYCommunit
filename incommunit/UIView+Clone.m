//
//  UIView+Clone.m
//  LALA
//
//  Created by 李忠良 on 14-8-11.
//  Copyright (c) 2014年 BigChance. All rights reserved.
//

#import "UIView+Clone.h"

@implementation UIView (Clone)

- (id) clone {
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject:self];
    id clone = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];
    return clone;
}

- (void)setLayerWithMask:(UIImage *)maskImage {
    
    if (!maskImage) {
        return;
    }
    
    CGImageRef cgImageWithAlpha = [maskImage CGImage];
    CAShapeLayer *maskingLayer = [CAShapeLayer layer];
    maskingLayer.contents = (__bridge id)cgImageWithAlpha;
    
    CALayer *layerToBeMasked = self.layer;
    layerToBeMasked.mask = maskingLayer;
    maskingLayer.frame = layerToBeMasked.bounds;
    
    [self setNeedsDisplay];
}

@end
