//
//  AppDelegate.h
//  incommunit
//
//  Created by LANGYI on 14/10/25.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "BMapKit.h"
#define SPECIAL_BLACK [UIColor darkTextColor]//[UIColor colorWithRed:63/255.0f green:63/255.0f blue:62/255.0f alpha:1.0]
#define TOP_BAR_YELLOW [UIColor colorWithRed:242/255.0f green:183/255.0f blue:73/255.0f alpha:1.0]
#define SEPLINE_GRAY [UIColor colorWithRed:212/255.0f green:207/255.0f blue:207/255.0f alpha:1.0]
#define BK_GRAY [UIColor colorWithRed:233/255.0f green:232/255.0f blue:232/255.0f alpha:1.0]
#define BK_GRAY [UIColor colorWithRed:233/255.0f green:232/255.0f blue:232/255.0f alpha:1.0]
#define SPECIAL_RED [UIColor colorWithRed:248/255.0f green:128/255.0f blue:85/255.0f alpha:1.0]
#define SPECIAL_GRAY [UIColor grayColor]
#define SPECIAL_GREEN [UIColor colorWithRed:188/255.0f green:210/255.0f blue:94/255.0f alpha:1.0]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@end

