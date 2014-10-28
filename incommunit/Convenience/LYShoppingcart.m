//
//  LYShoppingcart.m
//  incommunit
//  购物车界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYShoppingcart.h"
#import "LYSqllite.h"
@interface LYShoppingcart ()

@end

@implementation LYShoppingcart
{
  NSDictionary * selectCell;
}

@synthesize m_tableView,m_storesNumber;
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
    number= 0;
    selectCell = [[NSDictionary alloc] init];
    m_textfiledlist = [[NSMutableArray alloc] init];
    self.m_tableView.allowsSelectionDuringEditing = YES;
    Goodslist = [LYSqllite GetGoods];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return Goodslist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *temp = [Goodslist objectAtIndex:section];
    return temp.count+1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    NSMutableArray *tempinfo = [Goodslist objectAtIndex:indexPath.section];
    static NSString *CellIdentifier;
    if (indexPath.row == 0) {
        CellIdentifier = @"selectStoresCell";
        if (cell == nil)
        {
            NSDictionary * temp = [tempinfo objectAtIndex:indexPath.row];
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            m_imge = (UIImageView *)[cell viewWithTag:100];
            [m_imge setImage:[UIImage imageNamed:@"Unselected.png"]];
            UILabel *name = (UILabel *)[cell viewWithTag:101];
            name.text = [temp objectForKey:@"Storesname"];
        }
    }else
    {
        CellIdentifier = @"selectGoodsCell";
        if (cell == nil)
        {
            NSDictionary * temp = [tempinfo objectAtIndex:indexPath.row-1];
            cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            m_imge = (UIImageView *)[cell viewWithTag:100];
            [m_imge setImage:[UIImage imageNamed:@"Unselected.png"]];
            UILabel *name = (UILabel *)[cell viewWithTag:102];
            name.text = [temp objectForKey:@"name"];
            UITextField *quantityfl = (UITextField *)[cell viewWithTag:105];
            quantityfl.text = [temp objectForKey:@"quantity"];
            UILabel *pricelb = (UILabel *)[cell viewWithTag:103];
            pricelb.text = [[NSString alloc] initWithFormat:@"￥%@.00",[temp objectForKey:@"price"]];
            UIButton *LessButton = [[UIButton alloc] init];
            LessButton = (UIButton *)[cell viewWithTag:106];
            LessButton.tag = indexPath.row-1;
            
            UIButton *addButton = [[UIButton alloc] init];
            addButton = (UIButton *)[cell viewWithTag:104];
            addButton.tag = indexPath.row-1;
            [m_textfiledlist addObject:quantityfl];
            number ++;
        }
    }
    m_storesNumber.text = [[NSString alloc] initWithFormat:@"共%d件商品",number];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *oneCell = [tableView cellForRowAtIndexPath:indexPath];
    [self changeCheckBox:YES tableViewCell:oneCell];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) {
    UITableViewCell *oneCell = [tableView cellForRowAtIndexPath:indexPath];
    [self changeCheckBox:NO tableViewCell:oneCell];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 50;
    }else
    {
        return 74;
    }
}

-(IBAction)add:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UITextField *ft = [[UITextField alloc] init];
    ft = [m_textfiledlist objectAtIndex:btn.tag];
    ft.text = [[NSString alloc]initWithFormat:@"%d",[ft.text intValue]+1];
}

-(IBAction)lss:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UITextField *ft = [[UITextField alloc] init];
    ft = [m_textfiledlist objectAtIndex:btn.tag];
    if ([ft.text intValue]>0)
    {
        ft.text = [[NSString alloc]initWithFormat:@"%d",[ft.text intValue]-1];
    }
}
//获取网络图片
-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    NSLog(@"执行图片下载函数");
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

-(IBAction)Settlement:(id)sender
{
    [self performSegueWithIdentifier:@"GoSettlement" sender:self];
}

#pragma mark -
#pragma mark Method

- (void)changeCheckBox:(BOOL)isSelected tableViewCell:(UITableViewCell *)cell {
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    if (isSelected) {
        imageView.image = [UIImage imageNamed:@"Selected.png"];
    }
    else {
        imageView.image = [UIImage imageNamed:@"Unselected.png"];
    }
}

@end
