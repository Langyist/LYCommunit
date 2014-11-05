//
//  LYMycollection.h
//  in_community
//
//  Created by LANGYI on 14-10-13.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYMycollection : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UISegmentedControl *m_segment;
    
    IBOutlet UIScrollView *m_scrollView;
    
    UIView * m_view01;
    UIView * m_view02;
    UIView * m_view03;
    
    UITableView *m_babytableView;
    UITableView *m_shoptableView;
    UITableView *m_neighborhoodtableView;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *m_segment;

@property (strong, nonatomic) IBOutlet UIScrollView *m_scrollView;

@end
