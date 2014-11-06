//
//  LYFeedback.h
//  in_community
//
//  Created by LANGYI on 14-10-20.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetTextField.h"

@interface LYFeedback : UIViewController <UITextFieldDelegate,UITextViewDelegate> {
    
    IBOutlet InsetTextField *mothedText;
    
    IBOutlet UITextView *m_textView;
}

@property (strong, nonatomic) IBOutlet UITextView *m_textView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) IBOutlet InsetTextField *mothedText;

@end
