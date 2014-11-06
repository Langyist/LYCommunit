//
//  LYFeedback.m
//  in_community
//  意见反馈
//  Created by LANGYI on 14-10-20.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYFeedback.h"
#import "LYSelectCommunit.h"

@interface LYFeedback () <UIScrollViewDelegate>

@end

@implementation LYFeedback
@synthesize mothedText,m_textView;

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
    mothedText.delegate = self;
    mothedText.keyboardType = UIKeyboardTypeNamePhonePad;
    
    m_textView.delegate = self;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downKeyboard)];
    [self.view addGestureRecognizer:gesture];
    
    self.submitButton.layer.cornerRadius = 3.0f;
}

- (void)downKeyboard {
    
    [m_textView resignFirstResponder];
    [mothedText resignFirstResponder];
}

//提交
- (IBAction)commitButton:(id)sender
{
    [self getFeedback:@""];
}

#pragma mark UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == mothedText) {
        [mothedText resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == mothedText) {
        if (mothedText.text.length >= 40) {
            return NO;
        }
    }
    return YES;
}

//开始编辑输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==mothedText) {
        NSTimeInterval animationDuration = 1.0f;
        CGRect frame = self.view.frame;
        frame.origin.y -=115;
        //frame.size.height +=60;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView commitAnimations];
    }
}
//结束编辑输入框
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==mothedText)
    {
        NSTimeInterval animationDuration = 1.0f;
        CGRect frame = self.view.frame;
        frame.origin.y +=115;
        //frame.size.height -=60;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

#pragma mark UITextView delegate 
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [mothedText becomeFirstResponder];
        return NO;
    }else if (textView == m_textView) {
        
        if (m_textView.text.length >= 500)
        return NO;
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == m_textView) {
        [m_textView resignFirstResponder];
    }
}

#pragma mark 请求数据
- (void)getFeedback:(NSString *)url
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *urlstr = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString    *URLString = [NSString stringWithFormat:@"%@/services/feedback/add?",urlstr];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"contact_info=";//设置参数
    str = [str stringByAppendingFormat:@"%@&content=%@&community_id=%@",mothedText.text,m_textView.text,[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"]];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
    if ([[weatherDic objectForKey:@"status"] isEqualToString:@"200"])
    {
        UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:@"提交信息成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }else
    {
        UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:@"提交信息失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }

}

@end
