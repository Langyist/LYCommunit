//
//  LYaddCommunit.m
//  incommunit
//  加入小区界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYaddCommunit.h"
#import "LMContainsLMComboxScrollView.h"
#import "LYSelectCommunit.h"
#import "UIActionSheet+Blocks.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "LYUserloginView.h"

#define kDropDownListTag 1000
@interface LYaddCommunit () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    LMContainsLMComboxScrollView *bgScrollView;
    NSArray *PeriodData;
    NSArray *BuildingData;
    NSArray *UnitData;
    NSArray *HouseholdsData;
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedArea;
    
    UIActionSheet *sheet;
}

@end
@implementation LYaddCommunit
@synthesize  m_lableinfo,m_Nickname,m_iamgeview,m_button;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [m_Nickname setShowBorderLine:NO];
    [m_Nickname setTextInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    [m_button.layer setMasksToBounds:YES];
    [m_button.layer setCornerRadius:3.0];
    
    m_Nickname.delegate = self;

    CALayer *lay  = m_iamgeview.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:CGRectGetHeight(m_iamgeview.frame) / 2];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0]];
    [customLab setText:[[NSString alloc]initWithFormat:@"成为%@小区居民",[[LYSelectCommunit GetCommunityInfo] objectForKey:@"name"]]];
    customLab.font = [UIFont boldSystemFontOfSize:17];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0];
    self.navigationController.navigationBar.hidden = NO;
    
    PeriodData = [[NSArray alloc] initWithObjects:@"一期",@"二期",@"三期", nil];
    BuildingData = [[NSArray alloc]initWithObjects:@"栋", nil];
    UnitData = [[NSArray alloc]initWithObjects:@"单元", nil];
    HouseholdsData = [[NSArray alloc]initWithObjects:@"户", nil];
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(m_lableinfo.frame), self.view.frame.size.width, 35)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    [self setUpBgScrollView];
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickView)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    
    m_iamgeview.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Photograph)];
    [m_iamgeview addGestureRecognizer:singleTap];
    
    //[self.view addSubview:m_iamgeview];
    // Do any additional setup after loading the view.
}
-(void)Photograph
{
    
    sheet = [[UIActionSheet alloc] initWithTitle:@"上传照片"
                                                    delegate:nil
                                            cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:@"拍照"
                                            otherButtonTitles:@"相册中选择", nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        
    }else if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        [self shootPiicturePrVideo];
    }else {
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
        m_iamgeview.image = chosenImage;
    }
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentModalViewController:picker animated:YES];
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

-(void)ClickView
{
    [m_Nickname resignFirstResponder];
}

-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    // NSDictionary *temp;
    switch (_combox.tag) {
        case 1000:
            if (index>0) {
                //categoryid =[PeriodData objectAtIndex:index];
            }else
            {
                // categoryid = @"";
            }
            //[NSThread detachNewThreadSelector:@selector(serachGoods:) toTarget:self withObject:nil];
            break;
        case 1001:
            //categoryid = [[NSString alloc] initWithFormat:@"%d",index+1];
            break;
        default:
            break;
    }
}
-(void)setUpBgScrollView
{
    for (NSInteger i = 0; i < 5; i++) {
        LMComBoxView *comBox = [[LMComBoxView alloc] initWithFrame:
                                CGRectMake(m_lableinfo.frame.origin.x + (m_lableinfo.frame.size.width / 5) * i,
                                           0,
                                           m_lableinfo.frame.size.width / 5,
                                           35)];
        comBox.backgroundColor = [UIColor whiteColor];
        comBox.arrowImgName = @"down_dark0.png";
        NSMutableArray  *itemsArray = [[NSMutableArray alloc]initWithCapacity:1];
        switch (i) {
            case 0:
                [itemsArray addObjectsFromArray:PeriodData];
                break;
            case 1:
                [itemsArray addObjectsFromArray:BuildingData];
                break;
            case 2:
                [itemsArray addObjectsFromArray:UnitData];
                break;
            case 3:
                [itemsArray addObjectsFromArray:HouseholdsData];
                break;
            case 4:
                [itemsArray addObjectsFromArray:PeriodData];
                break;
                
            default:
                break;
        }
        
        comBox.titlesList = itemsArray;
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

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark UITextField delegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [m_Nickname resignFirstResponder];
    return YES;
}

//开始编辑输入框
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==m_Nickname) {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y -=50;
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
    if (textField==m_Nickname)
    {
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y +=50;
        //frame.size.height -=60;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (IBAction)done:(id)sender {
    
    NSLog(@"完成");
//    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
//    NSLog(@"plistDic = %@",plistDic);
//    NSString *URl = [plistDic objectForKey: @"URL"];
//    NSError *error;
//    NSString *urlstr;
////    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/reg_community/user_id=%@&community_id=%@&nick_name=%@&head=%@&l1=%@&l2=%@&l3=%@&l4=%@&l5=%@",URl,,[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"],,];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
//    //    将请求的url数据放到NSData对象中
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//    NSDictionary *getcodeDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    NSLog(@"%@",getcodeDic);
}

@end
