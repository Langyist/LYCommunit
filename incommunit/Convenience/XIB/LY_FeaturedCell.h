//
//  LY_FeaturedCell.h
//  in_community
//
//  Created by wangliang on 14-9-20.
//  Copyright (c) 2014年 wangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LY_FeaturedCell : UITableViewCell
{
    IBOutlet UIImageView *m_imageview;
    IBOutlet UILabel *lable1;
}
@property (strong, nonatomic) IBOutlet UIImageView *m_imageview;

@property(copy, nonatomic) UIImage *m_iamge;
@end
