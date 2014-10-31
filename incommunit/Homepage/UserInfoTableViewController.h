//
//  UserInfoTableViewController.h
//  UserInfo
//
//  Created by langyi on 14/10/24.
//  Copyright (c) 2014年 langyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTagCell : UICollectionViewCell

@end

@interface UserInfoTableViewController : UITableViewController

@property (strong, nonatomic) NSString *userLogoPath; //用户头像路径，setter方法需要修改
@property (strong, nonatomic) NSString *userNameString; //用户名字
@property (strong, nonatomic) NSString *userGenderString; //用户性别
@property (strong, nonatomic) NSString *userSignString; //个人签名
@property (strong, nonatomic) NSArray *addressList; //地址，最多为5个
@property (strong, nonatomic) NSArray *personalTagsList; //用户标签

- (IBAction)touchUserPhoto:(UITapGestureRecognizer *)sender; //点击头像的手势函数，需要修改
- (IBAction)addressPress:(UIButton *)sender; //点击地址

@end
