//
//  LYconvenienceMain.h
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "UIImageView+AsyncDownload.h"
@interface LYconvenienceMain : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UISearchBarDelegate>
{
    UITextField *m_textfiled;
    NSArray *m_listdata;
    NSArray *m_orderlist;
    UISegmentedControl *m_segment;
    UIView * m_view;
    UIView * m_view01;
    UIView * m_view02;
    UIView * m_view03;
    UIView * m_view04;
    UITableView * m_Featuredtableview ;
    UITableView * m_Deliverytableview;
    UITableView * m_ShopDaquan;
    UITableView *m_CellmicroShop;
    NSMutableArray *m_Featuredlist;
    NSMutableArray *m_Deliverylist;
    NSMutableArray *m_ShopDaquanlist;
    NSMutableArray *m_CellmicroShoplist;
    NSMutableArray *m_shoptypelist;
    NSString *m_Storesid;//商店ID;
    NSString *StoreType;//商品类型
    NSString * orderstr;
    
    UITextField * m_StoreType;
    UITextField * m_order;
    UITextField *m_temp;
    
    UITextField *m_ShopDaquantype_id;
    UITextField *m_ShopDaquanorder;
    
    UISearchBar *m_tempb;
    
    @private CLLocationManager *locationManager;
    float  latitude;
    float  longitude;
    UIView *m_messageView;
    NSMutableDictionary * minfo;
    
    NSThread *myThread01;
    NSThread* myThread02;
    NSThread* myThread03;
    NSThread* myThread04;
    NSThread* myThread05;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *_scrollView;
@property(nonatomic,retain)IBOutlet UITextField *m_textfiled;
@property(nonatomic,retain)IBOutlet UISegmentedControl *m_segment;
@property(nonatomic,retain)IBOutlet UIView *m_view;
@end
