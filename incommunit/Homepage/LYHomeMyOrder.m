//
//  LYMyOrder.m
//  in_community
//  我的订单
//  Created by wangliang on 14-10-22.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYHomeMyOrder.h"	
#import "AppDelegate.h"
#import "UIImageView+AsyncDownload.h"
#import "StoreOnlineNetworkEngine.h"
@interface OrderStoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation OrderStoreCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, SEPLINE_GRAY.CGColor);
    
    CGFloat linewidth = 0.5f;
    CGFloat space = 15;
    CGContextSetLineWidth(context, linewidth);
    
    CGContextMoveToPoint(context, space, CGRectGetHeight(rect) - 1); //start at this point
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - space, CGRectGetHeight(rect) - 1); //
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

- (void)setStoreName:(NSString *)name {
    
    [self.storeNameLabel setText:name];
    CGRect newFrame = self.storeNameLabel.frame;
    newFrame.size.width = MIN([LYHomeMyOrder widthOfString:name withFont:self.storeNameLabel.font], 120);
    self.storeNameLabel.frame = newFrame;
    CGFloat x = CGRectGetMaxX(newFrame) + 35;
    newFrame = self.arrowImageView.frame;
    newFrame.origin.x = x;
    self.arrowImageView.frame = newFrame;
}

- (void)setStatus:(NSString *)status {
    [self.orderStatusLabel setText:status];
    CGRect rect = self.orderStatusLabel.frame;
    CGFloat x = CGRectGetWidth(self.frame) - ( CGRectGetWidth(rect) + 16 );
    rect.origin.x = x;
    self.orderStatusLabel.frame = rect;
    //[self.orderStatusLabel setTextColor:TOP_BAR_YELLOW];
}

@end

@interface OrderItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation OrderItemCell

- (void)awakeFromNib {
    self.itemImageView.layer.cornerRadius = 3.0f;
    self.itemImageView.clipsToBounds = YES;
}

- (void)setImagePath:(NSString *)imagePath {
    if ([imagePath length]) {
        NSURL *url = [NSURL URLWithString:imagePath];
        [self.itemImageView setImageWithURL:url placeholderImage:nil];
    }
}

- (void)setItemName:(NSString *)name {
    [self.itemNameLabel setText:name];
}

- (void)setPrice:(CGFloat)price {
    NSString *priceString = [NSString stringWithFormat:@"￥%.2f", price];
    [self.priceLabel setText:priceString];
}

- (void)setNumber:(NSInteger)number {
    NSString *numberString = [NSString stringWithFormat:@"X%ld", (long)number];
    [self.numberLabel setText:numberString];
}

@end

@interface TotelItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation TotelItemCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, SEPLINE_GRAY.CGColor);
    
    CGFloat linewidth = 0.5f;
    CGFloat space = 15;
    CGContextSetLineWidth(context, linewidth);
    
    CGContextMoveToPoint(context, space, 0); //start at this point
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - space, 0);
    CGContextMoveToPoint(context, space, CGRectGetHeight(rect) - 1); //start at this point
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - space, CGRectGetHeight(rect) - 1); //
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

- (void)setPrice:(CGFloat)price {
    NSString *priceString = [NSString stringWithFormat:@"总计￥%.2f", price];
    [self.priceLabel setText:priceString];
}

- (void)setNumber:(NSInteger)number {
    NSString *numberString = [NSString stringWithFormat:@"共%ld件商品", (long)number];
    [self.numberLabel setText:numberString];
}

@end

@interface OpretionItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain, nonatomic) id<OpretionCellDelegate> opretionDelegate;

@end

@implementation OpretionItemCell

- (void)awakeFromNib {
    [self modifyButton:self.deleteButton];
    [self modifyButton:self.cancelButton];
}

- (void)modifyButton:(UIButton *)button {
    button.layer.borderWidth = 0.5f;
    button.layer.borderColor = SEPLINE_GRAY.CGColor;
    button.layer.cornerRadius = 3.0f;
}

- (IBAction)deletePress:(id)sender {
    if ([self.opretionDelegate respondsToSelector:@selector(deleteOrder:)]) {
        [self.opretionDelegate deleteOrder:self];
    }
}

