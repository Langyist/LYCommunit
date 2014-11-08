//
//  StoreSettingViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/7.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "StoreSettingViewController.h"
#import "InsetTextField.h"
#import "StoreSettingCollectionViewCell.h"
#import "StoreSettingAddCollectionViewCell.h"

@interface StoreSettingBkView : UIView
@end

@implementation StoreSettingBkView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGFloat linewidth = 0.2;
    CGContextSetLineWidth(context, linewidth);
    
    CGFloat x = 15;
    CGFloat ex = CGRectGetWidth(rect) - x;
    CGFloat y = 40;
    CGFloat move = 40;
    CGContextMoveToPoint(context, x, y); //start at this point
    CGContextAddLineToPoint(context, ex, y); //draw to this point
    y += move;
    CGContextMoveToPoint(context, x, y); //start at this point
    CGContextAddLineToPoint(context, ex, y); //draw to this point
    y += move;
    CGContextMoveToPoint(context, x, y); //start at this point
    CGContextAddLineToPoint(context, ex, y); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end

@interface StoreSettingViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet InsetTextField *nameTextField;
@property (weak, nonatomic) IBOutlet InsetTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet InsetTextField *addressTextField;
@property (weak, nonatomic) IBOutlet InsetTextField *typeTextField;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;
@property (weak, nonatomic) IBOutlet UISwitch *sendSwitch;
- (IBAction)sendValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *sendMessage;
@property (weak, nonatomic) IBOutlet UICollectionView *sendTimeCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *itemsClassesCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)donePress:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *caperationNumberLabel;

@end

@implementation StoreSettingViewController {
    UIView *editView;
    
    NSMutableArray *sendTimes;
    NSMutableArray *itemClasses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sendTimes = [[NSMutableArray alloc] init];
    itemClasses = [[NSMutableArray alloc] init];
    
    UINib *nib = [UINib nibWithNibName:@"StoreSettingCollectionViewCell" bundle:nil];
    UINib *addnib = [UINib nibWithNibName:@"StoreSettingAddCollectionViewCell" bundle:nil];
    [self.sendTimeCollectionView registerNib:nib forCellWithReuseIdentifier:@"StoreSettingCollectionViewCell"];
    [self.itemsClassesCollectionView registerNib:nib forCellWithReuseIdentifier:@"StoreSettingCollectionViewCell"];
    [self.sendTimeCollectionView registerNib:addnib forCellWithReuseIdentifier:@"StoreSettingAddCollectionViewCell"];
    [self.itemsClassesCollectionView registerNib:addnib forCellWithReuseIdentifier:@"StoreSettingAddCollectionViewCell"];
    
    [self setInsetTextFieldProperty:self.nameTextField];
    [self setInsetTextFieldProperty:self.phoneTextField];
    [self setInsetTextFieldProperty:self.addressTextField];
    [self setInsetTextFieldProperty:self.typeTextField];
    
    self.logoImageView.layer.cornerRadius = 3.0f;
    self.logoImageView.clipsToBounds = YES;
    self.doneButton.layer.cornerRadius = 3.0f;
    
    [self reloadCollectionViewData:self.sendTimeCollectionView itemCount:sendTimes.count + 1];
    [self reloadCollectionViewData:self.itemsClassesCollectionView itemCount:itemClasses.count + 1];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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

- (IBAction)sendValueChanged:(id)sender {
}

- (IBAction)donePress:(id)sender {
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    editView = textView;
    return YES;
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    editView = textField;
    return YES;
}

#pragma mark -
#pragma mark Method

- (void)setInsetTextFieldProperty:(InsetTextField *)field {
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 15, 0, 15);
    [field setTextInset:inset];
    [field setShowBorderLine:NO];
}

