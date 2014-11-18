//
//  LYShoppingcart.m
//  incommunit
//  购物车界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYShoppingcart.h"
#import "LYSqllite.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "AppDelegate.h"

#if __LP64__
#define MOVE 32
#else
#define MOVE 16
#endif


@class ShopcartCell;

typedef void (^ChangeNumberBlock)(ShopcartCell *cell, BOOL add);

@interface ShopcartCell : UITableViewCell

@end

@implementation ShopcartCell {
    ChangeNumberBlock block;
}

- (IBAction)changeNumber:(UIButton *)sender {
    if (block) {
        block(self, (sender.tag == 0) ? NO : YES);
    }
}

- (void)setBlock:(ChangeNumberBlock)aBlock {
    block = aBlock;
}

@end


@interface LYShoppingcart ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@end
static NSDictionary * temp;
@implementation LYShoppingcart
@synthesize m_tableView,m_storesNumber;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    number= 0;
    m_textfiledlist = [[NSMutableArray alloc] init];
    self.m_tableView.allowsSelectionDuringEditing = YES;
    Goodslist = [LYSqllite GetGoods];
    
    [self.m_tableView setContentInset:UIEdgeInsetsMake(-0.5, 0, 0, 0)];
    [self.m_tableView setBackgroundColor:BK_GRAY];
    [self.view setBackgroundColor:BK_GRAY];
    
    self.settlementButton.layer.cornerRadius = 3.0f;
    [self.settlementButton setBackgroundColor:SPECIAL_RED];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    [super setEditing:YES];
    [self.m_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
}

