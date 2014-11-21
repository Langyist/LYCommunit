//
//  NCMainViewController.h
//  incommunit
//
//  Created by 李忠良 on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColMenu.h"

@interface NCMainViewController : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    ColMenuDelegate
>
{
    NSMutableArray * m_type;
    NSMutableArray *  m_infodata;
    NSMutableArray * m_infodata1;
    NSMutableArray * m_infodata2;
    NSMutableArray * m_infodata3;
    
    int m_pagesize ;
    int m_pageOffset ;
    NSDictionary *detailData;
}

@end
