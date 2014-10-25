//
//  LYnetwork.m
//  incommunit
// 获取网络数据并解析网络数据
//  Created by LANGYI on 14/10/25.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYnetwork.h"
@implementation LYnetwork
+(NSDictionary*)GetNetwork:(NSString*)Model Parameters:(NSMutableDictionary *)par
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *urlstr = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString *url = [[NSString alloc] initWithFormat:@"%@/services/city",urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSString *status = [weatherDic objectForKey:@"status"];
    if(![status isEqual:@"200"])
    {
        return nil;
    }
    return [weatherDic objectForKey:@"data"];
}
@end