#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return Goodslist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *temp = [Goodslist objectAtIndex:section];
    return temp.count + 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSMutableArray  *tempinfo = [Goodslist objectAtIndex:indexPath.section];
    NSDictionary *temp = nil;
    static NSString *CellIdentifier;
    if (indexPath.row == 0)
    {
        CellIdentifier = @"selectStoresCell";
        if(tempinfo.count>0)
        {
            temp = [tempinfo objectAtIndex:indexPath.row];
        }
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UIImageView *imageView  = (UIImageView *)[cell viewWithTag:100];
        UILabel     *name       = (UILabel *)[cell viewWithTag:101];
        NSString *imageName = @"Selected";
        for (NSDictionary *goodsInfo in tempinfo)
        {
            if (![[goodsInfo objectForKey:@"selectState"] boolValue])
            {
                imageName = @"Unselected";
                break;
            }
        }
        [imageView  setImage:[UIImage imageNamed:imageName]]; // 是否全选
        [name setText:[temp objectForKey:@"Storesname"]]; // 商店名称
        
        cell.separatorInset = UIEdgeInsetsMake(15.f, 0.f, 0.f, 15.f);
    }
    else {
        CellIdentifier = @"selectGoodsCell";
        if (tempinfo.count>0) {
            temp = [tempinfo objectAtIndex:indexPath.row - 1];
        }
        ShopcartCell * itemcell = (ShopcartCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UIImageView *imageView  = (UIImageView *)[itemcell viewWithTag:100];
        
        //UIImageView *pimageview =;
        UILabel     *name       = (UILabel *)[itemcell viewWithTag:102];
        UITextField *quantityfl = (UITextField *)[itemcell viewWithTag:105];
        UILabel     *pricelb    = (UILabel *)[itemcell viewWithTag:103];
        NSString *imageName = @"Selected";
        if (![[temp objectForKey:@"selectState"] boolValue])
        {
            imageName = @"Unselected";
        }
        [imageView  setImage:[UIImage imageNamed:imageName]]; // 是否选择
        NSString *imageUrl = [temp objectForKey:@"logo"];
        if (imageUrl!=nil && ![imageUrl isEqualToString:@"(null)"])
        {
            NSURL *url = [NSURL URLWithString:imageUrl];
            [(UIImageView *)[itemcell viewWithTag:101] setImageFromURL:url placeHolderImage:[UIImage imageNamed:@""] usingEngine:nil animation:NO];
        }
        [name       setText:[temp objectForKey:@"name"]]; // 商品名字
        [quantityfl setText:[temp objectForKey:@"quantity"]]; // 选择数量
        CGFloat price = [[temp objectForKey:@"price"] floatValue];
        [pricelb setText:[[NSString alloc] initWithFormat:@"￥%.02f", price]]; // 价格，小数点两位精度
        
        CGFloat textFloat = [[temp objectForKey:@"quantity"] floatValue];
        CGFloat totalFloat = price * textFloat;
        
        self.totalLabel.text = [[NSString alloc] initWithFormat:@"￥%.02f",totalFloat];
        
        itemcell.tag = indexPath.section << MOVE | (indexPath.row - 1);
        [itemcell setBlock:^(ShopcartCell *acell, BOOL add) {
            [self changeNumberOfItem:add sender:acell];
        }];
        
        cell = itemcell;
        
        cell.separatorInset = UIEdgeInsetsMake(16.f, 0.f, 0.f, cell.bounds.size.width - 16.f);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray  *tempinfo = [Goodslist objectAtIndex:indexPath.section];
    BOOL selectState = NO;
    if (indexPath.row == 0) {
        for (NSDictionary *goodsInfo in tempinfo) {
            if (![[goodsInfo objectForKey:@"selectState"] boolValue]) {
                selectState = YES;
                break;
            }
        }
    }
    else {
        NSDictionary * temp = [tempinfo objectAtIndex:indexPath.row - 1];
        selectState = ![[temp objectForKey:@"selectState"] boolValue];
    }
    [self changeDataSelected:indexPath selectState:selectState];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 38;
    }else
    {
        return 54;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7;
}

- (void)changeNumberOfItem:(BOOL)add sender:(UITableViewCell *)sender {
    
    NSInteger tag = sender.tag;
    NSInteger section = tag >> MOVE;
    NSInteger row = (tag << MOVE) >> MOVE;
    
    if (Goodslist.count > section) {
        NSMutableArray *items = [NSMutableArray arrayWithArray:[Goodslist objectAtIndex:section]];
        if (items.count > row) {
            NSMutableDictionary *itemInfo = [items objectAtIndex:row];
            NSString *numberOfItemString = [itemInfo objectForKey:@"quantity"];
            NSInteger numberOfItem = [numberOfItemString integerValue];
            if (add) {
                numberOfItem += 1;
            }
            else {
                numberOfItem -= 1;
            }
            numberOfItem = MAX(0, numberOfItem);
            [itemInfo setObject:[NSString stringWithFormat:@"%d", numberOfItem] forKey:@"quantity"];
            [LYSqllite Modifyquantity:[itemInfo objectForKey:@"commodity_id"] quantity:[itemInfo objectForKey:@"quantity"]];
            [items setObject:itemInfo atIndexedSubscript:row];
            [Goodslist setObject:items atIndexedSubscript:section];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row + 1 inSection:section];
            [m_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}

-(IBAction)Settlement:(id)sender
{
    [self performSegueWithIdentifier:@"GoSettlement" sender:self];
}

#pragma mark -
#pragma mark Method
- (void)changeDataSelected:(NSIndexPath *)indexPath selectState:(BOOL)selected
{
    NSString *selectedStatusString = selected ? @"1" : @"0";
    NSMutableArray *newGoodsList = [[NSMutableArray alloc] init];
    NSMutableArray *tempGoodList = [Goodslist objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        // 重新设置所有项目的选中值;
        for (NSInteger index = 0; index < [tempGoodList count]; index++) {
            NSMutableDictionary *tempGoodsInfo = [NSMutableDictionary dictionaryWithDictionary:[tempGoodList objectAtIndex:index]];
            [tempGoodsInfo setObject:selectedStatusString forKey:@"selectState"];
            [LYSqllite Modifystate:[tempGoodsInfo objectForKey:@"commodity_id"] state:[tempGoodsInfo objectForKey:@"selectState"]];
            [newGoodsList addObject:tempGoodsInfo];
        }
    }
    else {
        newGoodsList = tempGoodList;
        // 重新设置当前项目的选中值;
        NSMutableDictionary *tempGoodsInfo = [NSMutableDictionary dictionaryWithDictionary:[newGoodsList objectAtIndex:indexPath.row - 1]];
        [tempGoodsInfo setObject:selectedStatusString forKey:@"selectState"];
        [LYSqllite Modifystate:[tempGoodsInfo objectForKey:@"commodity_id"] state:[tempGoodsInfo objectForKey:@"selectState"]];
        [newGoodsList setObject:tempGoodsInfo atIndexedSubscript:indexPath.row - 1];
    }
    
    [Goodslist setObject:newGoodsList atIndexedSubscript:indexPath.section];
    [m_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];

    number = 0;
    for (NSArray *listOne in Goodslist) {
        for (NSDictionary *goodsInfo in listOne) {
            if ([[goodsInfo objectForKey:@"selectState"] boolValue]) {
                number += 1;
            }
        }
    }
    m_storesNumber.text = [[NSString alloc] initWithFormat:@"共%d件商品", number];
}
-(IBAction)deleteGoods:(id)sender
{
    [LYSqllite delectGoods:@"1"];
    Goodslist = [[NSMutableArray alloc] init];
    Goodslist = [LYSqllite GetGoods];
    [m_tableView reloadData];
}
@end
