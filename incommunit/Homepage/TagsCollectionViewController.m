//
//  TagsCollectionViewController.m
//  UserInfo
//  个人资料设置
//  Created by langyi on 14/10/24.
//  Copyright (c) 2014年 langyi. All rights reserved.
//

#import "TagsCollectionViewController.h"
@implementation TagCell
@end
@implementation TagSctionTitle

@end

@interface TagsCollectionViewController () {
    NSArray *personalTags;
    NSDictionary *dicInfo;
}

@end

@implementation TagsCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
    dicInfo = @{
                @"兴趣爱好" : @[
                        @"音乐舞蹈"
                        ,@"电影"
                        ,@"摄影"
                        ,@"旅行"
                        ,@"运动"
                        ,@"麻将棋牌"
                        ,@"宠物"
                        ,@"汽车"
                        ]
                ,@"性别外貌" : @[
                        @"文艺青年"
                        ,@"高富帅"
                        ,@"拉拉"
                        ,@"暖男"
                        ]
                ,@"资源" : @[
                        @"家教"
                        ,@"家装"
                        ,@"室内设计"
                        ,@"空气净化"
                        ,@"特供粮油"
                        ,@"贷款"
                        ,@"家政"
                        ]
                ,@"职业" : @[
                        @"医生"
                        ,@"律师"
                        ,@"教师"
                        ,@"金融"
                        ,@"心理咨询"
                        ,@"程序猿"
                        ,@"水管工"
                        ]
                };
}

- (void)didReceiveMemoryWarning {
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [dicInfo count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *keys = [dicInfo allKeys];
    NSArray *titles = [dicInfo objectForKey:[keys objectAtIndex:section]];
    return [titles count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *keys = [dicInfo allKeys];
    NSArray *titles = [dicInfo objectForKey:[keys objectAtIndex:indexPath.section]];
    NSString * title = [titles objectAtIndex:indexPath.row];
    NSString * bkImageName = @"蓝色_03";
    if ([personalTags containsObject:title]) {
        bkImageName = @"person_data_label_seleted";
    }
    
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    [cell.backgroundImage setImage:[UIImage imageNamed:bkImageName]];
    [cell.title setText:title];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(320, 50);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSAssert([kind isEqualToString:UICollectionElementKindSectionHeader], @"Unexpected supplementary element kind");
    TagSctionTitle* cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                              withReuseIdentifier:@"TagSction"
                                                                     forIndexPath:indexPath];
    
    NSAssert([cell isKindOfClass:[TagSctionTitle class]], @"Unexpected class for header cell");
    
    NSArray *keys = [dicInfo allKeys];
    cell.title.text = [keys objectAtIndex:indexPath.section];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *keys = [dicInfo allKeys];
    NSArray *titles = [dicInfo objectForKey:[keys objectAtIndex:indexPath.section]];
    NSString * title = [titles objectAtIndex:indexPath.row];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    if ([personalTags count]) {
        list = [NSMutableArray arrayWithArray:personalTags];
    }
    if (![list containsObject:title]) {
        [list addObject:title];
    }
    
    personalTags = list;
    
    [collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
