//
//  HomepageMain.h
//  incommunit
//  个人主页界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepageMain : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *m_tableview;
}
@property(nonatomic,retain)IBOutlet UITableView *m_tableview;
@end
