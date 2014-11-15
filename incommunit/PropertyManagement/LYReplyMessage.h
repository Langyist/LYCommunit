//
//  LYReplyMessage.h
//  in_community
//
//  Created by LANGYI on 14-10-12.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYReplyMessage : UIViewController<UITextFieldDelegate>
{
    NSString *messageID;
    NSDictionary *messageDetailDictionary;
    NSString    *messaggeString;
}

-(void)setMessageID:(NSString*)idString;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstTimeLabel;
@property (strong, nonatomic) IBOutlet UITextField *replyTextField;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end
