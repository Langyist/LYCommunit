//
//  LYMyOrder.h
//  in_community
//
//  Created by wangliang on 14-10-22.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpretionItemCell;

@protocol OpretionCellDelegate <NSObject>
@required

- (void)deleteOrder:(OpretionItemCell *)cell;

@optional

- (void)cancelOrder:(OpretionItemCell *)cell;

@end

@interface LYHomeMyOrder : UIViewController
<
OpretionCellDelegate
>
{
    int m_pagesize;
    int m_pageOffset;
    NSMutableArray *m_MyOrderlist;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font;

@end
