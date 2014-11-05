//
//  LYMycollection.m
//  in_community
//  我的收藏
//  Created by LANGYI on 14-10-13.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYMycollection.h"
#import "UIView+Clone.h"
#import "LYNeighborhoodCell.h"

@interface LYMycollection ()
@property (strong, nonatomic) IBOutlet UIView *footerView;

@end

@implementation LYMycollection

@synthesize m_scrollView,m_segment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [m_segment addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    
    self.m_babytableView.tableFooterView = self.footerView;
    
    m_shoptableView = [self addTableViewWithIndex:1];
    m_neighborhoodtableView = [self addTableViewWithIndex:2];
    [m_scrollView setContentSize:CGSizeMake(CGRectGetMaxX(m_neighborhoodtableView.frame), 0)];
    
    UINib *nib = [UINib nibWithNibName:@"BabyCell" bundle:nil];
    [self.m_babytableView registerNib:nib forCellReuseIdentifier:@"babyCellIdentifier"];
    UINib *nib1 = [UINib nibWithNibName:@"LYShopCell" bundle:nil];
    [m_shoptableView registerNib:nib1 forCellReuseIdentifier:@"shopCellIdentifier"];
    UINib *nib2 = [UINib nibWithNibName:@"LYNeighborhoodCell" bundle:nil];
    [m_neighborhoodtableView registerNib:nib2 forCellReuseIdentifier:@"neighborhoodCellidentifier"];
}

- (UITableView *)addTableViewWithIndex:(NSInteger)index {
    UITableView *tableView = [self.m_babytableView clone];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.tableFooterView = [self.footerView clone];
    
    CGRect frame = self.m_babytableView.frame;
    frame.origin.x = frame.size.width * index;
    tableView.frame = frame;
    
    [self.m_scrollView addSubview:tableView];
    
    return tableView;
}

-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    switch (Seg.selectedSegmentIndex)
    {
        case 0:
        {
            [m_scrollView setContentOffset:CGPointMake(0* self.view.frame.size.width,0) animated:YES];
        }
            break;
        case 1:
        {
            [m_scrollView setContentOffset:CGPointMake(1* self.view.frame.size.width,0) animated:YES];
        }
            break;
        case 2:
        {
            [m_scrollView setContentOffset:CGPointMake(2* self.view.frame.size.width,0) animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.m_scrollView) {
        NSInteger index = lroundf(self.m_scrollView.contentOffset.x / self.m_scrollView.frame.size.width);
        self.m_segment.selectedSegmentIndex = index;
    }
}

#pragma mark UITable delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRowAtIndexPath = 44;
    
    if (tableView == _m_babytableView) {
    }
    else if (tableView == m_shoptableView) {
    }
    else if (tableView == m_neighborhoodtableView) {
        heightForRowAtIndexPath = 83;
    }
    
    return heightForRowAtIndexPath;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRowsInSection = 0;
    
    if (tableView == _m_babytableView) {
    }
    else if (tableView == m_shoptableView) {
    }
    else if (tableView == m_neighborhoodtableView) {
        numberOfRowsInSection = 1;
    }
    
    NSLog(@"%@", tableView.tableFooterView);
    
    if (numberOfRowsInSection == 0) {
        tableView.tableFooterView.hidden = NO;
    }
    else {
        tableView.tableFooterView.hidden = YES;
    }
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView == _m_babytableView) {
        UINib *nib = [UINib nibWithNibName:@"BabyCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"babyCellIdentifier"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"babyCellIdentifier"];
        
    }
    else if (tableView == m_shoptableView) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"shopCellIdentifier"];

    }
    else if (tableView == m_neighborhoodtableView) {
    
        LYNeighborhoodCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"neighborhoodCellidentifier" forIndexPath:indexPath];
        [mycell setImagePath:@""];
        [mycell setName:@""];
        [mycell setSummary:@""];
        [mycell setDeleteBlock:^(LYNeighborhoodCell *cell) {
            
        }];
        return cell;
    }else if (tableView == m_neighborhoodtableView) {
        
        UINib *nib = [UINib nibWithNibName:@"LYNeighborhoodCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"neighborhoodCellidentifier"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"neighborhoodCellidentifier"];
        
        return cell;
    }
    return cell;
}

@end
