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
    self.m_messagetext.delegate = self;
    self.m_messagetext.returnKeyType = UIReturnKeyDone;
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
        UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:[weatherDic objectForKey:@"message"]
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
        [al show];
        return NO;
    }
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.postButton.enabled = NO;
    
    return YES;
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    messaggeString = textField.text;
    self.postButton.enabled = YES;
    return YES;
}


@end
