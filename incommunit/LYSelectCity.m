//
//  LY_SelectCity.m
//  in_community
//
//  Created by wangliang on 14-9-10.
//  Copyright (c) 2014年 wangliang. All rights reserved.
//

#import "LYSelectCity.h"
#import "LYSelectCommunit.h"
@interface LYSelectCity ()
@end
static NSDictionary  *m_selectCityInfo;
@implementation LYSelectCity
@synthesize m_tableview,m_tablecell,m_lable;
#pragma mark - 初始话函数
- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [customLab setTextColor:[UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0]];
    [customLab setText:@"选择城市"];
    customLab.font = [UIFont boldSystemFontOfSize:17];
    customLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = customLab;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(238.0/255) green:(183.0/255) blue:(88.0/255) alpha:1.0];
    self.navigationController.navigationBar.tintColor= [UIColor colorWithRed:(0.0/255) green:(0.0/255) blue:(0.0/255) alpha:1.0];
    [self Getdata:@""];
    self.navigationItem.rightBarButtonItem.title = @"返回";
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString: @"GoLYSelectCommunit"])
//    {
//        LYSelectCommunit *detailViewController = (LYSelectCommunit*) segue.destinationViewController;
//        detailViewController->m_cityinfo = m_selectCityInfo;
//        detailViewController->m_Refresh = TRUE;
//    }
}

