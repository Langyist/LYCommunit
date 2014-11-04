//
//  LYaddCommunit.h
//  incommunit
//
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMComBoxView.h"
#import "InsetTextField.h"
#import "LMContainsLMComboxScrollView.h"
@interface LYaddCommunit : UIViewController<LMComBoxViewDelegate>
{
    UILabel *m_lableinfo;
    InsetTextField *m_Nickname;
    UIImageView *m_iamgeview;
    UIButton *m_button;
    NSString * m_communitid;
    NSMutableArray *m_Addresslist;
    NSMutableArray *m_AddressNamelist;
    NSMutableArray * comboxlist;
}
@property(nonatomic,retain)IBOutlet UILabel *m_lableinfo;
@property(nonatomic,retain)IBOutlet InsetTextField *m_Nickname;
@property(nonatomic,retain)IBOutlet UIImageView *m_iamgeview;
@property(nonatomic,retain)IBOutlet UIButton *m_button;
@property(nonatomic,copy) NSString *lastChosenMediaType;

@end
