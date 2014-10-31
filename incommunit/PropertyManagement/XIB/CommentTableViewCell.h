//
//  CommentTableViewCell.h
//  incommunit
//
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

- (void)setContent:(NSArray *)contentList;

+ (CGFloat)cellHeightWithContent:(NSArray *)contentList;

@end
