//
//  TagsCollectionViewController.h
//  UserInfo
//  个人资料
//  Created by langyi on 14/10/24.
//  Copyright (c) 2014年 langyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface TagCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@end
@interface TagSctionTitle : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
@interface TagsCollectionViewController : UICollectionViewController
@end
