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
#import "StoreOnlineNetworkEngine.h"
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
    m_Administrative = [[NSMutableArray alloc] init];
    m_PersonalNumber = [[NSMutableArray alloc] init];
    self.m_tabeView.delegate = self;
    self.m_tabeView.dataSource = self;
    [self getNumbersense];
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
    NSInteger numberOfRowsInSection ;
    if(section == 0)
    {
        numberOfRowsInSection =m_Administrative.count;
    }else if (section == 1)
    {
        numberOfRowsInSection = m_PersonalNumber.count;
    }
    return numberOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     LYNumbersenseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"administrativeCell" forIndexPath:indexPath];
    if(indexPath.section == 0)
    {
        [cell setName:[[m_Administrative objectAtIndex:indexPath.row] objectForKey:@"name"]];
        [cell setCallNumber:[[[m_Administrative objectAtIndex:indexPath.row] objectForKey:@"call_number"] intValue]];
    }else if (indexPath.section == 1)
    {
   
        [cell setName:[[m_PersonalNumber objectAtIndex:indexPath.row] objectForKey:@"name"]];
        [cell setCallNumber:[[[m_PersonalNumber objectAtIndex:indexPath.row] objectForKey:@"call_number"] intValue]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"NumberSenceHeaderView" owner:self options:nil];
    NumberSenceHeaderView *view = nibViews.lastObject;
    if(section == 0)
    {
        [view setName:@"行政"];
    }else
    {
        [view setName:@"个人"];
    }
    return view;
}

#pragma mark 网络请求数据
- (void)getNumbersense
{
    NSDictionary *dic = @{@"community_id" : [[LYSqllite currentCommnit] objectForKey:@"community_id"]};
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/community/contact_list"
                                                            params:dic
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if(!bValidJSON)
                                                           {
                                                               UIAlertView * mslaView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:errorMsg cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                               [mslaView show];
                                                           }else
                                                           {
                                                               Numberlist =result;
                                                               for (int i = 0; i<Numberlist.count; i++) {
                                                                   NSDictionary * temp = [Numberlist objectAtIndex:i];
                                                                   if ([[temp objectForKey:@"type"]isEqualToString:@"行政"])
                                                                   {
                                                                       [m_Administrative addObject:temp];
                                                                   }else if([[temp objectForKey:@"type"]isEqualToString:@"个人"])
                                                                   {
                                                                       [m_PersonalNumber addObject:temp];
                                                                   }
                                                               }
                                                               [self.m_tabeView reloadData];
                                                           }}];
}

@end
