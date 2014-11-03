//
//  LYPostcomment.m
//  in_community
//  发表评论界面
//  Created by LANGYI on 14-10-12.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYPostcomment.h"

@interface LYPostcomment () {
    
    CGSize keyboardSize;
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
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(IBAction)PostMessage:(id)sender
{
    if (0 != [messaggeString length])
    {
        [self sendRequest:@"http://115.29.244.142" content:messaggeString];
    }
}


-(BOOL)sendRequest:(NSString*)URL content:(NSString*)contentString
{
    NSError *error;
    //    加载一个NSURL对象
    NSString    *URLString = [NSString stringWithFormat:@"%@/inCommunity/services/wuye/message/deploy",URL];
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"content=";//设置参数
    str = [str stringByAppendingFormat:@"%@",contentString];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
    if ([[weatherDic objectForKey:@"status"] isEqualToString:@"200"])
    {
        UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:@"留言发表成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        return YES;
    }else
    {
        return NO;
    }
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.postButton.enabled = NO;
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    messaggeString = textView.text;
    self.postButton.enabled = YES;
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
