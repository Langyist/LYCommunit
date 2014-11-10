//
//  StoreOnlineNetworkEngine.h
//  StoreOnline
//
//  Created by 李忠良 on 14/10/29.
//  Copyright (c) 2014年 李忠良. All rights reserved.
//
//  为‘小区帮帮’定制的网络模块，主要进行http通信。
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

/*!
 *  @abstract 网络请求返回结果的函数
 *
 *  @param bValidJSON
 *  标识结果是否未有效的，YES为有效，NO为无效
 *
 *  @param errorMsg
 *  错误信息内容，请求正确返回的情况下，理论这个值为‘nil’，但不排除特殊情况
 *
 *  @param result
 *  请求返回的结果，具体数据格式跟服务器约定而来
 *
 *  @discussion
 *
 *
 */
typedef void (^AnalyzeResponseResult)(BOOL bValidJSON, NSString *errorMsg, id result);

@interface StoreOnlineNetworkEngine : MKNetworkEngine

+ (StoreOnlineNetworkEngine *)shareInstance;

/*!
 *  @abstract 发起网络请求
 *
 *  @param path
 *  请求的路径
 *
 *  @param params
 *  请求的参数
 *
 *  @param canRepeat
 *  标识这个请求是否可重复
 *
 *  @param isGet
 *  标识这个请求是否是‘GET’请求
 *
 *  @param result
 *  请求完成调用的回调函数
 *
 *  @discussion
 *  这个函数功能是异步执行，如有必要，请做界面处理
 *
 */
- (MKNetworkOperation *) startNetWorkWithPath:(NSString *)path
                                       params:(NSDictionary *)params
                                       repeat:(BOOL)canRepeat
                                        isGet:(BOOL)isGet
                                  resultBlock:(AnalyzeResponseResult)result;

/*!
 *  @abstract 发起网络请求
 *
 *  @param path
 *  请求的路径
 *
 *  @param params
 *  请求的参数
 *
 *  @param canRepeat
 *  标识这个请求是否可重复
 *
 *  @param activity
 *  是否启动进度窗口
 *
 *  @param result
 *  请求完成调用的回调函数
 *
 *  @discussion
 *  这个函数功能部分是异步执行，如有必要，请做界面处理
 *
 */
- (MKNetworkOperation *) startNetWorkWithPath:(NSString *)path
                                       params:(NSDictionary *)params
                                       repeat:(BOOL)canRepeat
                                        isGet:(BOOL)isGet
                                     activity:(BOOL)activity
                                  resultBlock:(AnalyzeResponseResult)result;

@end
