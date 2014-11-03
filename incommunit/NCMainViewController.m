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
    
    woodsInfoTableView = [self.allInfoTableView clone];
    [woodsInfoTableView registerNib:nib forCellReuseIdentifier:@"NCTableViewCell"];
    carInfoTableView = [self.allInfoTableView clone];
    [carInfoTableView registerNib:nib forCellReuseIdentifier:@"NCTableViewCell"];
    roomInfoTableView = [self.allInfoTableView clone];
    [roomInfoTableView registerNib:nib forCellReuseIdentifier:@"NCTableViewCell"];
    
    CGRect frame = self.allInfoTableView.frame;
    frame.origin.x += frame.size.width;
    woodsInfoTableView.frame = frame;
    frame.origin.x += frame.size.width;
    carInfoTableView.frame = frame;
    frame.origin.x += frame.size.width;
    roomInfoTableView.frame = frame;
    
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(frame), 0)];
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NCTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
