//
//  AppDelegate.m
//  incommunit
//
//  Created by LANGYI on 14/10/25.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#import "AppDelegate.h"
#import "UIImage+Scale.h"
#import "Sqllite/LYSqllite.h"
#import <MKNetworkKit.h>
#import "UIImageView+MKNetworkKitAdditions.h"
@interface AppDelegate ()
{
    BMKMapManager* _mapManager;
    UIActivityIndicatorView *active;
    UILabel *label;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    MKNetworkEngine *imageEngine = [[MKNetworkEngine alloc] initWithHostName:@"www.baidu.com"];
    [imageEngine useCache];
    [UIImageView setDefaultEngine:imageEngine];
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"lK7gaSg80peIGLH15plumdwW" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //去掉返回按钮自动添加的’back‘文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    //修改返回按钮图标
    UIImage *backImage = [UIImage imageNamed:@"返回"];
    [[UINavigationBar appearance] setBackIndicatorImage:backImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImage];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont systemFontOfSize:19.0f],
                                                          NSFontAttributeName,
                                                          SPECIAL_BLACK,
                                                          NSForegroundColorAttributeName,
                                                          nil]];
    [[UINavigationBar appearance] setBarTintColor:TOP_BAR_YELLOW];
    [[UINavigationBar appearance] setTintColor:SPECIAL_BLACK];
    
    [self.window setBackgroundColor:TOP_BAR_YELLOW];
    
    //    NSMutableDictionary *userinfo =  [LYSqllite Ruser];
    //    NSMutableDictionary *communitInfo = [LYSqllite currentCommnit];
    //    if (userinfo != nil && ![[userinfo objectForKey:@"auth_status"] isEqualToString:@"-2"] && [[communitInfo objectForKey:@"community_id"] length])
    //    {
    //        UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    //        UIViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainPage"];
    //        self.window.rootViewController = rootViewController;
    //    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
