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
    NSMutableArray *PeriodData;
    NSMutableArray *BuildingData;
    NSMutableArray *UnitData;
    NSMutableArray *HouseholdsData;
    NSMutableArray *HomeNumber;
    NSMutableArray *allPeriodData;
    NSString *l1str;
    NSString *l2str;
    NSString *l3str;
    NSString *l4str;
    NSString *l5str;
    UIActionSheet *sheet;
    UIImage *headimage;
}
@end
@implementation LYaddCommunit
@synthesize  m_lableinfo,m_Nickname,m_iamgeview,m_button;
- (void)viewDidLoad
{
    [super viewDidLoad];
    PeriodData = [[NSMutableArray alloc] init];
    [m_Nickname setShowBorderLine:NO];
    [m_Nickname setTextInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    [m_button.layer setMasksToBounds:YES];
    [m_button.layer setCornerRadius:3.0];
    m_communitid = [[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"];
    m_Nickname.delegate = self;
    allPeriodData = [self done:m_communitid pid:@"0"];
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
    BuildingData = [[NSMutableArray alloc] init];
    UnitData =  [[NSMutableArray alloc] init];
    HouseholdsData = [[NSMutableArray alloc] init];
    HomeNumber = [[NSMutableArray alloc] init];
    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(m_lableinfo.frame), self.view.frame.size.width, 35)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    [self setUpBgScrollView];
    
    m_iamgeview.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Photograph)];
    [m_iamgeview addGestureRecognizer:singleTap];

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
-(void)shootPiicturePrVideo
{
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
        headimage = chosenImage;
    }
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
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
                comBox.titlesList = itemsArray;
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

-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    
    NSInteger tag = _combox.tag - kDropDownListTag;
    switch (tag) {
        case 0:
        {
            l1str = [[allPeriodData objectAtIndex:index] objectForKey:@"id"];
            BuildingData = [[NSMutableArray alloc] init];
            temp = [self done:m_communitid pid:@"1"];
            if (temp.count>0) {
                for (int i = 0; i<temp.count; i++)
                {
                    [BuildingData addObject:[[temp objectAtIndex:i] objectForKey:@"name"]];
                }
                LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
                cityCombox.titlesList = BuildingData;
                [cityCombox reloadData];
            }
            
        }
            break;
        case 1:
        {
            UnitData = [[NSMutableArray alloc] init];
            l2str = [[temp objectAtIndex:index] objectForKey:@"id"];
            temp = [[NSMutableArray alloc] init];
            temp = [self done:m_communitid pid:@"2"];
            if (temp.count>0) {
                for (int i = 0; i<temp.count; i++) {
                    [UnitData addObject:[[temp objectAtIndex:i] objectForKey:@"name"]];
                }
                LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
                cityCombox.titlesList = UnitData;
                [cityCombox reloadData];
            }
        }
            break;
        case 2:
        {
            HouseholdsData = [[NSMutableArray alloc] init];
            l3str = [[temp objectAtIndex:index] objectForKey:@"id"];
            temp = [[NSMutableArray alloc] init];
            temp = [self done:m_communitid pid:@"3"];
            if (temp.count>0) {
                for (int i = 0; i<temp.count; i++)
                {
                    [HouseholdsData addObject:[[temp objectAtIndex:i] objectForKey:@"name"]];
                }
                LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
                cityCombox.titlesList = HouseholdsData;
                [cityCombox reloadData];
            }
        }
            break;
        case 3:
        {
            HomeNumber = [[NSMutableArray alloc] init];
            if(temp.count>0)
            {
                l4str = [[temp objectAtIndex:index] objectForKey:@"id"];
            }
            temp = [[NSMutableArray alloc] init];
            temp = [self done:m_communitid pid:@"4"];
            if (temp.count>0) {
                for (int i = 0; i<temp.count; i++)
                {
                    [HomeNumber addObject:[[temp objectAtIndex:i] objectForKey:@"name"]];
                }
                LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
                cityCombox.titlesList = HomeNumber;
                [cityCombox reloadData];
            }
        }
            break;
        case 4:
        {
            l5str = [[temp objectAtIndex:index] objectForKey:@"id"];
        }
            break;
        default:
            break;
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL ret = YES;
    if (textField == m_Nickname && range.length == 0) {
        if (m_Nickname.text.length >= 30)
            ret = NO;
    }
    return ret;
    
}

- (NSMutableArray *)done:(NSString *)COMMUNITY_ID pid:(NSString *)PID
{
    NSLog(@"完成");
    NSMutableArray * temp1;
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString * URl = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/community/level?community_id=%@&pid=%@",URl,COMMUNITY_ID,PID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (response!=nil)
    {
        NSDictionary *getcodeDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",getcodeDic);
        NSString *message = [getcodeDic objectForKey:@"message"];
        if (![[getcodeDic objectForKey:@"status"] isEqual:@"200"])
        {
            NSLog(@"%@",message);
        }else
        {
            temp1 = [getcodeDic objectForKey:@"data"];
            for (int i = 0; i<temp1.count; i++)
            {
                [PeriodData addObject:[[temp1 objectAtIndex:i] objectForKey:@"name"]];
            }
        }
    }
    return temp1;
}
-(NSString *)CovertImage:(UIImage *)iamge
{
    NSData *_data = UIImageJPEGRepresentation(iamge, 1.0f);
    NSString *_encodedImageStr = [_data base64Encoding];
    return _encodedImageStr;
}
//完成
-(BOOL)Submitinfo
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *urlstr = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString    *URLString = [NSString stringWithFormat:@"%@/services/reg_community",urlstr];
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"user_id=";//设置参数
    str = [str stringByAppendingFormat:@"%@&community_id=%@&nick_name=%@&head=%@&l1=%@&l2=%@&l3=%@&l4=%@&l5=%@",userID,[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"],m_Nickname.text,[self CovertImage:headimage],l1str,l2str,l3str,l4str,l5str];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
    if ([[weatherDic objectForKey:@"status"] isEqualToString:@"200"])
    {
        UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:@"成功加入该小区" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
        return YES;
    }else
    {
        return NO;
    }
}

-(IBAction)Carryout:(id)sender
{
    if(![m_Nickname.text isEqual:@""])
    {
        [self Submitinfo];
    }else
    {
        UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alview show];
    }
}
@end
