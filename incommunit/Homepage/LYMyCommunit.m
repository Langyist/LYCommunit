//
//  LYMyCommunit.m
//  incommunit
//  我的小区界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#import "LYMyCommunit.h"
#import "LYSelectCommunit.h"
#import "LYSqllite.h"
#import "AppDelegate.h"

@interface MyCommunitCell : UITableViewCell
@end

@implementation MyCommunitCell

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    CGFloat linewidth = 0.5f;
    CGContextSetLineWidth(context, linewidth);
    
    CGContextMoveToPoint(context, 0, 0); //start at this point
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), 0); //draw to this point
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect) + linewidth); //start at this point
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect) + linewidth);
    
    CGContextStrokePath(context);
}

@end

@interface MyCommunitBkView : UIView
@end

@implementation MyCommunitBkView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    CGFloat linewidth = 0.2f;
    CGContextSetLineWidth(context, linewidth);
    
    CGFloat x = 0;
    CGFloat ex = CGRectGetWidth(rect) - x;
    CGFloat y = 48 - linewidth;
    CGFloat move = 48;
    CGContextMoveToPoint(context, x, y); //start at this point
    CGContextAddLineToPoint(context, ex, y); //draw to this point
    y += move;
    CGContextMoveToPoint(context, x, y); //start at this point
    CGContextAddLineToPoint(context, ex, y); //draw to this point
    
    CGContextMoveToPoint(context, x, CGRectGetHeight(rect) - linewidth); //start at this point
    CGContextAddLineToPoint(context, ex, CGRectGetHeight(rect) - linewidth); //
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end

@interface MyCommunitSepView : UIView
@end

@implementation MyCommunitSepView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    CGFloat linewidth = 0.2f;
    CGContextSetLineWidth(context, linewidth);
    
    CGFloat x = 0;
    CGFloat ex = CGRectGetWidth(rect) - x;
    
    CGContextMoveToPoint(context, x, 0); //start at this point
    CGContextAddLineToPoint(context, ex, 0); //
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end

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
    [NSThread detachNewThreadSelector:@selector(Getdata:) toTarget:self withObject:nil];
    [super viewDidLoad];
    [self.selectButton.layer setMasksToBounds:YES];
    [self.selectButton.layer setCornerRadius:3.0];
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
        // 将请求的url数据放到NSData对象中
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
        [self.tableView reloadData];
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
        redView.backgroundColor = SPECIAL_RED;
        [self.backView addSubview:redView];
    }else {
        redView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.frame.size.height - self.backView.frame.size.height / 100 * redheight, self.backView.frame.size.width, self.backView.frame.size.height / 100 *redheight)];
        redView.backgroundColor = SPECIAL_RED;
        [self.backView addSubview:redView];
    }
    
    greenheight = [[[NSString alloc ]initWithFormat:@"%@",[dataDic objectForKey:@"live_index"]] integerValue];
    
    if ([[[NSString alloc ]initWithFormat:@"%@",[dataDic objectForKey:@"live_index"]] integerValue] >=100) {
        greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backView1.frame.size.width, self.backView1.frame.size.height)];
        greenView.backgroundColor = SPECIAL_GREEN;
        [self.backView1 addSubview:greenView];
    }else {
        
        greenView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView1.frame.size.height - self.backView1.frame.size.height / 100 *greenheight, self.backView1.frame.size.width, self.backView1.frame.size.height / 100 *greenheight)];
        greenView.backgroundColor = SPECIAL_GREEN;
        [self.backView1 addSubview:greenView];
    }
    
    UILabel * redlable = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.backView.frame.size.height - 30) / 2, CGRectGetWidth(self.backView.frame), 30)];
    redlable.text = [[NSString alloc ]initWithFormat:@"%@",[dataDic objectForKey:@"wuye_index"]];
    redlable.textColor = [UIColor whiteColor];
    redlable.textAlignment = NSTextAlignmentCenter;
    redlable.font = [UIFont systemFontOfSize:15];
    [self.backView addSubview:redlable];
    
    UILabel * grlable = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.backView1.frame.size.height - 30) / 2, CGRectGetWidth(self.backView.frame), 30)];
    grlable.text = [[NSString alloc ]initWithFormat:@"%@",[dataDic objectForKey:@"live_index"]];
    grlable.textColor = [UIColor whiteColor];
    grlable.textAlignment = NSTextAlignmentCenter;
    grlable.font = [UIFont systemFontOfSize:15];
    [self.backView1 addSubview:grlable];
}

- (IBAction)deleteRecord:(id)sender {
    [LYSqllite deletetable];
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
        return [LYSqllite allSuerinfo:[dataDic objectForKey:@"name"]].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCommunitCell *cell = (MyCommunitCell *)[tableView dequeueReusableCellWithIdentifier:@"communitycell" forIndexPath:indexPath];
    UILabel *name = (UILabel *)[cell viewWithTag:101];
    [name setText:@"温馨"];
    return cell;
    
    NSMutableDictionary * temp = [[LYSqllite allSuerinfo:[dataDic objectForKey:@"name"]] objectAtIndex:indexPath.row];
    [name setText:[temp objectForKey:@"name"]];
    return cell;
}
-(void)viewDidAppear:(BOOL)animated
{

}
@end
