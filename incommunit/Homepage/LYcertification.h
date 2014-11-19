//
//  LYcertification.h
//  in_community

//  Created by LANGYI on 14-10-13.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMComBoxView.h"

@interface LYcertification : UIViewController <LMComBoxViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *positiveimage;
@property (strong, nonatomic) IBOutlet UIImageView *reverseiamge;
@property (weak, nonatomic) IBOutlet UILabel *positiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *reverseLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *addressView;

- (IBAction)submitPress:(id)sender;
@property(nonatomic,copy) NSString *lastChosenMediaType;
@end
