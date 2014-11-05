//
//  LYMycollection.h
//  in_community
//
//  Created by LANGYI on 14-10-13.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"

@interface LYMycollection : UIViewController
<
    UITableViewDataSource
    ,UITableViewDelegate
> {
    
    IBOutlet CustomSegmentedControl *m_segment;
    
    IBOutlet UIScrollView *m_scrollView;
    
    UIView * m_view01;
    UIView * m_view02;
    UIView * m_view03;
    
    UITableView *m_shoptableView;
    UITableView *m_neighborhoodtableView;
}

@property (strong, nonatomic) IBOutlet CustomSegmentedControl *m_segment;
@property (weak, nonatomic) IBOutlet UITableView *m_babytableView;
@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;

@end
