//
//  Location.m
//  incommunit
//
//  Created by LANGYI on 14/11/8.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "Location.h"
NSMutableDictionary * Locationinfo;
@implementation Location
+ (Location *)shareLocation {
    static Location *instance = nil;
    if (instance == nil) {
        instance = [[Location alloc] init];
    }
    return instance;
}

#define mark - 
//获取定位信息
-(void)GetLocation
{
    Locationinfo = [[NSMutableDictionary alloc] init];
    [self StartLocation];
}

-(NSString *)StartLocation
{
    NSString *sms;
    m_locationManager = [[CLLocationManager alloc] init];
    m_locationManager.delegate = self;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        [m_locationManager requestWhenInUseAuthorization];
    }
    
    //初始化BMKLocationService
    m_locService = [[BMKLocationService alloc]init];
    m_locService.delegate = self;
    //启动LocationService
    [m_locService startUserLocationService];
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    m_locationManager.distanceFilter = 1000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    if ([CLLocationManager locationServicesEnabled])
    {
        [m_locationManager startUpdatingLocation];
    }
    else
    {
        sms = @"请开启定位功能！";
    }
    return nil;
}

//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSString *latitude =[[NSString alloc] initWithFormat:@"%f",userLocation.location.coordinate.latitude] ;
    NSString *longitude =[[NSString alloc] initWithFormat:@"%f",userLocation.location.coordinate.longitude] ;
    [Locationinfo setValue:latitude forKey:@"latitude"];
    [Locationinfo setValue:longitude forKey:@"longitude"];
    BMKGeoCodeSearch *_geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    //初始化逆地理编码类
    BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    //需要逆地理编码的坐标位置
    reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    [m_locService stopUserLocationService];
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [Locationinfo setValue:@"定位失败" forKey:@"error"];
    if ([self.locDelegate respondsToSelector:@selector(userLocation:locInfo:)]) {
        [self.locDelegate userLocation:self locInfo:Locationinfo];
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSString *CityName = [result.addressDetail.city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    [Locationinfo setValue:CityName forKey:@"city"];
    if ([self.locDelegate respondsToSelector:@selector(userLocation:locInfo:)]) {
        [self.locDelegate userLocation:self locInfo:Locationinfo];
    }
}

@end
