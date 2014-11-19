//
//  LYReplyMessage.m
//  in_community
//  留言详情
//  Created by LANGYI on 14-10-12.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYReplyMessage.h"
#import "StoreOnlineNetworkEngine.h"
#import "MessageContentTableViewCell.h"
#import "AppDelegate.h"
#import "LYSqllite.h"
@interface LYReplyMessage ()

@end

@implementation LYReplyMessage

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.replyTextField.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageContentTableViewCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView setBackgroundColor:BK_GRAY];
    [self.view setBackgroundColor:BK_GRAY];
    
    self.replyButton.layer.cornerRadius = 3.0f;
    [self.replyButton setBackgroundColor:SPECIAL_GREEN];
    
    [self getMessageDetailData:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Method

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
                                                           if (!bValidJSON) {
                                                               UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                            message:errorMsg
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"确定"
                                                                                                  otherButtonTitles:nil, nil];
                                                               [al show];
                                                           }
                                                           else {
                                                               messageDetailDictionary = result;
                                                               [self.tableView reloadData];
                                                           }
                                                       }];

    
}

//pid是留言ID，需要当前登陆用户的ID，不知道从哪里获取
-(void)sendRequest:(NSString*)URL content:(NSString*)contentString pid:(NSString*)pid
{
    NSDictionary *dic = @{@"content" : contentString
                          ,@"pid" : messageID };
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
                                                               
                                                               [self getMessageDetailData:nil];
                                                           }
                                                       }];
    
}

#pragma mark -
#pragma mark UITextFieldDelegate

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

#pragma mark -
#pragma mark UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRowsInSection = 0;
    if (messageDetailDictionary) {
        numberOfRowsInSection = [[messageDetailDictionary objectForKey:@"replies"] count] + 1;
    }
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageContentTableViewCell" forIndexPath:indexPath];
    
    
    NSDictionary *info = nil;
    if (indexPath.row == 0) {
        info = messageDetailDictionary;
    }
    else {
        if (indexPath.row - 1 < [[messageDetailDictionary objectForKey:@"replies"] count]) {
            info = [[messageDetailDictionary objectForKey:@"replies"] objectAtIndex:indexPath.row - 1];
        }
    }
    
    if (info) {
        [cell setImagePath:[info objectForKey:@"head"]];
        [cell setUserName:[info objectForKey:@"nick_name"]];
        [cell setTimestamp:[info objectForKey:@"create_time"]];
        [cell setContent:[info objectForKey:@"content"]];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat heightForRowAtIndexPath = 0;
    
    NSDictionary *info = nil;
    if (indexPath.row == 0) {
        info = messageDetailDictionary;
    }
    else {
        if (indexPath.row - 1 < [[messageDetailDictionary objectForKey:@"replies"] count]) {
            info = [[messageDetailDictionary objectForKey:@"replies"] objectAtIndex:indexPath.row - 1];
        }
    }
    
    if (info) {
        heightForRowAtIndexPath = [MessageContentTableViewCell cellHeightWithContent:[info objectForKey:@"content"]];
    }
    
    return heightForRowAtIndexPath;
}

#pragma mark -
#pragma mark IBAction

- (IBAction)PostMessage:(id)sender
{
    messaggeString = self.replyTextField.text;
    self.replyTextField.text = @"";
    [self.replyTextField endEditing:YES];
    if (0 != [messaggeString length])
    {
        //pid是留言ID，需要当前登陆用户的ID，不知道从哪里获取
        [self sendRequest:nil content:messaggeString pid:nil];
    }
}

@end
