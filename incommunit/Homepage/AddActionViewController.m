//
//  AddActionViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/5.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "AddActionViewController.h"
#import "UIView+Clone.h"

#define CAMERA @"相机"
#define PHOTOES @"相册"

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
    
    NSMutableArray *photoImageDataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.contectTextView.layer.borderWidth = 1.0f;
    self.contectTextView.layer.borderColor = [UIColor colorWithRed:233/255.0f green:232/255.0f blue:232/255.0f alpha:1].CGColor;
    self.contectTextView.layer.cornerRadius = 5.0f;
    
    self.submitButton.layer.cornerRadius = 3.0f;
    
    photoImageDataList = [[NSMutableArray alloc] init];
    photoImageViewList = [[NSMutableArray alloc] init];
    [photoImageViewList addObject:self.photoImageView];
    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
    [self.photoImageView addGestureRecognizer:t];
    for (NSInteger index = 1; index < 5; index++) {
        UIImageView *imageView = [self.photoImageView clone];
        imageView.tag = index;
        CGRect frame = imageView.frame;
        frame.origin.x = CGRectGetMaxX(self.photoImageView.frame) * index;
        imageView.frame = frame;
        [self.imageScrollView addSubview:imageView];
        [photoImageViewList addObject:imageView];
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        [imageView addGestureRecognizer:t];
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

- (void)imageViewTap:(UITapGestureRecognizer *) tap {
    if (tap.view.tag > [photoImageDataList count] && [photoImageDataList count] != 0) {
        return;
    }
    
    UIActionSheet *actionSheet = nil;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:CAMERA, PHOTOES, nil];
    }
    else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:PHOTOES, nil];
    }
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:CAMERA]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else if ([title isEqualToString:PHOTOES]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        if (data.length > 1024 * 200) {
            data = UIImageJPEGRepresentation(image, 1024.0f * 200.0f / (CGFloat)data.length);
        }
        [photoImageDataList addObject:data];
        UIImageView *imageView = [photoImageViewList objectAtIndex:photoImageDataList.count - 1];
        [imageView setImage:[UIImage imageWithData:data]];
    }];
}

@end
