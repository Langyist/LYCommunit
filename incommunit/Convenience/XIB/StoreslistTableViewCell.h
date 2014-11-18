//
//  StoreslistTableViewCell.h
//  incommunit
//
//  Created by 李忠良 on 14/10/30.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreslistTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oreginPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)setOreginPrice:(NSString *)price;
- (void)setPrice:(NSString *)price;

@end
