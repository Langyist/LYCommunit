//
//  LY_repair.h
//  in_community
//
//  Created by LANGYI on 14-10-13.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LY_repair : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titletextField;
@property (strong, nonatomic) IBOutlet UITextField *addresstextField;
@property (strong, nonatomic) IBOutlet UITextField *contentField;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UIImageView *addimageView;

@property(nonatomic,copy) NSString *lastChosenMediaType;

@end
