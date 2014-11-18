//
//  LY_Sqllite.h
//  in_community
//  数据库操作类
//  Created by wangliang on 14-9-15.
//  Copyright (c) 2014年 wangliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LYSqllite : NSObject
+(BOOL)addShoppingcart:(NSMutableDictionary *)Goods number:(NSString *)numbers StoresID:(NSString *)Storesid Storesname:(NSString *)StoresName selectState:(NSString *)State;
+(void)CreatShoppingcart;
+ (NSMutableArray*)GetGoods;
+(void)CreatUserTable;
+(BOOL)wuser:(NSMutableDictionary *)userinfo;
+(NSMutableDictionary *)Ruser;
+(BOOL)Modifystate:(NSString *)GoodsID state:(NSString *)statestr
+(void)deletetable;
+(void)deleteuserinfo :(NSString *)name;

+(NSMutableDictionary *)currentCommnit;
+(NSMutableArray *)AllCommunit:(NSString *)communitName;
+(void)WriteComunitInfo:(NSDictionary *)Comunitinfo;
+(void)deletecommnuittable;

+ (NSDictionary *)selectedCommunit;
+ (void)setSelectedCommunit:(NSDictionary *)communitInfo;
+(void)delectGoods:(NSString *)GoodsID;
@end
