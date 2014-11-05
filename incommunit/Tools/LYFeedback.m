//
//  LYFeedback.m
//  in_community
//  意见反馈
//  Created by LANGYI on 14-10-20.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYFeedback.h"
#import "LYSelectCommunit.h"

@interface LYFeedback ()

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
    }
    return YES;
}

#pragma mark 请求数据
- (void)getFeedback:(NSString *)url
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *urlstr = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *URLstr =[[NSString alloc] initWithFormat:@"%@/services/feedback/add?contact_info=%@&content=%@&community_id=%@",urlstr,m_textView.text,mothedText.text,[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"]];
    NSURL *strurl = [NSURL URLWithString:URLstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:strurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
    if ([[weatherDic objectForKey:@"status"] isEqualToString:@"200"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示！" message:[weatherDic objectForKey:@"提交成功"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示！" message:[weatherDic objectForKey:@"message"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
