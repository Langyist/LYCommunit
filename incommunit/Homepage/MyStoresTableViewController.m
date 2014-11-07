//
//  MyStoresTableViewController.m
//  incommunit
//  我的店铺
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "MyStoresTableViewController.h"
#import "KxMenu.h"

@implementation MyStoresItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.itemImageView.layer.cornerRadius = 3.0f;
    self.itemImageView.clipsToBounds = YES;
}

@end

@interface MyStoresTableViewController () {
    LMContainsLMComboxScrollView *bgScrollView;
    LMComBoxView *comboxView;
    LMComBoxView *comboxView1;
    
    NSMutableArray  *itemsArray;
    NSMutableArray  *itemsArray1;
}

@end

@implementation MyStoresTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame), self.view.frame.size.width, 44)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    
    comboxView = [[LMComBoxView alloc] initWithFrame:
                            CGRectMake(CGRectGetWidth(self.view.frame) / 2 * 0,
                                       0,
                                       CGRectGetWidth(self.view.frame) / 2,
                                       44)];
    
    comboxView.backgroundColor = [UIColor whiteColor];
    comboxView.arrowImgName = @"小三角_11";
    itemsArray = [NSMutableArray arrayWithArray:@[@"全部", @""]];
    comboxView.titlesList = itemsArray;
    comboxView.delegate = self;
    comboxView.supView = bgScrollView;
    [comboxView defaultSettings];
    [bgScrollView addSubview:comboxView];
    
    comboxView1 = [[LMComBoxView alloc] initWithFrame:
                   CGRectMake(CGRectGetWidth(self.view.frame) / 2 * 1,
                              0,
                              CGRectGetWidth(self.view.frame) / 2,
                             44)];
    
    comboxView1.backgroundColor = [UIColor whiteColor];
    comboxView1.arrowImgName = @"小三角_11";
    itemsArray1 = [NSMutableArray arrayWithArray:@[@"智能排序", @""]];
    comboxView1.titlesList = itemsArray1;
    comboxView1.delegate = self;
    comboxView1.supView = bgScrollView;
    [comboxView1 defaultSettings];
    [bgScrollView addSubview:comboxView1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGRectGetHeight(bgScrollView.frame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return bgScrollView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyStoresItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyStoresItem" forIndexPath:indexPath];
    cell.itemNameLabel.text = @"李氏五金锁具";
    cell.itemSummaryLabel.text = @"食品类";
    cell.itemPriceLabel.text = @"￥15.00";
    return cell;
}

#pragma mark -
#pragma mark LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox {

}

- (IBAction)showMenu:(UIButton *)sender {
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"店铺设置"
                     image:nil
                    target:self
                    action:@selector(storesSetting:)],
      
      [KxMenuItem menuItem:@"订单管理"
                     image:nil
                    target:self
                    action:@selector(orderManager:)],
      
      [KxMenuItem menuItem:@"添加商品"
                     image:nil
                    target:self
                    action:@selector(addItem:)],
      
      [KxMenuItem menuItem:@"添加活动"
                     image:nil
                    target:self
                    action:@selector(addAction:)]
      ];
    
    CGRect frame = sender.frame;
    frame.origin.y += 25;
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void)storesSetting:(id)sender {
    
}

- (void)orderManager:(id)sender {
    
}

- (void)addItems:(id)sender {
    
}

- (void)addAction:(id)sender {
    [self performSegueWithIdentifier:@"AddAction" sender:nil];
}

@end
