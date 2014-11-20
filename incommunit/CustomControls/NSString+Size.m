//
//  NSString+Size.m
//  incommunit
//
//  Created by 李忠良 on 14/11/20.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString(Size)

- (CGFloat)width:(CGSize)textSize font:(UIFont *)font {
    if (self.length == 0) {
        return 0;
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:self attributes:attributes] size].width;
}

- (CGFloat)height:(CGSize)textSize font:(UIFont *)font {
    CGFloat height = 0;
    int length = (int)[self width:textSize font:font];
    if (length > 0) {
        int count = (int)(length / textSize.width);
        height = (count + 1) * font.lineHeight;
    }
    return height;
}

- (NSString *)convertTimeStampWithFormat:(NSString *)formatString {
    long long timestampInt = [self longLongValue];
    timestampInt /= 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = formatString;
    NSString *time = [formatter stringFromDate:date];
    return time;
}

@end
