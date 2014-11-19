//
//  LYcertification.m
//  in_community
//  实名认证
//  Created by LANGYI on 14-10-13.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYcertification.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIActionSheet+Blocks.h"
#import "LMContainsLMComboxScrollView.h"
#define kDropDownListTag 1000
@interface LYcertification () {
    
    LMContainsLMComboxScrollView *bgScrollView;
}

@end

@implementation LYcertification

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
    _positiveimage.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showActionSheet:)];
    [_positiveimage addGestureRecognizer:singleTap];
    
    _reverseiamge.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showActionSheet:)];
    [_reverseiamge addGestureRecognizer:singleTap1];
    
    [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.submitButton.frame) + 50)];
    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:self.addressView.frame];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:bgScrollView];
    [self setUpBgScrollView];
    self.submitButton.layer.cornerRadius = 3.0f;
}

-(void)setUpBgScrollView
{
    for (NSInteger i = 0; i < 5; i++) {
        LMComBoxView *comBox = [[LMComBoxView alloc] initWithFrame:
                                CGRectMake(0 + (bgScrollView.frame.size.width / 5) * i,
                                           0,
                                           bgScrollView.frame.size.width / 5,
                                           bgScrollView.frame.size.height)];
        comBox.backgroundColor = [UIColor whiteColor];
        comBox.arrowImgName = @"down_dark0.png";
        NSMutableArray  *itemsArray = [[NSMutableArray alloc] initWithCapacity:1];
        comBox.delegate = self;
        comBox.supView = bgScrollView;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        [bgScrollView addSubview:comBox];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//正面
- (IBAction)positiveButon:(id)sender {
    
}

//反面
- (IBAction)reverseButton:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请选择图片来源"
                                                  message:@""
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [alert show];
}

#pragma 拍照选择模块
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [self shootPiicturePrVideo];
    }
    else if(buttonIndex==2){
        [self selectExistingPictureOrVideo];
    }
}

//从相机上选择
-(void)shootPiicturePrVideo{
    
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    
}

//从相册中选择
-(void)selectExistingPictureOrVideo{
    
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

//#pragma 拍照模块
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
//        if ([self positiveButon:self]) {
//            
//        }
        self.positiveimage.image=chosenImage;
    }
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate = self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}
static UIImage *shrinkImage(UIImage *orignal,CGSize size) {
    CGFloat scale=[UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef context=CGBitmapContextCreate(NULL, size.width *scale,size.height*scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width*scale, size.height*scale), orignal.CGImage);
    CGImageRef shrunken=CGBitmapContextCreateImage(context);
    UIImage *final=[UIImage imageWithCGImage:shrunken];
    CGContextRelease(context);
    CGImageRelease(shrunken);
    return  final;
}

- (IBAction)showActionSheet:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传照片"
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"拍照"
                                              otherButtonTitles:@"相册中选择", nil];
    [sheet showFromTabBar:[[self tabBarController] tabBar]
                  handler:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                      
                      if (buttonIndex == [actionSheet cancelButtonIndex]) {
                          
                          NSLog(@"Cancel button index tapped");
                          
                      } else if (buttonIndex == [actionSheet destructiveButtonIndex]) {
                          
                          NSLog(@"Destructive button index tapped");
                          [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
                          
                      } else  {
                          [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
                          NSLog(@"Button %li tapped", (long)buttonIndex);
                      }
                      
                  }];
}

- (IBAction)submitPress:(id)sender {
}

#pragma mark -
#pragma mark LMComBoxViewDelegate

-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    
}

@end
