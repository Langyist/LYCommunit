//
//  StoreSettingViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/7.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "StoreSettingViewController.h"
#import "InsetTextField.h"

@interface StoreSettingBkView : UIView
@end

@implementation StoreSettingBkView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGFloat linewidth = 1.0f;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    [self.nameTextField setTextInset:inset];
    [self.phoneTextField setTextInset:inset];
    [self.addressTextField setTextInset:inset];
    [self.typeTextField setTextInset:inset];
    
    self.logoImageView.layer.cornerRadius = 3.0f;
    self.logoImageView.clipsToBounds = YES;
    self.doneButton.layer.cornerRadius = 3.0f;
    
    [self reloadCollectionViewData:self.sendTimeCollectionView itemCount:0];
    [self reloadCollectionViewData:self.itemsClassesCollectionView itemCount:0];
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

- (void)reloadCollectionViewData:(UICollectionView *)collectionView itemCount:(NSInteger)cellCount {
    
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
    NSInteger numberOfItemsInSection = 0;
    return numberOfItemsInSection;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"" forIndexPath:indexPath];
    return cell;
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
