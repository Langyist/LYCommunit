//
//  LYPublicMethods.m
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYPublicMethods.h"

@implementation LYPublicMethods
+(NSString *)timeFormatted:(long int)totalSeconds
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSString *day = [dateFormatter stringFromDate:theday];
    return day;
}
@end
