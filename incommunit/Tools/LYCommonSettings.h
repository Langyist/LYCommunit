//
//  LYCommonSettings.h
//  incommunit
//  通用设置界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYCommonSettings : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UITableView *m_tableView;
    
}

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;


@end
