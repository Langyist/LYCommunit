//
//  LYAnnouncement.h
//  incommunit
//  公告界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYAnnouncement : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *m_tableView;
    NSArray *notification;
    UILabel *Label;
    UILabel * m_IngLab;
    NSDictionary * m_ANNinfo;//公告详情
}
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@end

