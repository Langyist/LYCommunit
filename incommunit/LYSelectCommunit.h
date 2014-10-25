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
@interface LYSelectCommunit : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CLLocationManagerDelegate>
{
    @private    UIButton *          m_selectCityButton;
    @private    UITableView *       m_tab;
    @private    UITableViewCell *   m_cell;
    @private    UISearchBar *       m_Serch;
    @public     NSDictionary        *m_data;
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
    @public BOOL m_Refresh;//是否刷新界面
    @public NSDictionary *          m_cityinfo;//城市信息
    @private UIView *               m_View;
    @public NSDictionary *          m_CommuntiyInfo;
    @private NSString *             m_city_name;
}
@property(nonatomic, retain)IBOutlet UITableView    *  m_tab;
@property(nonatomic, retain)IBOutlet UITableViewCell * cell;
@property(nonatomic, retain)IBOutlet UISearchBar *     Serch;
@property(nonatomic, retain)IBOutlet UIButton *        selectCityButton;
@property(nonatomic, retain)IBOutlet UILabel *         m_lable_name;
@property(nonatomic, retain)IBOutlet UILabel *         m_lable_address;
@property(nonatomic, retain)IBOutlet UILabel *         m_lable_distance;
@property(nonatomic, retain)IBOutlet UILabel *         m_lable_st;
@end

