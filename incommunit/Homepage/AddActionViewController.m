//
//  AddActionViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/5.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "AddActionViewController.h"
#import "UIView+Clone.h"

@interface AddActionViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contectTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation AddActionViewController {
    UIView *editView;
    NSMutableArray *photoImageViewList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contectTextView.layer.borderWidth = 1.0f;
    self.contectTextView.layer.borderColor = [UIColor colorWithRed:233/255.0f green:232/255.0f blue:232/255.0f alpha:1].CGColor;
    self.contectTextView.layer.cornerRadius = 5.0f;
    
    self.submitButton.layer.cornerRadius = 3.0f;
    
    photoImageViewList = [[NSMutableArray alloc] init];
    [photoImageViewList addObject:self.photoImageView];
    for (NSInteger index = 0; index < 5; index++) {
        UIImageView *imageView = [self.photoImageView clone];
        CGRect frame = imageView.frame;
        frame.origin.x = CGRectGetMaxX(self.photoImageView.frame) * index;
        self.photoImageView.frame = frame;
        [self.imageScrollView addSubview:imageView];
        [photoImageViewList addObject:imageView];
    }
    [self.imageScrollView setContentSize:CGSizeMake(CGRectGetMaxX(self.photoImageView.frame) * 5, 0)];
    
    [self.baseScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.submitButton.frame) + 50)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)submit:(id)sender {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.imageScrollView) {
        NSInteger index = lroundf(self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width);
        self.pageControl.currentPage = index;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    editView = textField;
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    editView = textView;
    return YES;
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
                             [self.baseScrollView setContentInset:inset];
                             
                             [self.baseScrollView setContentOffset:CGPointMake(0, CGRectGetMinY(editView.frame) - 50)];
                         }];
    }
}

#pragma mark 键盘即将退出

- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [self.baseScrollView setContentInset:UIEdgeInsetsZero];
                     }];
}

@end
