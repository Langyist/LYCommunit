//
//  LYPrivacySettings.h
//  incommunit
//  隐私设置界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYPrivacySettings : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *m_tableView;
    NSMutableArray * m_UIbuttonArry;
    NSMutableArray *m_UIbutton;
    @public NSString * m_addfriend;//添加朋友时是否需要验证
    @public NSMutableArray *  m_address;//地址隐私设置
    @public NSMutableArray *  m_album;//相册隐私设置
    NSMutableArray *address;//地址隐私设置
    NSMutableArray *album;//相册隐私设置
    NSString *addfriend;
}
@property (strong, nonatomic) IBOutlet UITableView *m_tableView;
@end