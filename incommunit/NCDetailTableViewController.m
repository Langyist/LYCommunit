//
//  NCDetailTableViewController.m
//  incommunit
//
//  Created by 李忠良 on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "NCDetailTableViewController.h"

@interface NCDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation NCDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"xxx"];
    [self setDetailLabelText:@"asdfasdfasdfasdfsd dsadfadfasdfeaefs"];
    [self setTimestampString:@"1415006036000"];
    
    self.closeButton.layer.cornerRadius = 3.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (IBAction)close:(id)sender {
}

- (void)setDetailLabelText:(NSString *)detail {
    CGFloat newHeight = [NCDetailTableViewController stringHeightWithString:@[detail] size:self.detailLabel.frame.size font:self.detailLabel.font];
    newHeight = MIN(newHeight, 64);
    
    CGRect frame = self.detailLabel.frame;
    frame.size.height = newHeight;
    self.detailLabel.frame = frame;
    
    [self.detailLabel setText:detail];
}

- (void)setTimestampString:(NSString *)timestamp {
    if (!timestamp) {
        [self.timeLabel setText:@""];
    }
    
    long long timestampInt = [timestamp longLongValue];
    timestampInt /= 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestampInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"MM月dd日";
    NSString *time = [formatter stringFromDate:date];
    if (!time) {
        time = @"";
    }
    [self.timeLabel setText:time];
}

+ (CGFloat)stringHeightWithString:(NSArray *)textList size:(CGSize)size font:(UIFont *)font {
    NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
    for (NSMutableString *text in textList) {
        [string appendString:text];
    }
    NSDictionary *attributes =@{NSFontAttributeName:font};//配置字体类型参数
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;//配置字符绘制规则
    CGRect rect = [string boundingRectWithSize:CGSizeMake(size.width, CGFLOAT_MAX) options:options attributes:attributes context:NULL];//计算文本大小
    
    return rect.size.height;
}

@end
