//
//  NSDictionary+JsonNullToNil.h
//  LALA
//
//  Created by 李忠良 on 14-8-23.
//  Copyright (c) 2014年 BigChance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonNullToNil)

- (id)valueForKeyNullToNil:(id)key;

@end
