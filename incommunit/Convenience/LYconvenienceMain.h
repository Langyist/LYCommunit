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
#import "AWaterfallTableView.h"
#import "CustomSegmentedControl.h"
#import "ColMenu.h"

@interface LYconvenienceMain : UIViewController
<
UITextFieldDelegate
,UIGestureRecognizerDelegate
,UITableViewDelegate
,UITableViewDataSource
,CLLocationManagerDelegate
,UISearchBarDelegate
,ColMenuDelegate
> {
    NSArray *m_listdata;
    NSArray *m_orderlist;
    AWaterfallTableView * m_Featuredtableview ;
    AWaterfallTableView * m_Deliverytableview;
    AWaterfallTableView * m_ShopDaquan;
    AWaterfallTableView * m_CellmicroShop;
    NSMutableArray *m_Featuredlist;
    NSMutableArray *m_Deliverylist;
    NSMutableArray *m_ShopDaquanlist;
    NSMutableArray *m_CellmicroShoplist;
    NSMutableArray *m_shoptypelist;
    NSString *m_Storesid;//商店ID;
    NSString *StoreType;//商品类型
    NSString * orderstr;
    
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
    
    int m_pagesize;
    int m_pageoffset;
    int m_pagenumber;
}

@property (weak, nonatomic) IBOutlet UIScrollView *_scrollView;
@property (weak, nonatomic)IBOutlet CustomSegmentedControl *m_segment;

@end
