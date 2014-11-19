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
#import "StoreOnlineNetworkEngine.h"
#define kDropDownListTag 1000
#define CAMERA @"相机"
#define PHOTOES @"相册"

@interface LYcertification ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    LMContainsLMComboxScrollView *bgScrollView;
    
    NSMutableArray *PeriodData;
    NSMutableArray *BuildingData;
    NSMutableArray *UnitData;
    NSMutableArray *HouseholdsData;
    NSMutableArray *HomeNumber;
    NSMutableArray *allPeriodData;
    NSMutableArray * comboxlist;
    
    NSMutableArray *temp;
    NSMutableArray * tempdata1;
    NSMutableArray * tempdata2;
    NSMutableArray * tempdata3;
    NSMutableArray * tempdata4;
    NSMutableArray * tempdata5;
    
    NSString * m_communitid;
    NSString *l1str;
    NSString *l2str;
    NSString *l3str;
    NSString *l4str;
    NSString *l5str;
    
    NSArray *photoImageDataList;
    int  temptag;
}
@property (weak, nonatomic) IBOutlet UILabel *m_lableinfo;
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
                                CGRectMake(self.m_lableinfo.frame.origin.x + (self.m_lableinfo.frame.size.width / 5) * i,
                                           0,
                                           self.m_lableinfo.frame.size.width / 5,
                                           35)];
        comBox.backgroundColor = [UIColor whiteColor];
        comBox.arrowImgName = @"down_dark0.png";
        NSMutableArray  *itemsArray = [[NSMutableArray alloc]initWithCapacity:1];
        switch (i) {
            case 0:
                [self done:m_communitid pid:@"0" ComBoxView:comBox index:@"0"];
                break;
            case 1:
                if(BuildingData.count>0)
                {
                    [itemsArray addObjectsFromArray:BuildingData];
                    comBox.titlesList = itemsArray;
                }
                break;
            case 2:
                if (UnitData.count>0) {
                    [itemsArray addObjectsFromArray:UnitData];
                    comBox.titlesList = itemsArray;
                }
                break;
            case 3:
                if (HouseholdsData.count>0) {
                    [itemsArray addObjectsFromArray:HouseholdsData];
                    comBox.titlesList = itemsArray;
                }
                break;
            case 4:
                if (HomeNumber.count>0) {
                    [itemsArray addObjectsFromArray:HomeNumber];
                    comBox.titlesList = itemsArray;
                }
                break;
            default:
                break;
        }
        comBox.delegate = self;
        comBox.supView = bgScrollView;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        [bgScrollView addSubview:comBox];
        [comboxlist addObject:comBox];
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

- (IBAction)submitPress:(id)sender {
}

#pragma mark -
#pragma mark LMComBoxViewDelegate

-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    
}

#pragma mark Network

- (void)done:(NSString *)COMMUNITY_ID pid:(NSString *)PID ComBoxView:(LMComBoxView *)BoxView index:(NSString *)index
{
//    NSDictionary *dic = @{ @"community_id" : COMMUNITY_ID
//                           ,@"pid" : PID
//                           };
//    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/community/level"
//                                                            params:dic
//                                                            repeat:YES
//                                                             isGet:YES
//                                                          activity:YES
//                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
//                                                           if(!bValidJSON)
//                                                           {
//                                                               UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                                                               [al show];
//                                                           }else
//                                                           {
//                                                               if ([index isEqual:@"0"]) {
//                                                                   tempdata1 = result;
//                                                                   if (tempdata1.count>0) {
//                                                                       for (int i = 0; i<tempdata1.count; i++)
//                                                                       {
//                                                                           [PeriodData addObject:[[tempdata1 objectAtIndex:i] objectForKey:@"name"]];
//                                                                       }
//                                                                       BoxView.titlesList = PeriodData;
//                                                                       [BoxView reloadData];
//                                                                   }
//                                                               }else if ([index isEqual:@"1"])
//                                                               {
//                                                                   tempdata2 = result;
//                                                                   for (int i = 0; i<tempdata2.count; i++) {
//                                                                       [BuildingData addObject:[[tempdata2 objectAtIndex:i] objectForKey:@"name"]];
//                                                                   }
//                                                                   BoxView.titlesList = BuildingData;
//                                                                   [BoxView reloadData];
//                                                               }else if([index isEqual:@"2"])
//                                                               {
//                                                                   tempdata3 = result;
//                                                                   for (int i = 0; i<tempdata3.count; i++)
//                                                                   {
//                                                                       [UnitData addObject:[[tempdata3 objectAtIndex:i] objectForKey:@"name"]];
//                                                                       
//                                                                   }
//                                                                   BoxView.titlesList = UnitData;
//                                                                   [BoxView reloadData];
//                                                               }else if([index isEqual:@"3"])
//                                                               {
//                                                                   tempdata4 = result;
//                                                                   for (int i = 0; i<tempdata4.count; i++)
//                                                                   {
//                                                                       [HouseholdsData addObject:[[tempdata4 objectAtIndex:i] objectForKey:@"name"]];
//                                                                   }
//                                                                   BoxView.titlesList = HouseholdsData;
//                                                                   [BoxView reloadData];
//                                                               }else if([index isEqual:@"4"])
//                                                               {
//                                                                   tempdata5 = result;
//                                                                   for (int i = 0; i<tempdata5.count; i++)
//                                                                   {
//                                                                       [HomeNumber addObject:[[tempdata5 objectAtIndex:i] objectForKey:@"name"]];
//                                                                   }
//                                                                   BoxView.titlesList = HomeNumber;
//                                                                   [BoxView reloadData];
//                                                               }
//                                                           }
//                                                       }];
}

@end
