//
//  LYUserloginView.h
//  incommunit
//  用户登陆界面
//  Created by LANGYI on 14/10/26.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LYUserloginView : UIViewController<UITextFieldDelegate,UINavigationBarDelegate>
{
    @private UITextField *userText;
    @private UITextField *passwordtext;
    @private UIActivityIndicatorView* login;
    @private UIImageView *m_iamgeview;
    @public NSString *community_id;
    @public NSString *community_Name;
    @public BOOL m_bool;
    @public NSMutableDictionary *USERinfo;
    @private UIView *m_Pview;
    @private UILabel *m_communityName;
    NSMutableDictionary * userinfo;
    UIButton *m_loginbutton;
}
@property(nonatomic, retain)IBOutlet UITextField *userText;
@property(nonatomic, retain)IBOutlet UITextField *passwordtext;
@property(nonatomic, retain)IBOutlet UIActivityIndicatorView *login;
@property(nonatomic, retain)IBOutlet UIView *m_Pview;
@property(nonatomic, retain)IBOutlet UIImageView * m_iamgeview;
@property(nonatomic, retain)IBOutlet UILabel * m_communityName;
@property(nonatomic, retain)IBOutlet UIButton * m_loginbutton;

-(IBAction)returnPage:(id)sender;
+(BOOL )Getourist;
@end

