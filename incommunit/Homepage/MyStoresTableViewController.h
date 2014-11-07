//
//  MyStoresTableViewController.h
//  incommunit
//
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColMenu.h"

@interface MyStoresItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;

@end

@interface MyStoresTableViewController : UITableViewController
<
    ColMenuDelegate
>

@end
