//
//  LYNeighborhoodCell.h
//  in_community
//
//  Created by wangliang on 14-10-24.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYNeighborhoodCell;

typedef void (^DeletePressBlock)(LYNeighborhoodCell *cell);

@interface LYNeighborhoodCell : UITableViewCell

- (void)setImagePath:(NSString *)imagePath;
- (void)setName:(NSString *)name;
- (void)setSummary:(NSString *)summray;
- (void)setDeleteBlock:(DeletePressBlock)deletePressBlock;

@end
