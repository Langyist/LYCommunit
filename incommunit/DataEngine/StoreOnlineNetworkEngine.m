//
//  StoreOnlineNetworkEngine.m
//  StoreOnline
//
//  Created by 李忠良 on 14/10/29.
//  Copyright (c) 2014年 李忠良. All rights reserved.
//

#import "StoreOnlineNetworkEngine.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface StoreOnlineNetworkEngine () {
    NSMutableDictionary *operationNetworkArray;
    MKNetworkOperation *waitingOperation;
    
    UIActivityIndicatorView *activityView;
    UILabel *label;
    UIControl *overlayView;
}

@property (strong, nonatomic) NSMutableDictionary *operationNetworkArray;
@property (strong, nonatomic) UIControl *overlayView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@end

@implementation StoreOnlineNetworkEngine

@synthesize operationNetworkArray = _operationNetworkArray;
@synthesize overlayView = _overlayView, label = _label, activityView = _activityView;

+ (StoreOnlineNetworkEngine *)shareInstance {
    static StoreOnlineNetworkEngine *instance = nil;
    if (instance == nil) {
        instance = [[StoreOnlineNetworkEngine alloc] initWithHostName:@"121.40.207.159/inCommunity"];
    }
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return self;
}

- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _overlayView;
}

- (UILabel *)label {
    if (!label) {
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 50, 70, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12.0f];
        [label setText:@"正在载入..."];
        CGRect rect = label.frame;
        rect.origin.x = (self.overlayView.frame.size.width - rect.size.width) / 2 + 5;
        rect.origin.y = self.overlayView.center.y + 10;
        label.frame = rect;
        [self.overlayView addSubview:label];
    }
    return label;
}

- (UIActivityIndicatorView *)activityView {
    if (!activityView) {
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.hidesWhenStopped = YES;
        activityView.frame = CGRectMake(0, 0, 70, 70);
        activityView.center = self.overlayView.center;
        [self.overlayView addSubview:activityView];
    }
    return activityView;
}

-(NSMutableDictionary*) operationNetworkArray {
    
    if (!operationNetworkArray) {
        operationNetworkArray = [[NSMutableDictionary alloc] init];
    }
    return operationNetworkArray;
}

-(void) setOperationNetworkArray:(NSMutableDictionary *)anOperationNetworkArray {
    
    operationNetworkArray = anOperationNetworkArray;
}

- (void)removeNetworkOperation:(MKNetworkOperation *)operation {
    
    //NSDictionary *dic = [self.operationNetworkArray objectForKey:[operation uniqueIdentifier]];
    //NSNumber *activity = [dic objectForKey:@"activity"];
    //if ([activity boolValue]) {
        [self waiting:NO];
    //}
    
    [operation cancel];
    
    NSArray *allOperation = [self.operationNetworkArray allKeys];
    //NSMutableDictionary *tempDic = [self.operationNetworkArray copy];
    for (NSString *uniqueIdentifier in allOperation) {
        if ([uniqueIdentifier isEqualToString:[operation uniqueIdentifier]]) {
            [self.operationNetworkArray removeObjectForKey:uniqueIdentifier];
            break;
        }
    }
    //self.operationNetworkArray = [[NSMutableDictionary alloc] initWithDictionary:tempDic copyItems:YES];
}

- (void)addNetworkOperation:(MKNetworkOperation *)operation canRepeat:(BOOL)canRepeat activity:(BOOL)activity resultBlock:(AnalyzeResponseResult)result {
    BOOL start = YES;
    NSArray *tempArray = [self.operationNetworkArray copy];
    if (!canRepeat) { // 如果是不可重复请求，就进行检查
        for (NSString *uniqueIdentifier in tempArray) { // 检查该网络请求是否正在执行中
            if ([uniqueIdentifier isEqualToString:[operation uniqueIdentifier]]) {
                start = NO;
                break;
            }
        }
    }
    if (start) { // 开始请求并加入请求列表
        NSDictionary *dic = @{
                              @"operation" : operation
                              ,@"activity" : [NSNumber numberWithBool:activity]
                              ,@"resultBlock" : result
                              };
        [self.operationNetworkArray setObject:dic forKey:[operation uniqueIdentifier]];
        [self enqueueOperation:operation];
        
        if (activity) {
            waitingOperation = operation;
            
            [self performSelector:@selector(startUpdateWaiting:) withObject:operation afterDelay:1.5];
        }
    }
}

