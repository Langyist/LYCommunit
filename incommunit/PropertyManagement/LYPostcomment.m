//
//  LYPostcomment.m
//  in_community
//  发表评论界面
//  Created by LANGYI on 14-10-12.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYPostcomment.h"
#import "StoreOnlineNetworkEngine.h"
@interface LYPostcomment () {
    
}

@end

@implementation LYPostcomment
@synthesize m_messagetext;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.postButton.layer.cornerRadius = 3.0f;
    self.postButton.clipsToBounds = YES;
    
    [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.postButton.frame) + 50)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)closeKeyBoard {
    
    [self.m_messagetext resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.m_messagetext.delegate = self;
    self.m_messagetext.returnKeyType = UIReturnKeyDone;
}

-(IBAction)PostMessage:(id)sender
{
    if (0 != [messaggeString length])
    {
        [self sendRequest:@"http://121.40.207.159/inCommunity/" content:messaggeString];
    }else {
        
        UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:@"留言内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
}

-(BOOL)sendRequest:(NSString*)URL content:(NSString*)contentString
{
    if (!contentString) {
        contentString = @"";
    }
    
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/message/deploy"
                                                            params:@{
                                                                     @"content" : contentString
                                                                     }
                                                            repeat:YES
                                                             isGet:NO
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if (!bValidJSON) {
                                                               UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                            message:errorMsg
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"确定"
                                                                                                  otherButtonTitles:nil, nil];
                                                               [al show];
                                                           }
                                                           else {
                                                               UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                            message:@"发表留言成功"
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"确定"
                                                                                                  otherButtonTitles:nil, nil];
                                                               [al show];
                                                               [self.navigationController popViewControllerAnimated:YES];
                                                           }
                                                       }];
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
#pragma mark UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    self.postButton.enabled = NO;
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    messaggeString = textView.text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    messaggeString = textField.text;
    self.postButton.enabled = YES;
//    [self PostMessage:@""];
    return YES;
}

- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(rect), 0);
                         [self.scrollView setContentInset:inset];
                     }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self.m_messagetext resignFirstResponder];
    }
}

#pragma mark 键盘即将退出

- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [self.scrollView setContentInset:UIEdgeInsetsZero];
                     }];
}

@end
