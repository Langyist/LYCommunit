//
//  LYnetwork.h
//  incommunit
//  网络数据解析
//  Created by LANGYI on 14/10/25.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface LYnetwork : NSObject
+(NSDictionary*)GetNetwork:(NSString*)Model Parameters:(NSMutableDictionary *)par;
@end
