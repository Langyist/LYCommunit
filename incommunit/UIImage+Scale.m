//
//  UIImage+Scale.m
//  LALA
//
//  Created by 李忠良 on 14-8-29.
//  Copyright (c) 2014年 BigChance. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:(CGRect){CGPointZero, newSize}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
