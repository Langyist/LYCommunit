//
//  NSString+Size.h
//  incommunit
//
//  Created by 李忠良 on 14/11/20.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(Size)

- (CGFloat)width:(CGSize)textSize font:(UIFont *)font;
- (CGFloat)height:(CGSize)textSize font:(UIFont *)font;

- (NSString *)convertTimeStampWithFormat:(NSString *)formatString;

@end
