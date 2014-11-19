//
//  RepairDetailViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/19.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "RepairDetailViewController.h"
#import "UIImageView+MKNetworkKitAdditions.h"
#import "StoreOnlineNetworkEngine.h"

@interface RepairDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *managerLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitterLabel;

@end

@implementation RepairDetailViewController {
    NSDictionary *repairInfoDic;
    NSString *repairID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getDetailData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Founcation

- (void)setRepairID:(NSString *)ID {
    repairID = ID;
}

#pragma mark -
#pragma mark Data Method

- (void)getDetailData {
    if (!repairID) {
        repairID = @"";
    }
    
    [[StoreOnlineNetworkEngine shareInstance] startNetWorkWithPath:@"services/wuye/service/detail"
                                                            params:@{
                                                                     @"id" : repairID
                                                                     }
                                                            repeat:YES
                                                             isGet:YES
                                                       resultBlock:^(BOOL bValidJSON, NSString *errorMsg, id result) {
                                                           if (!bValidJSON) {
                                                               UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                            message:errorMsg
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"确定"
                                                                                                  otherButtonTitles:nil, nil];
                                                               [al show];
                                                           }
                                                           else {
                                                               repairInfoDic = result;
                                                               [self updateInterface];
                                                           }
                                                       }];
}

#pragma mark -
#pragma mark Interface Method

- (void)updateInterface {
    NSString *imageUrlString = [repairInfoDic objectForKey:@"image_path"];
    if (!imageUrlString) {
        imageUrlString = @"";
    }
    NSURL *url = [NSURL URLWithString:imageUrlString];
    [self.titleImageView setImageFromURL:url placeHolderImage:[UIImage imageNamed:@""]];
    
    [self setLabelText:self.titleLabel text:[repairInfoDic objectForKey:@"name"]];
    
    [self setLabelText:self.addressLabel text:[repairInfoDic objectForKey:@"position"]];
    
    [self setLabelText:self.detailLabel text:[repairInfoDic objectForKey:@"description"]];
    
    NSInteger status = [[repairInfoDic objectForKey:@"status"] integerValue];
    NSString *statusString = @"";
    switch (status) {
        case 0:
        case 1:
            statusString = @"进行中";
            break;
        case 2:
        case 3:
            statusString = @"已完成";
            break;
        default:
            break;
    }
    [self setLabelText:self.statusLabel text:statusString];

    NSString *time = [self changeTimestamp:[repairInfoDic objectForKey:@"update_time"]];
    [self setLabelText:self.timeLabel text:time];
    
    [self setLabelText:self.managerLabel text:[repairInfoDic objectForKey:@"comment"]];
    
    NSString *name = [repairInfoDic objectForKey:@"nick_name"];
    NSString *createTime = [repairInfoDic objectForKey:@"create_time"];
    createTime = [self changeTimestamp:createTime];
    NSString *submitter = [NSString stringWithFormat:@"%@于%@提交维修", name, createTime];
    [self.submitterLabel setText:submitter];
    
    [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.submitterLabel.frame) + 50)];
}

- (CGFloat)heightOfLabel:(NSArray *)textList size:(CGSize)size font:(UIFont *)font {
    int length = 0;
    CGFloat height = 0;
    for (NSString *text in textList) {
        length += (int)[self widthOfString:text withFont:font];
    }
    if (length > 0) {
        int count = (int)(length / size.width);
        height = (count + 1) * font.lineHeight;
    }
    return height;
}

//根据字号计算字符串的宽度
- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    if (string.length == 0) {
        return 0;
    }
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width + 20;
}

- (NSString *)changeTimestamp:(NSString *)timestamp {
    if (!timestamp) {
        return @"";
    }
    
    long long timestampInt = [timestamp longLongValue];
    timestampInt /= 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *time = [formatter stringFromDate:date];
    return time;
}

- (void)setLabelText:(UILabel *)label text:(NSString *)text {
    if (!text) {
        text = @"";
    }
    
    CGFloat height =[self heightOfLabel:@[text] size:CGSizeMake(CGRectGetWidth(label.frame), CGFLOAT_MAX) font:label.font];
    
    CGRect rect = label.frame;
    rect.size.height = MAX(height, 18);
    CGFloat distance = CGRectGetHeight(rect) - CGRectGetHeight(label.frame);
    label.frame = rect;
    
    [label setText:text];
    
    [self moveSubviews:label moveDistance:distance];
}

- (void)moveSubviews:(UIView *)startView moveDistance:(CGFloat)distance {
    BOOL start = NO;
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            continue;
        }
        if (start) {
            CGRect rect = view.frame;
            rect.origin.y += distance;
            view.frame = rect;
        }
        else {
            if (view == startView) {
                start = YES;
            }
        }
    }
}

@end
