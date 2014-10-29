//
//  LYShoppingcart.h
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface LYShoppingcart : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *m_tableView ;
    UIImageView * m_imge;
    NSMutableArray *Goodslist;
    int number;//商品总数量
    UILabel * m_storesNumber;
    NSMutableArray *m_textfiledlist;
}
@property (nonatomic,retain)IBOutlet UITableView *m_tableView;
@property (nonatomic,retain)IBOutlet UILabel * m_storesNumber;
@property (retain, nonatomic) NSMutableArray *items;
@end
