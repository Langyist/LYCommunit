//
//  LY_MaintenanceCell.h
//  in_community
//
//  Created by LangYi on 14-10-9.
//  Copyright (c) 2014年 LangYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LY_MaintenanceCell : UITableViewCell {
    
    
}

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *headNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
