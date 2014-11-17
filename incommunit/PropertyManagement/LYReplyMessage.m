//
//  LYReplyMessage.m
//  in_community
//  留言详情
//  Created by LANGYI on 14-10-12.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYReplyMessage.h"
#import "StoreOnlineNetworkEngine.h"
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

-(void)getMessageDetailData:(NSString*)URL
{

    NSDictionary *dic = @{@"id" : messageID};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/message/detail"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                            message:errorMsg
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"确定"
                                                                                                  otherButtonTitles:nil, nil];
                                                               [al show];
                                                           }else
                                                           {
                                                               messageDetailDictionary = result;
                                                               
                                                           }
                                                       }];

    
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
-(void)sendRequest:(NSString*)URL content:(NSString*)contentString pid:(NSString*)pid
{
    NSDictionary *dic = @{@"content" : contentString
                            ,@"pid" : pid };
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/message/reply"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:NO
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示"
                                                                                                          message:errorMsg
                                                                                                         delegate:self
                                                                                                cancelButtonTitle:@"确定"
                                                                                                otherButtonTitles:nil, nil];
                                                               [al show];
                                                           }else
                                                           {
                                                               UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示"
                                                                                                          message:@"回复发表成功！"
                                                                                                         delegate:self
                                                                                                cancelButtonTitle:@"确定"
                                                                                                otherButtonTitles:nil, nil];
                                                               [al show];

                                                           }
                                                       }];

}

@end
