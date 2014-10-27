//
//  LYBaiduMap.h
//  incommunit
//  百度地图界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface LYBaiduMap : UIViewController<BMKMapViewDelegate>
{
    BMKMapView * m_mapview;
    BMKMapManager* _mapManager; 
}
@property(nonatomic,retain)IBOutlet BMKMapView *m_mapview;
@end
