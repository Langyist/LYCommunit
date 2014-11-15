//
//  LY_repair.m
//  in_community
//  我要报修
//  Created by LANGYI on 14-10-13.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LY_repair.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#define CAMERA @"相机"
#define PHOTOES @"相册"

@interface LY_repair () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    
    UIActionSheet *sheet;
}

@end

@implementation LY_repair

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titletextField.delegate = self;
    self.addresstextField.delegate = self;
    self.contentField.delegate = self;
    self.submitButton.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GestureImage:)];
    [self.addimageView addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *closeKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    [self.view addGestureRecognizer:closeKeyboard];
}

- (void)closeKeyboard:(UITapGestureRecognizer *)tap {
    
    [self.titletextField resignFirstResponder];
    [self.addresstextField resignFirstResponder];
    [self.contentField resignFirstResponder];
}

- (void)GestureImage:(UITapGestureRecognizer *) tap {
    
    UIActionSheet *actionSheet = nil;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:CAMERA, PHOTOES, nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:PHOTOES, nil];
    }
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:CAMERA]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if ([title isEqualToString:PHOTOES]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if (data.length > 1024 * 200) {
            data = UIImageJPEGRepresentation(image, 1024.0f * 200.0f / (CGFloat)data.length);
            self.addimageView.image = image;
            
        }
    }];
}

//提交
- (IBAction)submitButton:(id)sender {
    
    NSLog(@"提交");
    [self getsaverepair:@""];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.titletextField) {
        [self.titletextField resignFirstResponder];
        [self.addresstextField becomeFirstResponder];
    }
    else if (textField == self.addresstextField) {
        
        [self.addresstextField resignFirstResponder];
        [self.contentField becomeFirstResponder];
    }
    else if (textField == self.contentField) {
        
        [self.contentField resignFirstResponder];
    }
    return YES;
}

#pragma mark 保存到网络数据
- (void)getsaverepair:(NSString *)url {
    
    NSError *error;
    //    加载一个NSURL对象
    NSString    *URLString = [NSString stringWithFormat:@"http://115.29.244.142/inCommunity/services/wuye/service/report"];
    NSURL *urlstr = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlstr cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *param=[NSString stringWithFormat:@"name=%@/position=%@/description=%@/picture=%@",self.titletextField.text,self.addresstextField.text,self.contentField.text,self.addimageView];
    NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *saveDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
    if ([[saveDic objectForKey:@"status"] isEqualToString:@"200"])
    {
        UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:@"报修发表成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }else
    {
        UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:[saveDic objectForKey:@"message"]
                                                  delegate:self
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
        [al show];
    }
}


@end
