//
//  InfoHeader.h
//  incommunit
//
//  Created by 李忠良 on 14/10/31.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoHeader : UIView

- (void)setTitle:(NSString *)title;
- (void)setTime:(NSString *)timestamp;
- (void)setAddress:(NSString *)address;
- (void)setPhone:(NSString *)phone;

@end
