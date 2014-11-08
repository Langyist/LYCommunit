//
//  StoreOnlineNetworkEngine.m
//  StoreOnline
//
//  Created by 李忠良 on 14/10/29.
//  Copyright (c) 2014年 李忠良. All rights reserved.
//

#import "StoreOnlineNetworkEngine.h"

@interface StoreOnlineNetworkEngine () {
    NSMutableArray *operationNetworkArray;
}

@property (strong, nonatomic) NSMutableArray *operationNetworkArray;

@end

@implementation StoreOnlineNetworkEngine

@synthesize operationNetworkArray = _operationNetworkArray;

+ (StoreOnlineNetworkEngine *)shareInstance {
    static StoreOnlineNetworkEngine *instance = nil;
    if (instance == nil) {
        instance = [[StoreOnlineNetworkEngine alloc] initWithHostName:@"121.40.207.159/inCommunity"];
    }
    return instance;
}

-(NSMutableArray*) operationNetworkArray {
    
    if (!operationNetworkArray) {
        operationNetworkArray = [[NSMutableArray alloc] init];
    }
    return operationNetworkArray;
}

-(void) setOperationNetworkArray:(NSMutableArray *)anOperationNetworkArray {
    
    operationNetworkArray = anOperationNetworkArray;
}

- (MKNetworkOperation *) startNetWorkWithPath:(NSString *)path
                                       params:(NSDictionary *)params
                                       repeat:(BOOL)canRepeat
                                  resultBlock:(AnalyzeResponseResult)result {
    
    // 接口调用成功
    MKNKResponseBlock responseBlock = ^(MKNetworkOperation *completedOperation) {
        id responseJSON = [completedOperation responseJSON];
        BOOL bValidJSON = YES;
        NSString *errorMsg = nil;
        id resultData = nil;
        do {
            if (!responseJSON) { // 返回的不是json格式数据
                errorMsg = @"服务器提了一个问题";
                bValidJSON = NO;
                break;
            }
            NSString *responseStatus = nil;
            NSDictionary *responseDic = nil;
            if ([responseJSON isKindOfClass:[NSDictionary class]]) {
                responseDic = (NSDictionary *)responseJSON;
                responseStatus = [responseDic objectForKey:@"status"];
            }
            
            if (responseStatus) {
                NSInteger statusCode = [responseStatus integerValue];
                if (statusCode != 200) {
                    bValidJSON = NO;
                    errorMsg = [responseDic objectForKey:@"msg"];
                    break;
                }
            }
            else { // 找不到状态码
                errorMsg = @"服务器提了一个问题";
                bValidJSON = NO;
                break;
            }
            
            resultData = [responseJSON objectForKey:@"data"];
        }while (0);
        
        if (result) {
            result(bValidJSON, errorMsg, resultData);
        }
        
        [self.operationNetworkArray removeObject:completedOperation];
    };
    
    // 接口调用失败
    MKNKResponseErrorBlock errorBlock = ^(MKNetworkOperation* completedOperation, NSError* error) {
        
        if (result) {
            result(NO, @"网络提了一个问题", nil);
        }
        
        [self.operationNetworkArray removeObject:completedOperation];
    };
    
    // TUDO:加密参数
    
    // 生成网络对象
    if (!path) {
        path = @"";
    }
    if (!params) {
        params = @{};
    }
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:params
                                          httpMethod:@"GET"
                              ];
    [op addCompletionHandler:responseBlock errorHandler:errorBlock];
    if (!self.operationNetworkArray) {
        self.operationNetworkArray = [[NSMutableArray alloc] init];
    }
    BOOL start = YES;
    NSMutableArray *tempArray = self.operationNetworkArray;
    if (!canRepeat) { // 如果是不可重复请求，就进行检查
        for (MKNetworkOperation *excitOP in tempArray) { // 检查该网络请求是否正在执行中
            if ([[excitOP uniqueIdentifier] isEqualToString:[op uniqueIdentifier]]) {
                op = excitOP;
                start = NO;
                break;
            }
        }
    }
    if (start) { // 开始请求并加入请求列表
        [tempArray addObject:op];
        self.operationNetworkArray = tempArray;
        [self enqueueOperation:op];
    }
    return op;
}

@end
