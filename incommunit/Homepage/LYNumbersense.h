//
//  LYNumbersense.h
//  in_community
//  小区号码通
//  Created by LANGYI on 14-10-17.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYNumbersense : UIViewController <UITableViewDelegate,UITableViewDataSource>
{

    NSMutableArray * Numberlist;
    NSMutableArray * m_PersonalNumber;
    NSMutableArray * m_Administrative;
}

@property (strong, nonatomic) IBOutlet UITableView *m_tabeView;


@end
