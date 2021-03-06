//
//  LYShop.h
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMComBoxView.h"
#import "UIImageView+MKNetworkKitAdditions.h"

@interface LYShop : UITableViewController<UITextFieldDelegate,UITabBarDelegate,LMComBoxViewDelegate>
{
    UITextField *m_textfiled;
    NSArray * m_listdata;
@public NSString *m_StoresID;
    NSDictionary *m_storesinfo;
    UILabel *m_StoreIntroduction;
    UILabel *m_DistributionRules;
    UIButton *m_Address;
    UIButton *m_Phone;
    NSMutableArray *m_Goodslist;
    UIImageView *m_GoodsImage;
    UILabel *m_GoodsName;
    UILabel *m_GoodsChan;
    UILabel *m_Price;
    
    UITextField *m_StoreType;
    UITextField *m_order;
    UITextField *m_temp;
    
    UIScrollView *m_imageScrollView;
    UIImageView  *m_imageView;
    NSArray      *m_picearry;
    
    UINavigationItem   *Item;
    
    UIImageView * m_ShoppingCartButton;
    UIAlertView *m_addshopcatalert;
    
    NSString *m_Goodsid;//商品ID
    
    UITabBar *m_tabBar;
    int m_pageSize;
    int m_pageOffset;
    
    NSArray *Goodstype;
    NSArray *Properties;
    UIView *m_viewms;
    NSMutableDictionary *m_stores;//上铺ID和上铺名字
}
@property (nonatomic,retain)IBOutlet UIScrollView *m_imageScrollView;
@property (nonatomic,retain)IBOutlet UIImageView  *m_imageView;
@property(nonatomic,retain)IBOutlet UINavigationItem   *Item;
@property (weak, nonatomic) IBOutlet UILabel *shopSummary;
@property (weak, nonatomic) IBOutlet UILabel *youhui;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *fovirateButton;
- (IBAction)foviratePress:(id)sender;
- (IBAction)all:(id)sender;
- (IBAction)autoSort:(id)sender;

@end
