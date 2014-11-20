//
//  NSDictionary+JsonNullToNil.m
//  LALA
//
//  Created by 李忠良 on 14-8-23.
//  Copyright (c) 2014年 BigChance. All rights reserved.
//

#import "NSDictionary+JsonNullToNil.h"

@implementation NSDictionary (JsonNullToNil)

- (id)valueForKeyNullToNil:(id)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    return object;
}

@end
