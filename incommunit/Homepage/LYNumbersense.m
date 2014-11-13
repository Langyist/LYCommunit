//
//  LYNumbersense.m
//  in_community
//  小区号码通
//  Created by LANGYI on 14-10-17.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYNumbersense.h"
#import "LYSelectCommunit.h"
#import "NumberSenceHeaderView.h"
#import "LYSqllite.h"
@interface LYNumbersenseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *callNumberLabel;

@end

@implementation LYNumbersenseCell

- (void)setName:(NSString *)name {
    [self.nameLabel setText:name];
}

- (void)setCallNumber:(NSInteger)number {
    NSString *numberString = [NSString stringWithFormat:@"%ld次拨打", (long)number];
    [self.callNumberLabel setText:numberString];
}

@end

@interface LYNumbersense ()

@end

@implementation LYNumbersense

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
    self.m_tabeView.delegate = self;
    self.m_tabeView.dataSource = self;
    [self getNumbersense:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRowsInSection = 2;
    return numberOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LYNumbersenseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"administrativeCell" forIndexPath:indexPath];
    [cell setName:@"xxx"];
    [cell setCallNumber:0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"NumberSenceHeaderView" owner:self options:nil];
    NumberSenceHeaderView *view = nibViews.lastObject;
    [view setName:@"xxx"];
    return view;
}

#pragma mark 网络请求数据
- (void)getNumbersense:(NSString *)url {
    
    NSError *error;
    NSString *urlstr = [[NSString alloc] initWithFormat:@"http://115.29.244.142/inCommunity/services/community/contact_list/community_id=%@",[[LYSqllite currentCommnit] objectForKey:@"id"]];
    //    加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"%@",weatherDic);
}

@end
