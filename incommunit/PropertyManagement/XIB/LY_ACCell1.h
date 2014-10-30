//
//  LY_ACCell1.h
//  in_community
//
//  Created by LangYi on 14-10-9.
//  Copyright (c) 2014年 LangYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LY_ACCell1 : UITableViewCell {
    
    IBOutlet UIImageView *m_imageView;
    IBOutlet UIImageView *m_imageRq;
}

@property (strong, nonatomic) IBOutlet UIImageView *m_imageView;
@property (strong, nonatomic) IBOutlet UIImageView *m_imageRq;
@property(copy, nonatomic) UIImage *m_iamge;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end
