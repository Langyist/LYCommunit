//
//  ViewController.h
//  incommunit
//
//  Created by LANGYI on 14/10/25.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "AWaterfallTableView.h"
#import "BMapKit.h"
#import "Location.h"
@interface LYSelectCommunit : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UserLocationDelegate>
{
    //@private    UIButton *          m_selectCityButton;
    @private    AWaterfallTableView  *       m_tab;
    @private    UITableViewCell *   m_cell;
    @private    UISearchBar *       m_Serch;
    @private    CLLocationManager *locationManager;
    @public float latitude;
    @public float longitude;
    @private    NSMutableArray *    m_CommunitylistON;
    @private    NSMutableArray *    m_CommunitylistOF;
    @private    UILabel *           m_lable_name;
    @private    UILabel *           m_lable_address;
    @private    UILabel *           m_lable_distance;
    @private    UILabel *           m_lable_st;
    @private    NSString *          CommunityName;
    @private    NSString *          m_CommunityName;
    @public BOOL m_bl;
    @private UIView *               m_View;
    @public NSDictionary *          m_data;
    @private NSString *m_city_id;
    @public  UIButton *selectCityButton;
    Location * location ;
    BMKLocationService *locService;
    int m_pageSize;
    int m_pageOffset;
    int m_pagenumber;
    UIView *footerView;
    BMKMapView * m_mapview;
    BOOL  firstloc;
    NSMutableDictionary *NetParameters;//网络请求参数
}
@property(nonatomic, retain)IBOutlet UITableView    *  m_tab;
@property(nonatomic, retain)IBOutlet UISearchBar *     Serch;
@property(nonatomic, retain)IBOutlet UIButton *        selectCityButton;
@property(nonatomic, retain)IBOutlet UILabel *         m_lable_name;
@property(nonatomic, retain)IBOutlet UILabel *         m_lable_address;
@property(nonatomic, retain)IBOutlet UILabel *         m_lable_distance;
@property(nonatomic, retain)IBOutlet UILabel *         m_lable_st;
+(NSDictionary *)GetCommunityInfo;
+(void)Updata:(BOOL)sender;
@end

