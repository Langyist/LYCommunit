//
//  LYReplyMessage.m
//  in_community
//  留言详情
//  Created by LANGYI on 14-10-12.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYReplyMessage.h"

@interface LYReplyMessage ()

@end

@implementation LYReplyMessage

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
    self.replyTextField.delegate = self;
    [NSThread detachNewThreadSelector:@selector(getMessageDetailData:) toTarget:self withObject:nil];
    self.firstNameLabel.text = [messageDetailDictionary objectForKey:@"nick_name"];
    self.firstTimeLabel.text = [NSString stringWithFormat:@"%@",[messageDetailDictionary objectForKey:@"create_time"]];
    self.contentLabel.text = [messageDetailDictionary objectForKey:@"content"];

    NSArray *repiesArray = [messageDetailDictionary objectForKey:@"replies"];
    for (int i = 0; i < [repiesArray count]; ++i)
    {
        //动态添加label
//        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]; //需要算坐标
//        nameLabel.text = [[repiesArray objectAtIndex:i] objectForKey:@"nick_name"];
//        [self.view addSubview:nameLabel];
//        
//        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]; //需要算坐标
//        timeLabel.text = [[repiesArray objectAtIndex:i] objectForKey:@"create_time"];
//        [self.view addSubview:timeLabel];
//        
//        UILabel *subContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]; //需要算坐标
//        subContentLabel.text = [[repiesArray objectAtIndex:i] objectForKey:@"content"];
//        [self.view addSubview:subContentLabel];
        
        //head,头像数据还未填充
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMessageID:(NSString*)idString
{
    messageID = idString;
}

-(BOOL)getMessageDetailData:(NSString*)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *urlstr = [plistDic objectForKey: @"URL"];
    
    NSError *error;
    NSString *urlString = [NSString stringWithFormat:@"%@/services/wuye/message/detail?id=%@",urlstr,messageID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (nil != error)
    {
        //错误码
        return NO;
    }
    NSDictionary *parseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    if (nil != error)
    {
        //错误码
        return NO;
    }
    if (![[parseData objectForKey:@"status"] isEqualToString:@"200"])
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:[parseData objectForKey:@"message"]
                                                    delegate:self
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil, nil];
        [al show];
        return NO;
    }
    messageDetailDictionary= [parseData objectForKey:@"data"];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.replyTextField resignFirstResponder];
    return YES;
}

//开始编辑输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.replyTextField) {
        NSTimeInterval animationDuration = 20.0f;
        CGRect frame = self.view.frame;
        frame.origin.y -=236;
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
    if (textField==self.replyTextField)
    {
        NSTimeInterval animationDuration = 20.0f;
        CGRect frame = self.view.frame;
        frame.origin.y +=236;
        //frame.size.height -=60;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

-(IBAction)PostMessage:(id)sender
{
    if (0 != [messaggeString length])
    {
        //pid是留言ID，需要当前登陆用户的ID，不知道从哪里获取
//        [self sendRequest:@"http://115.29.244.142" content:messaggeString pid:];
    }
}

//pid是留言ID，需要当前登陆用户的ID，不知道从哪里获取
-(BOOL)sendRequest:(NSString*)URL content:(NSString*)contentString pid:(NSString*)pid
{
    NSError *error;
    //    加载一个NSURL对象
    NSString    *URLString = [NSString stringWithFormat:@"%@/inCommunity/services/wuye/message/reply",URL];
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSString *str = @"content=";//设置参数
    NSString *str1 = @"pid=";
    str = [str stringByAppendingFormat:@"%@&%@%@",contentString,str1,pid];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
    if ([[weatherDic objectForKey:@"status"] isEqualToString:@"200"])
    {
        UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:@"回复发表成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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



@end
