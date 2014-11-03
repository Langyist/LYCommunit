//
//  NCMainViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "NCMainViewController.h"
#import "CustomSegmentedControl.h"
#import "NCTableViewCell.h"
#import "UIView+Clone.h"

@interface NCMainViewController () {
    UITableView* woodsInfoTableView;
    UITableView* carInfoTableView;
    UITableView* roomInfoTableView;
}

@property (weak, nonatomic) IBOutlet CustomSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView* allInfoTableView;

@end

@implementation NCMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.segmentedControl setMaskForItem:@[@"0"]];
    
    UINib *nib = [UINib nibWithNibName:@"NCTableViewCell" bundle:nil];
    [self.allInfoTableView registerNib:nib forCellReuseIdentifier:@"NCTableViewCell"];
    
    woodsInfoTableView = [self addTableViewWithIndex:1];
    carInfoTableView = [self addTableViewWithIndex:2];
    roomInfoTableView = [self addTableViewWithIndex:3];
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(roomInfoTableView.frame), 0)];
}

- (UITableView *)addTableViewWithIndex:(NSInteger)index {
    UITableView *tableView = [self.allInfoTableView clone];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"NCTableViewCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:@"NCTableViewCell"];
    
    CGRect frame = self.allInfoTableView.frame;
    frame.origin.x = frame.size.width * index;
    
    [self.scrollView addSubview:tableView];
    
    return tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)valueChanged:(CustomSegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * index, 0) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSInteger index = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    self.segmentedControl.selectedSegmentIndex = index;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NCTableViewCell" forIndexPath:indexPath];
    [cell setTitle:@"力帆羽毛球台"];
    [cell setContent:@"力帆羽毛球台"];
    [cell setTimestampString:@"1415006036000"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"NCDetail" sender:nil];
}

@end
