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
#import "StoreOnlineNetworkEngine.h"
#define CAMERA @"相机"
#define PHOTOES @"相册"
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
    l1str=@"";
    l2str=@"";
    l3str=@"";
    l4str=@"";
    l5str=@"";
    PeriodData = [[NSMutableArray alloc] init];
    [m_Nickname setShowBorderLine:NO];
    [m_Nickname setTextInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    [m_button.layer setMasksToBounds:YES];
    [m_button.layer setCornerRadius:3.0];
    m_communitid = [[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"];
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
    self.navigationController.navigationBar.hidden = NO;
    BuildingData = [[NSMutableArray alloc] init];
    UnitData =  [[NSMutableArray alloc] init];
    HouseholdsData = [[NSMutableArray alloc] init];
    HomeNumber = [[NSMutableArray alloc] init];
    
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(m_lableinfo.frame), self.view.frame.size.width, 44)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    [self setUpBgScrollView];
    
    CGFloat y = CGRectGetMaxY(bgScrollView.frame);
    CGRect rect = self.m_button.frame;
    rect.origin.y = y + 94;
    self.m_button.frame = rect;
    
    m_iamgeview.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
    [m_iamgeview addGestureRecognizer:singleTap];
}


- (void)imageViewTap:(UITapGestureRecognizer *) tap {
    
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
            m_iamgeview.image = image;
            
        }
    }];
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
                [self done:m_communitid pid:@"0" ComBoxView:comBox];
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
            if(tempdata1.count>0)
            {
                l1str = [[tempdata1 objectAtIndex:index] objectForKey:@"id"];
                BuildingData = [[NSMutableArray alloc] init];
                LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
                [self done:m_communitid pid:@"1" ComBoxView:cityCombox];
            }
        }
            break;
        case 1:
        {
            if (tempdata2.count>0)
            {
                UnitData = [[NSMutableArray alloc] init];
                l2str = [[tempdata2 objectAtIndex:index] objectForKey:@"id"];
                LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
                [self done:m_communitid pid:@"2"ComBoxView:cityCombox];
            }
        }
            break;
        case 2:
        {
            if (tempdata3.count>0)
            {
                HouseholdsData = [[NSMutableArray alloc] init];
                l3str = [[tempdata3 objectAtIndex:index] objectForKey:@"id"];
                LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
                [self done:m_communitid pid:@"3" ComBoxView:cityCombox];
            }
        }
            break;
        case 3:
        {
            if (tempdata4.count>0)
            {
                HomeNumber = [[NSMutableArray alloc] init];
                l4str = [[tempdata4 objectAtIndex:index] objectForKey:@"id"];
                LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
                [self done:m_communitid pid:@"4" ComBoxView:cityCombox];
            }
        }
            break;
        case 4:
        {
            if(tempdata5.count>0)
            {
                l5str = [[tempdata5 objectAtIndex:index] objectForKey:@"id"];
            }
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

- (void)done:(NSString *)COMMUNITY_ID pid:(NSString *)PID ComBoxView:(LMComBoxView *)BoxView
{
    NSDictionary *dic = @{ @"community_id" : COMMUNITY_ID
                           ,@"pid" : PID
                           };
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/community/level"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                               [al show];
                                                               
                                                           }else
                                                           {
                                                               if ([PID isEqual:@"0"]) {
                                                                   tempdata1 = result;
                                                                   if (tempdata1.count>0) {
                                                                       for (int i = 0; i<tempdata1.count; i++)
                                                                       {
                                                                           [PeriodData addObject:[[tempdata1 objectAtIndex:i] objectForKey:@"name"]];

                                                                       }
                                                                       BoxView.titlesList = PeriodData;
                                                                       [BoxView reloadData];
                                                                   }
                                                               }else if ([PID isEqual:@"1"])
                                                               {
                                                                   tempdata2 = result;
                                                                   for (int i = 0; i<tempdata2.count; i++) {
                                                                       [BuildingData addObject:[[tempdata2 objectAtIndex:i] objectForKey:@"name"]];
                                                                   }
                                                                   BoxView.titlesList = BuildingData;
                                                                   [BoxView reloadData];
                                                               }else if([PID isEqual:@"2"])
                                                               {
                                                                    tempdata3 = result;
                                                                   for (int i = 0; i<tempdata3.count; i++)
                                                                   {
                                                                       [UnitData addObject:[[tempdata3 objectAtIndex:i] objectForKey:@"name"]];

                                                                   }
                                                                   BoxView.titlesList = UnitData;
                                                                   [BoxView reloadData];
                                                               }else if([PID isEqual:@"3"])
                                                               {

                                                                   tempdata4 = result;
                                                                   for (int i = 0; i<tempdata4.count; i++)
                                                                   {
                                                                       [HouseholdsData addObject:[[tempdata4 objectAtIndex:i] objectForKey:@"name"]];
                                                                    }
                                                                   BoxView.titlesList = HouseholdsData;
                                                                   [BoxView reloadData];
                                                               }else if([PID isEqual:@"4"])
                                                               {
                                                                   tempdata5 = result;
                                                                   for (int i = 0; i<tempdata5.count; i++)
                                                                   {
                                                                       [HomeNumber addObject:[[tempdata5 objectAtIndex:i] objectForKey:@"name"]];
                                                                   }
                                                                   BoxView.titlesList = HomeNumber;
                                                                   [BoxView reloadData];
                                                               }
                                                           }
                                               }];
}
-(NSString *)CovertImage:(UIImage *)iamge
{
    NSData *_data = UIImageJPEGRepresentation(iamge, 1.0f);
    NSString *_encodedImageStr = [_data base64Encoding];
    return _encodedImageStr;
}
//完成
-(void)Submitinfo
{
    
    NSDictionary *dic = @{ @"user_id" : userID
                          ,@"community_id" : m_communitid
                          ,@"nick_name" : m_Nickname.text
                          ,@"head" : [self CovertImage:headimage]
                          ,@"l1" : l1str
                          ,@"l2" : l2str
                          ,@"l3" :l3str
                          ,@"l4" :l4str
                          ,@"l5" :l5str
                          };
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/reg_community"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:NO
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                               [al show];
                                                               [self performSegueWithIdentifier:@"GoFunction" sender:self];
                                                               
                                                           }else
                                                           {
                                                               UIAlertView *al =[[UIAlertView alloc]initWithTitle:@"提示" message:@"成功加入该小区" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                               [al show];
                                                               [self performSegueWithIdentifier:@"GoFunction" sender:self];
                                                           }
                                                       }];
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
