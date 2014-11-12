//
//  WelcomeViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/12.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIView+Clone.h"
@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.enterButton.layer.cornerRadius = 3.0f;
    self.enterButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.enterButton.layer.borderWidth = 0.5f;
    self.enterButton.hidden = YES;
    
    NSArray *imageNames = @[
                            @"小区周边_guide"
                            ,@"物业管理_guide"
                            ,@"邻里互助_guide"
                            ,@"小区交流_guide"
                            ,@"小区开店_guide"
                            ];
    
    for (NSInteger index = 0; index < [imageNames count]; index++) {
        NSString *imageName = [imageNames objectAtIndex:index];
        if (index == 0) {
            [self.imageView setImage:[UIImage imageNamed:imageName]];
        }
        else {
            UIImageView *imageView = [self.imageView clone];
            CGRect rect = imageView.frame;
            rect.origin.x = index * CGRectGetWidth(self.scrollView.frame);
            imageView.frame = rect;
            [imageView setImage:[UIImage imageNamed:imageName]];
            [self.scrollView addSubview:imageView];
        }
    }
    
    [self.scrollView setContentSize:CGSizeMake([imageNames count] * CGRectGetWidth(self.scrollView.frame), 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == (scrollView.contentSize.width - CGRectGetWidth(scrollView.frame))) {
        self.enterButton.hidden = NO;
    }
    else {
        self.enterButton.hidden = YES;
    }
}

- (IBAction)enterPress:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
