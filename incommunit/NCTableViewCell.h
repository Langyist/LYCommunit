//
//  NCTableViewCell.h
//  incommunit
//
//  Created by 李忠良 on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCTableViewCell : UITableViewCell

- (void)setShowTopIcon:(BOOL)show;
- (void)setTitleImagePath:(NSString *)path;
- (void)setTitle:(NSString *)title;
- (void)setContent:(NSString *)content;
- (void)setTimestampString:(NSString *)timestamp;

@end
