//
//  LYMyOrder.h
//  in_community
//
//  Created by wangliang on 14-10-22.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYHomeMyOrder : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *m_tableView;
    
}
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@end
