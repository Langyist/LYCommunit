//
//  LYMycollection.m
//  in_community
//
//  Created by LANGYI on 14-10-13.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYMycollection.h"

@interface LYMycollection ()

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
    self.title = @"我的收藏";
    [m_segment addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    m_scrollView.contentSize = CGSizeMake(m_scrollView.frame.size.width * 3, m_scrollView.frame.size.height);
    [m_scrollView setScrollEnabled:NO];
    
    //宝贝收藏
    m_view01 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, m_scrollView.frame.size.height)];
    m_babytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, m_view01.frame.size.width, m_view01.frame.size.height)];
    m_babytableView.delegate = self;
    m_babytableView.dataSource = self;
    [m_view01 addSubview:m_babytableView];
    [m_scrollView addSubview:m_view01];
    //店铺收藏
    m_view02 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, m_scrollView.frame.size.width, m_scrollView.frame.size.height)];
    m_shoptableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, m_view02.frame.size.width, m_view02.frame.size.height)];
    m_scrollView.backgroundColor = [UIColor grayColor];
    m_shoptableView.delegate = self;
    m_shoptableView.dataSource = self;
    [m_view02 addSubview:m_shoptableView];
    [m_scrollView addSubview:m_view02];
    //邻里互助收藏
    m_view03 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, m_scrollView.frame.size.width, m_scrollView.frame.size.height)];
    m_neighborhoodtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, m_view03.frame.size.width, m_view03.frame.size.height)];
    m_view03.backgroundColor = [UIColor grayColor];
    m_neighborhoodtableView.delegate = self;
    m_neighborhoodtableView.dataSource = self;
    [m_view03 addSubview:m_neighborhoodtableView];
    [m_scrollView addSubview:m_view03];
    
    //手势
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view01leftSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [m_view01 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view02leftSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [m_view02 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view02rightSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [m_view02 addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_view03rightSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [m_view03 addGestureRecognizer:recognizer];
}

//手势
-(void)m_view01leftSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [m_scrollView setContentOffset:CGPointMake(1* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 1;
        }];}
    }
}

-(void)m_view02leftSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [m_scrollView setContentOffset:CGPointMake(2* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 2;
        }];}
    }
}

-(void)m_view02rightSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [m_scrollView setContentOffset:CGPointMake(0* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 0;
        }];}
    }
}

-(void)m_view03rightSwipe:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        { [UIView animateWithDuration:0.3 animations:^{
            
            [m_scrollView setContentOffset:CGPointMake(1* self.view.frame.size.width,0) animated:YES];
            m_segment.selectedSegmentIndex = 1;
        }];}
    }
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

#pragma mark UITable delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (tableView == m_babytableView) {
        
        UINib *nib = [UINib nibWithNibName:@"BabyCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"babyCellIdentifier"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"babyCellIdentifier"];
        
        return cell;
    }else if (tableView == m_shoptableView) {
        
        UINib *nib = [UINib nibWithNibName:@"LYShopCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"shopCellIdentifier"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"shopCellIdentifier"];
        return cell;
    }else if (tableView == m_neighborhoodtableView) {
        
        UINib *nib = [UINib nibWithNibName:@"LYNeighborhoodCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"neighborhoodCellidentifier"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"neighborhoodCellidentifier"];
        
        return cell;
    }else {
        
        return nil;
    }
}

@end
