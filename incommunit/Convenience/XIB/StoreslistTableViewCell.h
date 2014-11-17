//
//  StoreslistTableViewCell.h
//  incommunit
//
//  Created by 李忠良 on 14/10/30.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreslistTableViewCell : UITableViewCell

@property (weak, nonatomic) UILabel *oreginPriceLabel;

- (void)setOreginPrice:(NSString *)price;

@end
