//
//  UserInfoTableViewController.m
//  UserInfo
//
//  Created by langyi on 14/10/24.
//  Copyright (c) 2014年 langyi. All rights reserved.
//

#import "UserInfoTableViewController.h"

@interface PersonalTagCell () {
    
}

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *deleteIcon;

@end

@implementation PersonalTagCell

@end


@interface UserInfoTableViewController () {
    NSArray *personalTagsList;
    NSArray *poposTagsList;
    
    NSString *userLogoPath;
}
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITableViewCell *gender;
@property (weak, nonatomic) IBOutlet UITextField *userSummary;
@property (weak, nonatomic) IBOutlet UICollectionView *personalTags;
@property (weak, nonatomic) IBOutlet UITextField *customTag;
@property (weak, nonatomic) IBOutlet UIButton *addTagButton;
@property (weak, nonatomic) IBOutlet UICollectionView *poposeTags;

- (IBAction)addCustomTagAction:(id)sender;

@end

@implementation UserInfoTableViewController

@synthesize userLogoPath = _userLogoPath;
@synthesize personalTagsList = _personalTagsList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    poposTagsList = [NSArray arrayWithObjects:@"麻将棋牌", @"运动", @"旅行", @"文艺青年", @"高富帅", @"家教", @"家政", @"贷款", @"医生", @"程序猿", @"金融", @"...", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRowAtIndexPath = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (indexPath.section == 2 && indexPath.row == 0) {
        CGFloat newHeight = [self calCollectionViewHeight:[personalTagsList count] collectionView:self.personalTags];
        if (newHeight) {
            heightForRowAtIndexPath = newHeight;
        }
    }
    else if (indexPath.section == 4 && indexPath.row ==0) {
        CGFloat newHeight = [self calCollectionViewHeight:[poposTagsList count] collectionView:self.poposeTags];
        if (newHeight) {
            heightForRowAtIndexPath = newHeight;
        }
    }
    return heightForRowAtIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        // TUDO: 选择性别
    }
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        CGRect newFrame = self.personalTags.frame;
        newFrame.size.height = cell.frame.size.height;
        self.personalTags.frame = newFrame;
        
        [self.personalTags reloadData];
    }
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItemsInSection = 0;
    if (collectionView == self.personalTags) {
        numberOfItemsInSection = [personalTagsList count];
    }
    else if (collectionView == self.poposeTags) {
        numberOfItemsInSection = [poposTagsList count];
    }
    return numberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *bkImageName = @"";
    BOOL hideDeleteIcon = YES;
    NSString *title = @"";
    NSString *iden = @"";
    if (collectionView == self.personalTags) {
        title = [personalTagsList objectAtIndex:indexPath.row];
        bkImageName = @"黄色_03";
        hideDeleteIcon = NO;
        iden = @"PersonalTagCell_1";
    }
    else if (collectionView == self.poposeTags) {
        title = [poposTagsList objectAtIndex:indexPath.row];
        bkImageName = @"蓝色_03";
        if ([personalTagsList containsObject:title]) {
            bkImageName = @"person_data_label_seleted";
        }
        hideDeleteIcon = YES;
        iden = @"PersonalTagCell";
    }
    
    PersonalTagCell *personalTagCell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    [personalTagCell.backgroundImage setImage:[UIImage imageNamed:bkImageName]];
    personalTagCell.deleteIcon.hidden = hideDeleteIcon;
    [personalTagCell.title setText:title];
    return personalTagCell;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.personalTags) {
        NSString *title = [[personalTagsList objectAtIndex:indexPath.row] copy];
        [self changePersonalTags:title addOrDelete:NO];
    }
    else if (collectionView == self.poposeTags) {
        NSString *title = [[poposTagsList objectAtIndex:indexPath.row] copy];
        if (indexPath.row == [poposTagsList count] - 1) {
            [self performSegueWithIdentifier:@"Tags" sender:nil];
        }
        else {
            [self changePersonalTags:title addOrDelete:YES];
        }
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark Methoad

- (CGFloat)calCollectionViewHeight:(NSInteger)itemCount collectionView:(UICollectionView *)collectionView {
    if (itemCount == 0) {
        return 0;
    }
    
    CGSize cellSize = CGSizeMake(60, 30);
    CGFloat tagCellHeight = cellSize.height;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    UIEdgeInsets sectionInset = layout.sectionInset;
    CGRect sectionRect = UIEdgeInsetsInsetRect(collectionView.frame, sectionInset);
    CGSize itemSize = layout.itemSize;
    NSInteger maxColnum = (sectionRect.size.width  + layout.minimumInteritemSpacing) / (itemSize.width + layout.minimumInteritemSpacing);
    maxColnum = MAX(maxColnum, 1);
    NSInteger macLine = itemCount / maxColnum + ((itemCount % maxColnum) ? 1 : 0);
    macLine = MAX(macLine, 1);
    tagCellHeight = macLine * itemSize.height + MAX(macLine - 1, 0) * layout.minimumLineSpacing;
    tagCellHeight += sectionInset.top + sectionInset.bottom;

    CGRect newFrame = collectionView.frame;
    newFrame.size.height = tagCellHeight;
    collectionView.frame = newFrame;
    
    return tagCellHeight;
}

#pragma mark -
#pragma mark IBAction

- (IBAction)addCustomTagAction:(id)sender {
    NSString *title = self.customTag.text;
    [self changePersonalTags:title addOrDelete:YES];
    self.customTag.text = @"";
}

- (void)changePersonalTags:(NSString *)title addOrDelete:(BOOL)add {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    if ([personalTagsList count]) {
        list = [NSMutableArray arrayWithArray:personalTagsList];
    }
    
    [self.customTag resignFirstResponder];
    if (add) {
        if (![list containsObject:title]) {
            [list addObject:title];
        }
    }
    else {
        [list removeObject:title];
    }
    personalTagsList = list;
//    [self.tableView beginUpdates];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView endUpdates];
    [self.tableView reloadData];
    
    if ([poposTagsList containsObject:title]) {
        NSInteger index = [poposTagsList indexOfObject:title];
        NSIndexPath *reloadPath = [NSIndexPath indexPathForItem:index inSection:0];
        [self.poposeTags reloadItemsAtIndexPaths:[NSArray arrayWithObjects:reloadPath, nil]];
    }
}

#pragma mark -
#pragma mark Method

- (NSString *)userLogoPath {
    return userLogoPath;
}

- (void)setUserNameString:(NSString *)anUserNameString {
    [self.userName setText:anUserNameString];
}

- (NSString *)userNameString {
    return self.userName.text;
}

- (void)setUserGenderString:(NSString *)anUserGenderString {
    [self.gender.textLabel setText:anUserGenderString];
}

- (NSString *)userGenderString {
    return self.gender.textLabel.text;
}

- (void)setUserSignString:(NSString *)userSignString {
    [self.userSummary setText:userSignString];
}

- (NSString *)userSignString {
    return self.userSummary.text;
}

- (void)setAddressList:(NSArray *)anAddressList {
    NSInteger baseTag = 100;
    for (NSString *address in anAddressList) {
        if (baseTag < 105) {
            UIButton *button = (UIButton *)[self.view viewWithTag:baseTag];
            [button setTitle:address forState:UIControlStateNormal];
            baseTag += 1;
        }
        else {
            break;
        }
    }
    
}

- (NSArray *)addressList {
    
    NSMutableArray *newAddressList = [[NSMutableArray alloc] init];
    
    for (NSInteger baseTag = 100; baseTag < 105; baseTag++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:baseTag];
        if ([button isKindOfClass:[UIButton class]]) {
            NSString *title = button.titleLabel.text;
            [newAddressList addObject:title];
        }
        else {
            continue;
        }
    }
    
    return newAddressList;
}

- (void)setPersonalTagsList:(NSArray *)aPersonalTagsList {
    personalTagsList = aPersonalTagsList;
    [self.tableView reloadData];
}

- (NSArray *)personalTagsList {
    return personalTagsList;
}

#pragma mark -
#pragma mark 外部需要修改的方法

- (void)setUserLogoPath:(NSString *)anUserLogoPath {
    userLogoPath = anUserLogoPath;
    // TUDO: 通过网络获取图片，并且设置给‘userPhoto’
}

- (IBAction)touchUserPhoto:(UITapGestureRecognizer *)sender {
    // TUDO: 修改头像
}

- (IBAction)addressPress:(UIButton *)sender {
    NSInteger type = sender.tag;
    // TUDO: 选择地址， type为 100-104， 对应5中类型， sender.titleLabel.text 为当前地址
}

@end