- (IBAction)cancelPress:(id)sender {
    if ([self.opretionDelegate respondsToSelector:@selector(cancelOrder:)]) {
        [self.opretionDelegate cancelOrder:self];
    }
}

@end

@interface LYHomeMyOrder ()

@end

@implementation LYHomeMyOrder {
    NSArray *dataList; // 在dataList使用的地方，请用具体的数据列表代替；
}

- (void)viewDidLoad {
    [super viewDidLoad];
    m_pagesize = 10;
    m_pageOffset = 0;
    dataList = @[@"", @""];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
[self getmyorder];
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return m_MyOrderlist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    dataList = [[m_MyOrderlist objectAtIndex:section] objectForKey:@"commodities"];
    NSInteger numberOfItem = dataList.count;
    return numberOfItem+3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *retCell = nil;
    
    if (indexPath.row == 0) {
        OrderStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderStoreCell" forIndexPath:indexPath];
        [cell setStoreName:[[m_MyOrderlist objectAtIndex:indexPath.section] objectForKey:@"shopName"]];
        switch ([[[m_MyOrderlist objectAtIndex:indexPath.section] objectForKey:@"status"] intValue]) {
            case 0:
                [cell setStatus:@"新订单"];
                break;
            case 1:
                [cell setStatus:@"已接受订单"];
                break;
            case 2:
                [cell setStatus:@"已完成订单"];
                break;
            case 3:
                [cell setStatus:@"已拒绝订单"];
                break;
            default:
                break;
        }
        
        retCell = cell;
    }
    else if (indexPath.row == 3 + dataList.count - 2) {
        TotelItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TotelItemCell" forIndexPath:indexPath];
        [cell setPrice:[[[m_MyOrderlist objectAtIndex:indexPath.section] objectForKey:@"total_price"] intValue]];
        int  number = 0 ;
        for(int i =0;i<dataList.count;i++)
        {
            NSDictionary * temp = [dataList objectAtIndex:i];
            number = number+[[temp objectForKey:@"quantity"] intValue];
        }
        [cell setNumber:number];
        retCell = cell;
    }
    else if (indexPath.row == 3 + dataList.count - 1) {
        OpretionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpretionItemCell" forIndexPath:indexPath];
        cell.tag = indexPath.section;
        cell.opretionDelegate = self;
        retCell = cell;
    }
    else {
        NSDictionary * temp = [dataList objectAtIndex:indexPath.row-1];
        OrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemCell" forIndexPath:indexPath];
        [cell setItemName:[temp objectForKey:@"name"]];
        [cell setPrice:[[temp objectForKey:@"price"] intValue]];
        [cell setNumber:[[temp objectForKey:@"quantity"] intValue]];
        retCell = cell;
    }
    retCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return retCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRowAtIndexPath = 0;
    if (indexPath.row == 0) {
        heightForRowAtIndexPath = 41;
    }
    else if (indexPath.row == 3 + dataList.count - 2) {
        heightForRowAtIndexPath = 37;
    }
    else if (indexPath.row == 3 + dataList.count - 1) {
        heightForRowAtIndexPath = 47;
    }
    else {
        heightForRowAtIndexPath = 52;
    }
    return heightForRowAtIndexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"Shop" sender:nil];
    }
}

#pragma mark -
#pragma mark OpretionCellDelegate

- (void)deleteOrder:(OpretionItemCell *)cell {
    
}

- (void)cancelOrder:(OpretionItemCell *)cell {
    
}

#pragma mark 网络数据
- (void)getmyorder{
    NSDictionary *dic = @{@"pageSize" :[[NSString alloc] initWithFormat:@"%d",m_pagesize]
                          ,@"pageOffset" : [[NSString alloc] initWithFormat:@"%d",m_pageOffset]};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/order/mylist"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               NSLog(@"error %@",errorMsg);
                                                           }else
                                                           {
                                                               m_MyOrderlist =result;
                                                               [self.tableView reloadData];
                                                           }
                                                       }];
}

#pragma mark -
#pragma mark 据字号计算字符串的宽度
+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    if (string.length == 0) {
        return 0;
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

@end
