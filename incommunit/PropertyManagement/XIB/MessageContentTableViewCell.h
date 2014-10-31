//
//  MessageContentTableViewCell.h
//  incommunit
//
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageContentTableViewCell : UITableViewCell

- (void)setImagePath:(NSString *)imagePath;
- (void)setUserName:(NSString *)userName;
- (void)setTimestamp:(NSString *)timestampString;
- (void)setContent:(NSString *)content;

+ (CGFloat)cellHeightWithContent:(NSString *)content;

@end
