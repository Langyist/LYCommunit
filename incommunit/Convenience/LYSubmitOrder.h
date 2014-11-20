//
//  LYSubmitOrder.h
//  incommunit
//  提交订单界面
//  Created by LANGYI on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSubmitOrder : UIViewController
{
    int Totalprice;//商品总价
    NSString * Storesidstr;//商铺ID
    NSMutableArray *sendtimelist;//送货时间
    NSString * m_timeID;//时间ID
}

@end
