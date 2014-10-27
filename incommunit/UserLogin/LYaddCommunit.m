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
#define kDropDownListTag 1000
@interface LYaddCommunit ()
{
    LMContainsLMComboxScrollView *bgScrollView;
    NSArray *PeriodData;
    NSArray *BuildingData;
    NSArray *UnitData;
    NSArray *HouseholdsData;
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedArea;
}

@end
@implementation LYaddCommunit
@synthesize  m_lableinfo,m_Nickname,m_iamgeview,m_button;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [m_button.layer setMasksToBounds:YES];
    [m_button.layer setCornerRadius:3.0];

    CALayer *lay  = m_iamgeview.layer;//获取ImageView的层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:50.0];
    
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
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, m_lableinfo.frame.origin.y+m_lableinfo.frame.size.height, self.view.frame.size.width, 35)];
    bgScrollView.backgroundColor = [UIColor clearColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:bgScrollView];
    [self setUpBgScrollView];
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickView)];
    singleRecognizer.numberOfTapsRequired = 2; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
    
    // Do any additional setup after loading the view.
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
    for(NSInteger i=0;i<5;i++)
    {
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(m_lableinfo.frame.origin.x+(m_lableinfo.frame.size.width/5+1)*i, 0, m_lableinfo.frame.size.width/5-1, 35)];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

@end
