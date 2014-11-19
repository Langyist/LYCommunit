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
#define CAMERA @"相机"
#define PHOTOES @"相册"

@interface LYcertification ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    LMContainsLMComboxScrollView *bgScrollView;
    NSArray *photoImageDataList;
    int  temptag;
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
    _positiveimage.tag = 101;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showActionSheet:)];
    [_positiveimage addGestureRecognizer:singleTap];
    
    _reverseiamge.userInteractionEnabled=YES;
    _reverseiamge.tag = 102;
    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showActionSheet:)];
    [_reverseiamge addGestureRecognizer:singleTap1];
    
    [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.submitButton.frame) + 70)];
    
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

- (void)showActionSheet:(UITapGestureRecognizer *) tap {
    if (tap.view.tag == self.positiveimage.tag) {
        temptag = self.positiveimage.tag;
    }else if (tap.view.tag == self.reverseiamge.tag) {
        temptag = self.reverseiamge.tag;
    }
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
        }
        if (temptag == 101) {
            self.positiveimage.image = image;
        }else if (temptag == 102)
        {
            self.reverseiamge.image = image;
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
