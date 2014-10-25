//
//  LY_SelectCity.h
//  in_community
//  选择城市
//  Created by wangliang on 14-9-10.
//  Copyright (c) 2014年 wangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYSelectCity : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView     *m_tableview;
    UITableViewCell *m_tablecell;
    UILabel         *m_lable;
    NSArray         *m_hotCities;
    NSArray         *m_allcities;
    NSMutableArray  *m_Acities;
    NSMutableArray  *m_Bcities;
    NSMutableArray  *m_Ccities;
    NSMutableArray  *m_Dcities;
    NSMutableArray  *m_Ecities;
    NSMutableArray  *m_Fcities;
    NSMutableArray  *m_Gcities;
    NSMutableArray  *m_Hcities;
    NSMutableArray  *m_Icities;
    NSMutableArray  *m_Jcities;
    NSMutableArray  *m_Kcities;
    NSMutableArray  *m_Lcities;
    NSMutableArray  *m_Mcities;
    NSMutableArray  *m_Ncities;
    NSMutableArray  *m_Ocities;
    NSMutableArray  *m_Pcities;
    NSMutableArray  *m_Qcities;
    NSMutableArray  *m_Rcities;
    NSMutableArray  *m_Scities;
    NSMutableArray  *m_Tcities;
    NSMutableArray  *m_Ucities;
    NSMutableArray  *m_Vcities;
    NSMutableArray  *m_Wcities;
    NSMutableArray  *m_Xcities;
    NSMutableArray  *m_Ycities;
    NSMutableArray  *m_Zcities;
    UIView *m_messageview;
}
@property(nonatomic, retain)IBOutlet UITableView *m_tableview;
@property(nonatomic, retain)IBOutlet UITableViewCell *m_tablecell;
@property(nonatomic,retain)IBOutlet UILabel *m_lable;
@end