#pragma mark - Table view data source 协议函数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 28;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return m_hotCities.count;
            break;
        case 2:
            return m_Acities.count;
            break;
        case 3:
            return m_Bcities.count;
            break;
        case 4:
            return m_Ccities.count;
            break;
        case 5:
            return m_Dcities.count;
            break;
        case 6:
            return m_Ecities.count;
            break;
        case 7:
            return m_Fcities.count;
            break;
        case 8:
            return m_Gcities.count;
            break;
        case 9:
            return m_Hcities.count;
            break;
        case 10:
            return m_Icities.count;
            break;
        case 11:
            return m_Jcities.count;
            break;
        case 12:
            return m_Kcities.count;
            break;
        case 13:
            return m_Lcities.count;
            break;
        case 14:
            return m_Mcities.count;
            break;
        case 15:
            return m_Ncities.count;
            break;
        case 16:
            return m_Ocities.count;
            break;
        case 17:
            return m_Pcities.count;
            break;
        case 18:
            return m_Qcities.count;
            break;
        case 19:
            return m_Rcities.count;
            break;
        case 20:
            return m_Scities.count;
            break;
        case 21:
            return m_Tcities.count;
            break;
        case 22:
            return m_Ucities.count;
            break;
        case 23:
            return m_Vcities.count;
            break;
        case 24:
            return m_Wcities.count;
            break;
        case 25:
            return m_Xcities.count;
            break;
        case 26:
            return m_Ycities.count;
            break;
        case 27:
            return m_Zcities.count;
            break;
        default:
            return 0;
            break;
    }
    // Return the number of rows in the section.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *city;
    switch (indexPath.section) {
            
        case 0:
        {
            city=[m_hotCities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            m_lable.text =@"成都";
            return m_tablecell;
        }
        case 1:
        {
            city=[m_hotCities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
            break;
        case 2:
        {
            city=[m_Acities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
            
        }
            break;
        case 3:
        {
            city=[m_Bcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
            
        case 4:
        {
            city=[m_Ccities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 5:
        {
            city=[m_Dcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 6:
        {
            city=[m_Ecities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 7:
        {
            city=[m_Fcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 8:
        {
            city=[m_Gcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 9:
        {
            city=[m_Hcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 10:
        {
            city=[m_Icities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 11:
        {
            city=[m_Jcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 12:
        {
            city=[m_Kcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 13:
        {
            city=[m_Lcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 14:
        {
            city=[m_Mcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 15:
        {
            city=[m_Ncities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 16:
        {
            city=[m_Ocities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 17:
        {
            city=[m_Pcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 18:
        {
            city=[m_Qcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 19:
        {
            city=[m_Rcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 20:
        {
            city=[m_Scities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 21:
        {
            city=[m_Tcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }case 22:
        {
            city=[m_Ucities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 23:
        {
            city=[m_Vcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 24:
        {
            city=[m_Wcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }case 25:
        {
            city=[m_Xcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 26:
        {
            city=[m_Ycities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        case 27:
        {
            city=[m_Zcities objectAtIndex:indexPath.row];
            m_lable = [[UILabel alloc] init];
            m_tablecell = [[UITableViewCell alloc] init] ;
            m_tablecell = [tableView dequeueReusableCellWithIdentifier:@"City_cell"];
            m_lable = (UILabel *)[m_tablecell viewWithTag:100];
            NSLog(@"%@",[city objectForKey:@"name"]);
            m_lable.text =[city objectForKey:@"name"];
            return m_tablecell;
        }
        default:
            return m_tablecell;
            break;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 28.0f)];
    customView.backgroundColor = [UIColor colorWithRed:(233/255.0) green:(232/255.0) blue:(232/255.0) alpha:1.0];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithRed:(65/255.0) green:(65/255.0) blue:(64/255.0) alpha:1.0];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:13];
    headerLabel.frame = CGRectMake(17.0f, 0, self.view.frame.size.width, 28.0f);
    
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1.0f)];
    sepView.backgroundColor = [UIColor colorWithRed:(212/255.0) green:(207/255.0) blue:(207/255.0) alpha:1.0];
    [customView addSubview:sepView];
    sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 27, self.view.frame.size.width, 1.0f)];
    sepView.backgroundColor = [UIColor colorWithRed:(212/255.0) green:(207/255.0) blue:(207/255.0) alpha:1.0];
    [customView addSubview:sepView];
    
    switch (section) {
        case 0:
            headerLabel.text = @"GPS定位城市";
            [customView addSubview:headerLabel];
            return customView;
            break;
        case 1:
            headerLabel.text = @"热门城市";
            [customView addSubview:headerLabel];
            return customView;
            break;
        case 2:
            if ([m_Acities count]>0)
            {
                headerLabel.text = @"A";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 3:
            if ([m_Bcities count]>0)
            {
                headerLabel.text = @"B";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 4:
            if ([m_Ccities count]>0)
            {
                headerLabel.text = @"C";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
            
        case 5:
            if ([m_Dcities count]>0)
            {
                headerLabel.text = @"D";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 6:
            if ([m_Ecities count]>0)
            {
                headerLabel.text = @"E";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 7:
            if ([m_Fcities count]>0)
            {
                headerLabel.text = @"F";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 8:
            if ([m_Gcities count]>0)
            {
                headerLabel.text = @"G";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 9:
            if ([m_Hcities count]>0)
            {
                headerLabel.text = @"H";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 10:
            if ([m_Icities count]>0)
            {
                headerLabel.text = @"I";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 11:
            if ([m_Jcities count]>0)
            {
                headerLabel.text = @"J";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 12:
            if ([m_Kcities count]>0)
            {
                headerLabel.text = @"K";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 13:
            if ([m_Lcities count]>0)
            {
                headerLabel.text = @"L";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 14:
            if ([m_Mcities count]>0)
            {
                headerLabel.text = @"M";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 15:
            if ([m_Ncities count]>0)
            {
                headerLabel.text = @"N";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 16:
            if ([m_Ocities count]>0)
            {
                headerLabel.text = @"O";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 17:
            if ([m_Pcities count]>0)
            {
                headerLabel.text = @"P";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 18:
            if ([m_Qcities count]>0)
            {
                headerLabel.text = @"Q";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 19:
            if ([m_Rcities count]>0)
            {
                headerLabel.text = @"R";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 20:
            if ([m_Scities count]>0)
            {
                headerLabel.text = @"S";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 21:
            if ([m_Tcities count]>0)
            {
                headerLabel.text = @"T";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 22:
            if ([m_Ucities count]>0)
            {
                headerLabel.text = @"U";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 23:
            if ([m_Vcities count]>0)
            {
                headerLabel.text = @"V";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 24:
            if ([m_Wcities count]>0)
            {
                headerLabel.text = @"W";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 25:
            if ([m_Xcities count]>0)
            {
                headerLabel.text = @"X";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 26:
            if ([m_Ycities count]>0)
            {
                headerLabel.text = @"Y";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        case 27:
            if ([m_Zcities count]>0)
            {
                headerLabel.text = @"Z";
                [customView addSubview:headerLabel];
                return customView;
            }
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 28.0f;
}

-(void)Getdata:(NSString *)URL
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"plistDic = %@",plistDic);
    NSString *urlstr = [plistDic objectForKey: @"URL"];
    NSError *error;
    //    加载一个NSURL对象
    NSString *url = [[NSString alloc] initWithFormat:@"%@/services/city",urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //    将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(response==nil)
    {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有加载到数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }else
    {
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSString *status = [weatherDic objectForKey:@"status"];
    NSLog(@"%@",status);
    if(![status isEqual:@"200"])
    {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:status delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
    }else
    {
        NSDictionary *data = [weatherDic objectForKey:@"data"];
        m_hotCities =[data objectForKey:@"hotCities"];
        m_allcities = [data objectForKey:@"cities"];
        m_Acities = [[NSMutableArray alloc] init];
        m_Bcities = [[NSMutableArray alloc] init];
        m_Ccities = [[NSMutableArray alloc] init];
        m_Dcities = [[NSMutableArray alloc] init];
        m_Ecities = [[NSMutableArray alloc] init];
        m_Fcities = [[NSMutableArray alloc] init];
        m_Gcities = [[NSMutableArray alloc] init];
        m_Hcities = [[NSMutableArray alloc] init];
        m_Icities = [[NSMutableArray alloc] init];
        m_Jcities = [[NSMutableArray alloc] init];
        m_Kcities = [[NSMutableArray alloc] init];
        m_Lcities = [[NSMutableArray alloc] init];
        m_Mcities = [[NSMutableArray alloc] init];
        m_Ncities = [[NSMutableArray alloc] init];
        m_Ocities = [[NSMutableArray alloc] init];
        m_Pcities = [[NSMutableArray alloc] init];
        m_Qcities = [[NSMutableArray alloc] init];
        m_Rcities = [[NSMutableArray alloc] init];
        m_Scities = [[NSMutableArray alloc] init];
        m_Tcities = [[NSMutableArray alloc] init];
        m_Ucities = [[NSMutableArray alloc] init];
        m_Vcities = [[NSMutableArray alloc] init];
        m_Wcities = [[NSMutableArray alloc] init];
        m_Xcities = [[NSMutableArray alloc] init];
        m_Ycities = [[NSMutableArray alloc] init];
        m_Zcities = [[NSMutableArray alloc] init];
    for (int i= 0;i< [m_allcities count]; i++)
    {
        NSDictionary *temp = [m_allcities objectAtIndex:i];
        NSString *pinyin =[temp objectForKey:@"pinyin"];
        
        if([pinyin isEqualToString:@"A"])
        {
            [m_Acities addObject:temp];
        }else if ([pinyin isEqualToString:@"B"])
        {
            [m_Bcities addObject:temp];
        }else if ([pinyin isEqualToString:@"C"])
        {
            [m_Ccities addObject:temp];
        }else if ([pinyin isEqualToString:@"D"])
        {
            [m_Dcities addObject:temp];
        }else if ([pinyin isEqualToString:@"E"])
        {
            [m_Ecities addObject:temp];
        }else if ([pinyin isEqualToString:@"F"])
        {
            [m_Fcities addObject:temp];
        }else if ([pinyin isEqualToString:@"G"])
        {
            [m_Gcities addObject:temp];
        }else if ([pinyin isEqualToString:@"H"])
        {
            [m_Hcities addObject:temp];
        }else if ([pinyin isEqualToString:@"I"])
        {
            [m_Icities addObject:temp];
        }else if ([pinyin isEqualToString:@"J"])
        {
            [m_Jcities addObject:temp];
        }else if ([pinyin isEqualToString:@"K"])
        {
            [m_Kcities addObject:temp];
        }else if ([pinyin isEqualToString:@"L"])
        {
            [m_Lcities addObject:temp];
        }else if ([pinyin isEqualToString:@"M"])
        {
            [m_Mcities addObject:temp];
        }else if ([pinyin isEqualToString:@"N"])
        {
            [m_Ncities addObject:temp];
        }else if ([pinyin isEqualToString:@"O"])
        {
            [m_Ocities addObject:temp];
        }else if ([pinyin isEqualToString:@"P"])
        {
            [m_Pcities addObject:temp];
        }else if ([pinyin isEqualToString:@"Q"])
        {
            [m_Qcities addObject:temp];
        }else if ([pinyin isEqualToString:@"R"])
        {
            [m_Rcities addObject:temp];
        }else if ([pinyin isEqualToString:@"S"])
        {
            [m_Scities addObject:temp];
        }else if ([pinyin isEqualToString:@"T"])
        {
            [m_Tcities addObject:temp];
        }else if ([pinyin isEqualToString:@"U"])
        {
            [m_Ucities addObject:temp];
        }else if ([pinyin isEqualToString:@"V"])
        {
            [m_Vcities addObject:temp];
        }else if ([pinyin isEqualToString:@"W"])
        {
            [m_Wcities addObject:temp];
        }else if ([pinyin isEqualToString:@"X"])
        {
            [m_Xcities addObject:temp];
        }else if ([pinyin isEqualToString:@"Y"])
        {
            [m_Ycities addObject:temp];
        }else if ([pinyin isEqualToString:@"Z"])
        {
            [m_Zcities addObject:temp];
        }
    }
    [m_messageview removeFromSuperview];
    self.view.userInteractionEnabled = YES;
    }
    }
}

//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row%ld",(long)indexPath.row);
    NSLog(@"section%ld",(long)indexPath.section);
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1:
            m_selectCityInfo = [m_hotCities objectAtIndex:indexPath.row];
            break;
        case 2:
            m_selectCityInfo = [m_Acities objectAtIndex:indexPath.row];
            break;
        case 3:
            m_selectCityInfo = [m_Bcities objectAtIndex:indexPath.row];
            break;
        case 4:
            m_selectCityInfo = [m_Ccities objectAtIndex:indexPath.row];
            break;
        case 5:
            m_selectCityInfo = [m_Dcities objectAtIndex:indexPath.row];
            break;
        case 6:
            m_selectCityInfo = [m_Ecities objectAtIndex:indexPath.row];
            break;
        case 7:
            m_selectCityInfo = [m_Ecities objectAtIndex:indexPath.row];
            break;
        case 8:
            m_selectCityInfo = [m_Gcities objectAtIndex:indexPath.row];
            break;
        case 9:
            m_selectCityInfo = [m_Hcities objectAtIndex:indexPath.row];
            break;
        case 10:
            m_selectCityInfo = [m_Icities objectAtIndex:indexPath.row];
            break;
        case 11:
            m_selectCityInfo = [m_Jcities objectAtIndex:indexPath.row];
            break;
        case 12:
            m_selectCityInfo = [m_Kcities objectAtIndex:indexPath.row];
            break;
        case 13:
            m_selectCityInfo = [m_Lcities objectAtIndex:indexPath.row];
            break;
        case 14:
            m_selectCityInfo = [m_Mcities objectAtIndex:indexPath.row];
            break;
        case 15:
            m_selectCityInfo = [m_Ncities objectAtIndex:indexPath.row];
            break;
        case 16:
            m_selectCityInfo = [m_Ocities objectAtIndex:indexPath.row];
            break;
        case 17:
            m_selectCityInfo = [m_Pcities objectAtIndex:indexPath.row];
            break;
        case 18:
            m_selectCityInfo = [m_Qcities objectAtIndex:indexPath.row];
            break;
        case 19:
            m_selectCityInfo = [m_Rcities objectAtIndex:indexPath.row];
            break;
        case 20:
            m_selectCityInfo = [m_Scities objectAtIndex:indexPath.row];
            break;
        case 21:
            m_selectCityInfo = [m_Tcities objectAtIndex:indexPath.row];
            break;
        case 22:
            m_selectCityInfo = [m_Ucities objectAtIndex:indexPath.row];
            break;
        case 23:
            m_selectCityInfo = [m_Vcities objectAtIndex:indexPath.row];
            break;
        case 24:
            m_selectCityInfo = [m_Wcities objectAtIndex:indexPath.row];
            break;
        case 25:
            m_selectCityInfo = [m_Xcities objectAtIndex:indexPath.row];
            break;
        case 26:
            m_selectCityInfo = [m_Ycities objectAtIndex:indexPath.row];
            break;
        case 27:
            m_selectCityInfo = [m_Zcities objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    [LYSelectCommunit Updata:YES];
    [[self navigationController] popViewControllerAnimated:YES];
}
#pragma mark  - 返回选择的城市信息
+(NSDictionary*)CityInfo
{
    return m_selectCityInfo;
}
@end
