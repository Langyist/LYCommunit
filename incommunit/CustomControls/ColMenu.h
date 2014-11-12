//
//  ColMenu.h
//  incommunit
//
//  Created by 李忠良 on 14/11/5.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ColMenu;

@protocol ColMenuDelegate <NSObject>

@required

- (NSInteger)colMune:(ColMenu *)colMenu numberOfRowsInSection:(NSInteger)section;
- (NSString *)colMune:(ColMenu *)colMenu titleForItemOfSection:(NSInteger)section row:(NSInteger)row;

@optional

- (NSInteger)sectionOfColMenu:(ColMenu *)colMenu;
- (void)colMune:(ColMenu *)colMenu didSelectItemOfSection:(NSInteger)section row:(NSInteger)row;
- (NSString *)colMune:(ColMenu *)colMenu titleForHeaderOfSection:(NSInteger)section;

@end

@interface ColMenu : NSObject

+ (instancetype) sharedMenu;

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
               delegate:(id<ColMenuDelegate>)delegate;

+ (void) reloadData;

+ (void) dismissMenu;

+ (void) setSeletectItemOfSection:(NSInteger)section row:(NSInteger)row;

@end
