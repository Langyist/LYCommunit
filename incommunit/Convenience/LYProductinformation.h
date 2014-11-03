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
    @public NSString * m_GoodsID; //上铺ID
    NSDictionary* m_ProductDetails;
    UIImageView * m_iamgeview;
    UILabel *m_GoodsName; //商品名字
    UILabel *m_Price;//商品价格
    UITextView *m_Introduction; //商品介绍
    UITextField *m_textField;
}
@property(nonatomic,strong)NSDictionary* m_ProductDetails;
@property(nonatomic,retain)IBOutlet UIImageView *m_iamgeview;
@property(nonatomic,retain)IBOutlet UILabel *m_GoodsName;
@property(nonatomic,retain)IBOutlet UILabel *m_Price;
@property(nonatomic,retain)IBOutlet UITextView *m_Introduction;
@property(nonatomic,retain)IBOutlet UITextField *m_textField;
@end
