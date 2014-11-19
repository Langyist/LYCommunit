//
//  NCMainViewController.m
//  incommunit
//  邻里互助主界面
//  Created by 李忠良 on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "NCMainViewController.h"
#import "CustomSegmentedControl.h"
#import "NCTableViewCell.h"
#import "UIView+Clone.h"
#import "XHFriendlyLoadingView.h"
#import "StoreOnlineNetworkEngine.h"

#import "NCDetailTableViewController.h"

@interface NCMainViewController ()
{
    UITableView* woodsInfoTableView;
    UITableView* carInfoTableView;
    UITableView* roomInfoTableView;
    
    NSInteger lastSelect;
    NSString * selectType;
}

@property (weak, nonatomic) IBOutlet CustomSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView* allInfoTableView;
@property (nonatomic, strong) XHFriendlyLoadingView *friendlyLoadingView;

@end

@implementation NCMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    selectType = @"1";
    m_pagesize = 10;
    m_pageOffset = 0 ;
    [self GetType];
    [self GetNetdata];
    [self.segmentedControl setMaskForItem:@[@"0"]];
    
    UINib *nib = [UINib nibWithNibName:@"NCTableViewCell" bundle:nil];
    [self.allInfoTableView registerNib:nib forCellReuseIdentifier:@"NCTableViewCell"];
    
    woodsInfoTableView = [self addTableViewWithIndex:1];
    carInfoTableView = [self addTableViewWithIndex:2];
    roomInfoTableView = [self addTableViewWithIndex:3];
    CGSize size = CGSizeMake(CGRectGetMaxX(roomInfoTableView.frame), 0);
    [self.scrollView setContentSize:size];
}

- (UITableView *)addTableViewWithIndex:(NSInteger)index {
    UITableView *tableView = [self.allInfoTableView clone];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"NCTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"NCTableViewCell"];
    
    CGRect frame = self.allInfoTableView.frame;
    frame.origin.x = frame.size.width * index;
    tableView.frame = frame;
    
    [self.scrollView addSubview:tableView];
    
    return tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)valueChanged:(CustomSegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    if (lastSelect == index && index == 0) {
        [ColMenu showMenuInView:self.view fromRect:seg.superview.frame delegate:self];
        [ColMenu setSeletectItemOfSection:0 row:4];
    }
    [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * index, 0) animated:YES];
    lastSelect = index;
    
    [self GetNetdata];
    [_allInfoTableView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger index = lroundf(_scrollView.contentOffset.x / _scrollView.frame.size.width);
        self.segmentedControl.selectedSegmentIndex = index;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRowsInSection = 0;
    if (tableView == _allInfoTableView) {
        numberOfRowsInSection = m_infodata.count;
    }
    
    if (numberOfRowsInSection == 0) {
        tableView.tableFooterView.hidden = NO;
    }
    else {
        tableView.tableFooterView.hidden = YES;
    }
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NCTableViewCell" forIndexPath:indexPath];
    
    [cell setTitle:[[m_infodata objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [cell setContent:[[m_infodata objectAtIndex:indexPath.row] objectForKey:@"content"]];
    [cell setTimestampString:[[m_infodata objectAtIndex:indexPath.row] objectForKey:@"create_time"]];
    [cell setTitleImagePath:[[m_infodata objectAtIndex:indexPath.row] objectForKey:@"head"]];
    
    if (indexPath.row != 0) {
        [cell setShowTopIcon:NO];
    }
    else {
        [cell setShowTopIcon:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailData = [[NSDictionary alloc]initWithDictionary:[m_infodata objectAtIndex:[indexPath row]]];
    [self performSegueWithIdentifier:@"NCDetail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NCDetailTableViewController *detailViewController = (NCDetailTableViewController*) segue.destinationViewController;
    [detailViewController setDetailData:detailData];
}

#pragma mark -
#pragma mark ColMenuDelegate

- (NSInteger)sectionOfColMenu:(ColMenu *)colMenu {
    return 1;
}

- (NSInteger)colMune:(ColMenu *)colMenu numberOfRowsInSection:(NSInteger)section {
    return m_type.count;
}

- (NSString *)colMune:(ColMenu *)colMenu titleForItemOfSection:(NSInteger)section row:(NSInteger)row {
    return [[m_type objectAtIndex:row] objectForKey:@"name"];
}

- (void)colMune:(ColMenu *)colMenu didSelectItemOfSection:(NSInteger)section row:(NSInteger)row {
    selectType = [[m_type objectAtIndex:row] objectForKey:@"id"];
}

-(void)GetNetdata
{
    
    NSDictionary *  dic = @{@"type_id" : selectType
                            ,@"pageOffset" : [[NSString alloc] initWithFormat:@"%d",m_pageOffset]
                            ,@"pageSize" : [[NSString alloc] initWithFormat:@"%d",m_pagesize]
                            };
    
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/neighbor/list"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView * alview = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                               [alview show];
                                                           }else
                                                           {
                                                               m_infodata =result;
                                                               [_allInfoTableView reloadData];
                                                           }
                                                       }];
    
}
-(void)GetType
{
    NSDictionary *  dic = @{};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/neighbor/getType"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               NSLog(@"%@",errorMsg);
                                                           }else{
                                                               m_type =result;
                                                               
                                                           }
                                                       }];
}
@end
