//
//  LicenseViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/6.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LicenseViewController.h"

@interface LicenseViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"License" ofType:@"html"];
    if (!htmlFile) {
        htmlFile = @"";
    }
    NSURL *url = [NSURL fileURLWithPath:htmlFile];
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
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

@end
