//
//  LYCommonSettings.m
//  incommunit
//  通用设置界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYCommonSettings.h"

@interface LYCommonSettings ()
@end
@implementation LYCommonSettings

@synthesize m_tableView;

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
    
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
}

- (IBAction)soundSwitch:(id)sender {
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"是");
    }else {
        NSLog(@"否");
    }
}

- (IBAction)ShockSwitch:(id)sender {
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"是");
    }else {
        NSLog(@"否");
    }
}

#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        
        return 1;
    }else if (section == 2) {
        
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (indexPath.section == 0) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"titlecellIdentefier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 1) {
        
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"soundcellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2) {
        
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"shockcellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        
        return nil;
    }
    
}
@end