- (void)reloadCollectionViewData:(UICollectionView *)collectionView itemCount:(NSInteger)cellCount {
    
    if (!collectionView) {
        return;
    }
    
    CGFloat collectionViewHeight = collectionView.bounds.size.height;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
    UIEdgeInsets sectionInset = layout.sectionInset;
    CGRect sectionRect = UIEdgeInsetsInsetRect(collectionView.frame, sectionInset);
    CGSize itemSize = layout.itemSize;
    NSInteger maxColnum = (sectionRect.size.width  + layout.minimumInteritemSpacing) / (itemSize.width + layout.minimumInteritemSpacing);
    maxColnum = MAX(maxColnum, 1);
    NSInteger macLine = cellCount / maxColnum + ((cellCount % maxColnum) ? 1 : 0);
    macLine = MAX(macLine, 1);
    collectionViewHeight = macLine * itemSize.height + MAX(macLine - 1, 0) * layout.minimumLineSpacing;
    collectionViewHeight += sectionInset.top + sectionInset.bottom;
    
    CGRect rect = collectionView.frame;
    CGFloat move = collectionViewHeight - CGRectGetHeight(rect);
    rect.size.height = collectionViewHeight;
    collectionView.frame = rect;
    
    [collectionView reloadData];
    
    BOOL startMove = NO;
    UIView *lastview = nil;
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            continue;
        }
        if (startMove) {
            CGRect rect = view.frame;
            rect.origin.y += move;
            view.frame = rect;
        }
        else {
            if (view == collectionView) {
                startMove = YES;
            }
        }
        lastview = view;
    }
    if (lastview) {
        CGFloat contentSizeHeight = CGRectGetMaxY(lastview.frame);
        [self.scrollView setContentSize:CGSizeMake(0, contentSizeHeight + 50)];
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItemsInSection = 1;
    if (self.sendTimeCollectionView == collectionView) {
        numberOfItemsInSection += sendTimes.count;
    }
    else if (self.itemsClassesCollectionView == collectionView) {
        numberOfItemsInSection += itemClasses.count;
    }
    return numberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    NSArray *dataArray = nil;
    NSString *typeName = @"";
    if (self.sendTimeCollectionView == collectionView) {
        dataArray = sendTimes;
        typeName = @"time";
    }
    else if (self.itemsClassesCollectionView == collectionView) {
        dataArray = itemClasses;
        typeName = @"item";
    }
    
    if (indexPath.row >= dataArray.count) {
        StoreSettingAddCollectionViewCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreSettingAddCollectionViewCell" forIndexPath:indexPath];
        cell = addCell;
    }
    else {
        StoreSettingCollectionViewCell *normalCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreSettingCollectionViewCell" forIndexPath:indexPath];
        [normalCell.textLabel setText:[dataArray objectAtIndex:indexPath.row]];
        [normalCell setDeleteBlock:^(StoreSettingCollectionViewCell *cell) {
            
            UICollectionView *collectionView = nil;
            NSMutableArray *tempArray = nil;
            if ([cell.type isEqualToString:@"time"]) {
                tempArray = sendTimes;
                collectionView = self.sendTimeCollectionView;
            }
            else if ([cell.type isEqualToString:@"item"]) {
                tempArray = itemClasses;
                collectionView = self.itemsClassesCollectionView;
            }
            if (cell.tag < tempArray.count) {
                [tempArray removeObjectAtIndex:cell.tag];
                [self reloadCollectionViewData:collectionView itemCount:tempArray.count + 1];
            }
        }];
        [normalCell setType:typeName];
        cell = normalCell;
    }
    cell.tag = indexPath.row;
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sendTimeCollectionView == collectionView) {
        if (indexPath.row >= sendTimes.count) {
            [sendTimes addObject:@"时间"];
            [self reloadCollectionViewData:collectionView itemCount:sendTimes.count + 1];
        }
    }
    else if (self.itemsClassesCollectionView == collectionView) {
        if (indexPath.row >= itemClasses.count) {
            [itemClasses addObject:@"商品"];
            [self reloadCollectionViewData:collectionView itemCount:itemClasses.count + 1];
        }
    }
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示

- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (rect.origin.y >= self.view.frame.origin.y) {
        CGFloat ty = -rect.size.height;
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                         animations:^{
                             UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, -ty, 0);
                             [self.scrollView setContentInset:inset];
                             
                             [self.scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(editView.frame) - 50)];
                         }];
    }
}

#pragma mark 键盘即将退出

- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [self.scrollView setContentInset:UIEdgeInsetsZero];
                     }];
}

@end
