//
//  SendNCInfoTableViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/4.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "SendNCInfoTableViewController.h"
#import "UIView+Clone.h"

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

@interface SendNCInfoTableViewController ()

@end

@implementation SendNCInfoTableViewController {
    CGFloat itemSpace;
    CGPoint photoStartPoint;
    CGSize photoSize;
    
    NSMutableArray *photoImageViewList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.classBorderView.layer.cornerRadius = 3.0f;
    self.submitButton.layer.cornerRadius = 3.0f;
    
    itemSpace = 17;
    photoStartPoint = CGPointMake(11, 32);
    photoSize = CGSizeMake(61, 61);
    photoImageViewList = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 5; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){photoStartPoint, photoSize}];
        [imageView setBackgroundColor:[UIColor lightGrayColor]];
        [self.photoContainerView addSubview:imageView];
        [photoImageViewList addObject:imageView];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.sectionTitleLabel.frame))];
    [view setBackgroundColor:[UIColor clearColor]];
    UILabel *lalbel = [self.sectionTitleLabel clone];
    NSString *title = @"";
    switch (section) {
        case 0:
            title = @"标题";
            break;
        case 1:
            title = @"详情";
            break;
        case 2:
            title = @"联系方式";
            break;
        default:
            break;
    }
    [lalbel setText:title];
    CGRect frame = lalbel.frame;
    frame.origin.y = 25;
    lalbel.frame = frame;
    [view addSubview:lalbel];
    return view;
}

- (IBAction)classPress:(id)sender {
}
- (IBAction)submitPress:(id)sender {
}
@end
