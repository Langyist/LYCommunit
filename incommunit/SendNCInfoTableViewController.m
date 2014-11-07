//
//  SendNCInfoTableViewController.m
//  incommunit
//  发布
//  Created by 李忠良 on 14/11/4.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "SendNCInfoTableViewController.h"
#import "UIView+Clone.h"


#define CAMERA @"相机"
#define PHOTOES @"相册"

@implementation StaticCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"%f", CGRectGetWidth(self.frame));
    NSLog(@"%f", CGRectGetWidth(self.contentView.frame));
    UIView *view = [self.contentView viewWithTag:100];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleTopMargin;
}

@end

@interface SendNCInfoTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *classBorderView;
@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;

@property (weak, nonatomic) IBOutlet UITextField *classTextField;
@property (weak, nonatomic) IBOutlet UIButton *classButton;
- (IBAction)classPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactStyleTextField;
@property (weak, nonatomic) IBOutlet UIView *photoContainerView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitPress:(id)sender;

@end
@implementation SendNCInfoTableViewController {
    CGFloat itemSpace;
    CGPoint photoStartPoint;
    CGSize photoSize;
    NSMutableArray *photoImageViewList;
    NSMutableArray *photoImageDataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classBorderView.layer.cornerRadius = 3.0f;
    self.submitButton.layer.cornerRadius = 3.0f;
    
    itemSpace = 17;
    photoStartPoint = CGPointMake(11, 32);
    photoSize = CGSizeMake(61, 61);
    
    photoImageDataList = [[NSMutableArray alloc] init];
    photoImageViewList = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 5; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){photoStartPoint, photoSize}];
        imageView.tag = index;
        imageView.userInteractionEnabled = YES;
        [imageView setImage:[UIImage imageNamed:@"添加_03"]];
        [self.photoContainerView addSubview:imageView];
        [photoImageViewList addObject:imageView];
        
        UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)];
        [imageView addGestureRecognizer:t];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self reposImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reposImageView {
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat imageViewBoardLenth = (viewWidth - photoStartPoint.x * 2 - itemSpace * 3) / 4;
    photoSize = CGSizeMake(imageViewBoardLenth, imageViewBoardLenth);
    for (NSInteger index = 0; index < 5; index++) {
        UIView *view = [photoImageViewList objectAtIndex:index];
        NSInteger line = index / 4;
        NSInteger col = index % 4;
        
        CGRect frame = view.frame;
        CGFloat x = photoStartPoint.x + col * itemSpace + col * photoSize.width;
        CGFloat y = photoStartPoint.y + line * itemSpace + line * photoSize.height;
        frame.origin = CGPointMake(x, y);
        frame.size = photoSize;
        view.frame = frame;
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    CGRect frame = cell.frame;
    frame.size.width = CGRectGetWidth(self.view.frame);
    cell.frame = frame;
    cell.contentView.frame = frame;
    [cell setNeedsLayout];
    [cell.contentView setNeedsLayout];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.sectionTitleLabel.frame))];
    [view setBackgroundColor:[UIColor clearColor]];
    UILabel *lalbel = [self.sectionTitleLabel clone];
    NSString *title = @"";
    CGRect frame = lalbel.frame;
    switch (section) {
        case 0:
            title = @"标题";
            frame.origin.y = 35;
            break;
        case 1:
            title = @"详情";
            frame.origin.y = 25;
            break;
        case 2:
            title = @"联系方式";
            frame.origin.y = 25;
            break;
        default:
            break;
    }
    [lalbel setText:title];
    lalbel.frame = frame;
    [view addSubview:lalbel];
    return view;
}

- (IBAction)classPress:(id)sender {
}

- (IBAction)submitPress:(id)sender {
}

- (void)imageViewTap:(UITapGestureRecognizer *) tap {
    if (tap.view.tag >= [photoImageDataList count] && [photoImageDataList count] != 0) {
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
        
        [self resetImage];
    }];
}

- (void)resetImage {
    for (NSInteger index = 0; index < 5; index++) {
        UIImageView *imageView = [photoImageViewList objectAtIndex:index];
        for (UIView *view in imageView.subviews) {
            [view removeFromSuperview];
        }
        if (index < [photoImageDataList count]) {
            NSData *data = [photoImageDataList objectAtIndex:index];
            [imageView setImage:[UIImage imageWithData:data]];
            
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect frame = imageView.frame;
            frame.origin = CGPointMake(photoSize.width / 2, photoSize.width / 2);
            frame.size = CGSizeMake(photoSize.width / 2, photoSize.width / 2);
            deleteButton.frame = frame;
            [deleteButton setImage:[UIImage imageNamed:@"删除_07"] forState:UIControlStateNormal];
            [deleteButton setContentEdgeInsets:UIEdgeInsetsMake(frame.size.width * 0.6, frame.size.width * 0.6, 0, 0)];
            [imageView addSubview:deleteButton];
            [deleteButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [imageView setImage:[UIImage imageNamed:@"添加_03"]];
        }
    }
}

- (void)deletePhoto:(UIButton *)button {
    if (button.tag < [photoImageDataList count]) {
        [photoImageDataList removeObjectAtIndex:button.tag];
        [self resetImage];
    }
}

@end
