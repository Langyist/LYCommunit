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
#import "StoreOnlineNetworkEngine.h"
#import "AppDelegate.h"

@interface LY_repair () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    
    UIActionSheet *sheet;
    
    UIView *editView;
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
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 15, 0, 15);
    [self.titletextField setTextInset:inset];
    [self.addresstextField setTextInset:inset];
    self.submitButton.layer.cornerRadius = 5;
    [self.submitButton setBackgroundColor:SPECIAL_GREEN];

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GestureImage:)];
    [self.addimageView addGestureRecognizer:gesture];
    
    [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.submitButton.frame) + 50)];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark UIKeyboardNotificationMethod

- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (rect.origin.y >= self.view.frame.origin.y) {
        CGFloat ty = -rect.size.height;
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                         animations:^{
                             UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, -ty, 0);
                             [self.scrollView setContentInset:inset];
                             
                             [self.scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(editView.frame) - 50)];
                         }];
    }
}

- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [self.scrollView setContentInset:UIEdgeInsetsZero];
                     }];
}

#pragma mark -
#pragma mark Method

- (void)getsaverepair:(NSString *)url
{
    NSDictionary *dic = @{@"name" : self.titletextField.text
                          ,@"position" : self.addresstextField.text
                          ,@"description" : self.contentField.text
                          ,@"picture" : self.addimageView};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/service/report"
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
                                                                                                          message:@"报修发表成功！"
                                                                                                         delegate:self
                                                                                                cancelButtonTitle:@"确定"
                                                                                                otherButtonTitles:nil, nil];
                                                               [al show];
                                                               
                                                           }
                                                       }];
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

#pragma mark -
#pragma mark IBAction

- (IBAction)submitButton:(id)sender {
    [self getsaverepair:@""];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    editView = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    editView = textView;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.holdlabel.hidden = !(0 == textView.text.length);
}

@end
