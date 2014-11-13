//
//  LYProManagementMain.h
//  incommunit
//  物业管理主界面
//  Created by LANGYI on 14/10/30.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYProManagementMain : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UISegmentedControl *m_segment;
    UIView * m_view01;
    UIView * m_view02;
    UIView * m_view03;
    UIView * m_view04;
    //物业公告
    UITableView *m_AnntableVeiw;
    NSArray *notification;
    
    //信息查询
    UITableView *m_InfotableView;
    
    NSArray *propertyExpenseArray;
    NSArray *expressInfomationArray;
    
    //物业交流
    UITableView *m_ACtableView;
    NSArray *propertyExchangeArray;
    NSArray *messageBoardListArray;
    NSDictionary *specifyMessageDictionary;
    
    //物业维护
    UITableView *m_MaintableView;
    NSArray *propertyService;
    NSDictionary *specifyPropertyService;
    
    NSDictionary *selectedDictionary;
    NSInteger IDNumber ;
    UIView *m_messageView;
    int m_pageSize;
    int  m_pageOffset;
}
@property (retain, nonatomic) IBOutlet UISegmentedControl *m_segment;
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@end
