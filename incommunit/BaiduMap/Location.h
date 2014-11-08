//
//  Location.h
//  incommunit
//
//  Created by LANGYI on 14/11/8.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "BMapKit.h"


@class Location;

@protocol UserLocationDelegate <NSObject>
@optional

- (void)userLocation:(Location *)userLocation
             locInfo:(NSDictionary *)locInfo;

@end


@interface Location : NSObject<CLLocationManagerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    CLLocationManager    *   m_locationManager;
    BMKLocationService  *   m_locService;
}

@property (nonatomic, retain) id<UserLocationDelegate> locDelegate;


+ (Location *)shareLocation;
//开起定位
-(NSString *)StartLocation;
//关闭定位
-(void)GetLocation;
@end