- (void)startUpdateWaiting:(id)params {
    
    if ([waitingOperation isExecuting]) {
        [self waiting:YES];
    }
}

- (void)reportRestult:(MKNetworkOperation *)operation bValuedJSON:(BOOL)bValuedJSON errorMsg:(NSString *)errorMsg resultData:(id)resultData {
    NSDictionary *dic = [self.operationNetworkArray objectForKey:[operation uniqueIdentifier]];
    AnalyzeResponseResult result = [dic objectForKey:@"resultBlock"];
    [self removeNetworkOperation:operation];
    if (result) {
        result(bValuedJSON, errorMsg, resultData);
    }
}

- (MKNetworkOperation *) startNetWorkWithPath:(NSString *)path
                                       params:(NSDictionary *)params
                                       repeat:(BOOL)canRepeat
                                        isGet:(BOOL)isGet
                                  resultBlock:(AnalyzeResponseResult)result {
    return [self startNetWorkWithPath:path params:params repeat:canRepeat isGet:isGet activity:NO resultBlock:result];
}

- (MKNetworkOperation *) startNetWorkWithPath:(NSString *)path
                                       params:(NSDictionary *)params
                                       repeat:(BOOL)canRepeat
                                        isGet:(BOOL)isGet
                                     activity:(BOOL)activity
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
                    errorMsg = [responseDic objectForKey:@"message"];
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
        
        [self reportRestult:completedOperation bValuedJSON:bValidJSON errorMsg:errorMsg resultData:resultData];
    };
    
    // 接口调用失败
    MKNKResponseErrorBlock errorBlock = ^(MKNetworkOperation* completedOperation, NSError* error) {
        
        [self reportRestult:completedOperation bValuedJSON:NO errorMsg:@"提示：网络连接错误，请检查网络！" resultData:nil];
    };
    
    // TUDO:加密参数
    
    // 生成网络对象
    if (!path) {
        path = @"";
    }
    if (!params) {
        params = @{};
    }
    NSString *httpMethod = @"GET";
    if (!isGet) {
        httpMethod = @"POST";
    }
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:params
                                          httpMethod:httpMethod
                              ];
    [op addCompletionHandler:responseBlock errorHandler:errorBlock];
    [self addNetworkOperation:op canRepeat:canRepeat activity:activity resultBlock:result];
    
    return op;
}

- (void)waiting:(BOOL)bStart {
    
    if (bStart && ![self.activityView isAnimating]) {
        if(!self.overlayView.superview){
            NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
            
            for (UIWindow *window in frontToBackWindows)
                if (window.windowLevel == UIWindowLevelNormal) {
                    [window addSubview:self.overlayView];
                    break;
                }
        }
        
        self.label.hidden = NO;
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
    }
    else {
        self.label.hidden = YES;
        [self.activityView stopAnimating];
        
        [self.overlayView removeFromSuperview];
    }
}

- (void)overlayViewDidReceiveTouchEvent:(id)sender forEvent:(UIEvent *)event {
    UITouch *touch = [event.allTouches anyObject];
    CGPoint point = [touch locationInView:self.overlayView];
    CGRect backRect = CGRectMake(0, 20, 60, 44);
    if (CGRectContainsPoint(backRect, point)) {
        UIViewController * vc = [[UIApplication sharedApplication]keyWindow].rootViewController;
        vc = [StoreOnlineNetworkEngine getVisibleViewControllerFrom:vc];
        if (vc) {
            [vc.navigationController popViewControllerAnimated:YES];
        }
        [self removeNetworkOperation:waitingOperation];
    }
}

+ (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [StoreOnlineNetworkEngine getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [StoreOnlineNetworkEngine getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [StoreOnlineNetworkEngine getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

@end

