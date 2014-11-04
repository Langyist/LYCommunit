//
//  LYFeedback.h
//  in_community
//
//  Created by LANGYI on 14-10-20.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYFeedback : UIViewController <UITextFieldDelegate,UITextViewDelegate> {
    
    IBOutlet UITextField *mothedText;
    
    IBOutlet UITextView *m_textView;
}

@property (strong, nonatomic) IBOutlet UITextView *m_textView;

@property (strong, nonatomic) IBOutlet UITextField *mothedText;

@end
