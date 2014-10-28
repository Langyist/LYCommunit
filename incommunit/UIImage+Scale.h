//
//  UIImage+Scale.h
//  LALA
//
//  Created by 李忠良 on 14-8-29.
//  Copyright (c) 2014年 BigChance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
