//
//  LYPostcomment.h
//  in_community
//  发表评论界面
//  Created by LANGYI on 14-10-12.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYPostcomment : UIViewController<UITextFieldDelegate>
{
    UITextField *m_messagetext;
    NSString    *messaggeString;
}
@property (strong, nonatomic) IBOutlet UIButton *postButton;
@property(nonatomic,retain)IBOutlet UITextField *m_messagetext;
@end
