//
//  LYProductinformation.h
//  incommunit
//  商品信息
//  Created by LANGYI on 14/10/29.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYProductinformation : UIViewController
{
    @public NSString * m_Storesid; //商铺ID
    @public NSString * m_GoodsID;//商品ID
    NSDictionary* m_ProductDetails;
    UIImageView * m_iamgeview;
    UILabel *m_GoodsName; //商品名字
    UILabel *m_Price;//商品价格
    UITextView *m_Introduction; //商品介绍
    UITextField *m_textField;
    NSMutableArray * m_goodlis;
    NSMutableDictionary * m_goodsinfo;
    UIScrollView * m_Imagescrillview;
    @public NSDictionary * m_storeinfo;//店铺信息
}
@property(nonatomic,strong)NSDictionary* m_ProductDetails;
@property(nonatomic,retain)IBOutlet UIImageView *m_iamgeview;
@property(nonatomic,retain)IBOutlet UILabel *m_GoodsName;
@property(nonatomic,retain)IBOutlet UILabel *m_Price;
@property (weak, nonatomic) IBOutlet UILabel *oreginPrice;
@property(nonatomic,retain)IBOutlet UITextView *m_Introduction;
@property(nonatomic,retain)IBOutlet UITextField *m_textField;
@property(nonatomic,retain)IBOutlet UIScrollView *m_Imagescrillview;
@end
