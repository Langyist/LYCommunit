//
//  LY_repair.h
//  in_community
//
//  Created by LANGYI on 14-10-13.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetTextField.h"

@interface LY_repair : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet InsetTextField *titletextField;
@property (weak, nonatomic) IBOutlet InsetTextField *addresstextField;
@property (weak, nonatomic) IBOutlet UITextView *contentField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *addimageView;
@property (weak, nonatomic) IBOutlet UILabel *holdlabel;

@property(nonatomic,copy) NSString *lastChosenMediaType;

@end
