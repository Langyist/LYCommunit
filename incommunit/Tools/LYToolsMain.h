//
//  LYToolsMain.h
//  incommunit
//  工具主界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYToolsMain : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *    m_table;
    UITableViewCell *m_cell;
    UILabel *m_lable;
    UIButton * m_exitbutton;
}
@property(nonatomic, retain)IBOutlet UITableView *m_table;
@property(nonatomic, retain)IBOutlet UITableViewCell *m_cell;
@property(nonatomic, retain)IBOutlet UILabel *m_lable;
@property(nonatomic, retain)IBOutlet UIButton *m_exitbutton;
@end
