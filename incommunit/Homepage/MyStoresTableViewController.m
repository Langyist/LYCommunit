//
//  MyStoresTableViewController.m
//  incommunit
//  我的店铺
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "MyStoresTableViewController.h"
#import "KxMenu.h"
#import "CustomSegmentedControl.h"

@interface HeaderView : UIView

@end

@implementation HeaderView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGFloat lineWidth = 1.0f;
    CGFloat move = 1.0f - lineWidth;
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, lineWidth);
    
    CGContextMoveToPoint(context, 0.0f, CGRectGetHeight(rect) - move); //start at this point
    
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect) - move); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end

@implementation MyStoresItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.itemImageView.layer.cornerRadius = 3.0f;
    self.itemImageView.clipsToBounds = YES;
}

@end

@interface MyStoresTableViewController () {
    
    NSInteger lastSelect;
}

@property (weak, nonatomic) IBOutlet CustomSegmentedControl *segmentedControl;

@end

@implementation MyStoresTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.segmentedControl setMaskForItem:@[@"0", @"1"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self performSegueWithIdentifier:@"StoreSetting" sender:nil];
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
    [self performSegueWithIdentifier:@"StoreSetting" sender:self];
}

- (void)orderManager:(id)sender {
    
}

- (void)addItems:(id)sender {
    
}

- (void)addAction:(id)sender {
    [self performSegueWithIdentifier:@"AddAction" sender:nil];
}

- (IBAction)valueChanged:(CustomSegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    [ColMenu showMenuInView:self.view fromRect:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 44) delegate:self];
    [ColMenu setSeletectItemOfSection:0 row:4];
    lastSelect = index;
}

#pragma mark -
#pragma mark ColMenuDelegate

- (NSInteger)sectionOfColMenu:(ColMenu *)colMenu {
    return 1;
}

- (NSInteger)colMune:(ColMenu *)colMenu numberOfRowsInSection:(NSInteger)section {
    return 45;
}

- (NSString *)colMune:(ColMenu *)colMenu titleForItemOfSection:(NSInteger)section row:(NSInteger)row {
    return @"text";
}

- (void)colMune:(ColMenu *)colMenu didSelectItemOfSection:(NSInteger)section row:(NSInteger)row {
    
}

@end
