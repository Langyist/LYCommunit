//
//  LYMyCommunit.m
//  incommunit
//  我的小区界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#import "LYMyCommunit.h"
#import "LYSelectCommunit.h"
@interface LYMyCommunit ()
{
    UILabel *redLabel;
    UILabel *greenLabel;
    UIView *redView;
    UIView *greenView;
    NSInteger redheight;
    NSInteger greenheight;
    NSDictionary *dataDic;
    NSDictionary *imageDic;
}
@end

@implementation LYMyCommunit
@synthesize m_view;
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
    [_m_button.layer setMasksToBounds:YES];
    [_m_button.layer setCornerRadius:3.0];
    [NSThread detachNewThreadSelector:@selector(Getdata:) toTarget:self withObject:nil];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0]];
    [customLab setText:@"我的小区"];
    customLab.font = [UIFont boldSystemFontOfSize:17];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0];
    
}

-(IBAction)GoMycommunit:(id)sender
{
    [self performSegueWithIdentifier:@"Goselectcommunit" sender:self];
}
//获取网络数据
-(void)Getdata:(NSString *)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *url = [plistDic objectForKey: @"URL"];
    NSError *error;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"%@/services/community/index?id=%@",url,[[LYSelectCommunit GetCommunityInfo] objectForKey:@"id"]];
    //    加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    if (request!=nil)
    {
        //    将请求的url数据放到NSData对象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if(response!=nil)
        {
            //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
            NSString *status = [weatherDic objectForKey:@"status"];
            NSLog(@"%@",status);
            dataDic = [[weatherDic objectForKey:@"data"] objectForKey:@"community"];
            NSLog(@"%@",dataDic);
            imageDic = [dataDic objectForKey:@"images"];
            NSLog(@"%@",imageDic);
        }
    }else
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载网络数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updata];
        // 更新UI
    });
}
#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"Goselectcommunit"])
    {
        LYSelectCommunit *detailViewController = (LYSelectCommunit*) segue.destinationViewController;
        detailViewController->m_bl = TRUE;
}}

-(void)updata
{
    self.communitNameLabel.text = [dataDic objectForKey:@"name"];
    self.PercentLabel.text = [NSString stringWithFormat:@"您的小区优于成都%@%%的小区",[dataDic objectForKey:@"rank"]];
    
    redheight = [[[NSString alloc ]initWithFormat:@"%@",[dataDic objectForKey:@"wuye_index"]] integerValue];
    
    if ([[[NSString alloc] initWithFormat:@"%@",[dataDic objectForKey:@"wuye_index"]] integerValue] >= 100) {
        redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height)];
        redView.backgroundColor = [UIColor redColor];
        [self.backView addSubview:redView];
    }else {
        redView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.frame.size.height - self.backView.frame.size.height / 100 * redheight, self.backView.frame.size.width, self.backView.frame.size.height / 100 *redheight)];
        redView.backgroundColor = [UIColor redColor];
        [self.backView addSubview:redView];
    }
    
    greenheight = [[[NSString alloc ]initWithFormat:@"%@",[dataDic objectForKey:@"live_index"]] integerValue];
    
    if ([[[NSString alloc ]initWithFormat:@"%@",[dataDic objectForKey:@"live_index"]] integerValue] >=100) {
        greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backView1.frame.size.width, self.backView1.frame.size.height)];
        greenView.backgroundColor = [UIColor greenColor];
        [self.backView1 addSubview:greenView];
    }else {
        
        greenView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView1.frame.size.height - self.backView1.frame.size.height / 100 *greenheight, self.backView1.frame.size.width, self.backView1.frame.size.height / 100 *greenheight)];
        greenView.backgroundColor = [UIColor greenColor];
        [self.backView1 addSubview:greenView];
    }
    
    UILabel * redlable = [[UILabel alloc] initWithFrame:CGRectMake(20, self.backView.frame.size.height/3, 30, 30)];
    redlable.text = [[NSString alloc ]initWithFormat:@"%@",[dataDic objectForKey:@"wuye_index"]];
    redlable.textColor = [UIColor whiteColor];
    redlable.font = [UIFont systemFontOfSize:15];
    [self.backView addSubview:redlable];
    
    UILabel * grlable = [[UILabel alloc] initWithFrame:CGRectMake(20, self.backView1.frame.size.height/3, 30, 30)];
    grlable.text = [[NSString alloc ]initWithFormat:@"%@",[dataDic objectForKey:@"live_index"]];
    grlable.textColor = [UIColor whiteColor];
    grlable.font = [UIFont systemFontOfSize:15];
    [self.backView1 addSubview:grlable];
}
@end
