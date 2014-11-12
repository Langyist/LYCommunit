//
//  LY_DeliveryCell.m
//  in_community
//
//  Created by wangliang on 14-9-21.
//  Copyright (c) 2014年 wangliang. All rights reserved.
//

#import "LY_DeliveryCell.h"
#import "AppDelegate.h"

@implementation LY_DeliveryCell
@synthesize m_imageview,m_iamge,m_name,m_call_number,m_send_info,m_distance,m_sendable,m_hui;

- (void)awakeFromNib {
    // Initialization code
    
    self.m_imageview.layer.cornerRadius = 3;
    self.m_imageview.clipsToBounds = YES;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, SEPLINE_GRAY.CGColor);
    
    CGFloat linewidth = 0.2f;
    CGContextSetLineWidth(context, linewidth);
    
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect) - linewidth); //start at this point
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect) - linewidth); //
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(UIImage *)img {
    if (![img isEqual:m_iamge]) {
        m_iamge = [img copy];
        self.m_imageview.image = m_iamge;
    }
    self.m_imageview.layer.cornerRadius = 3.0f;
    self.m_imageview.clipsToBounds = YES;
}

- (void)setStoreName:(NSString *)name {
    [self.m_name setText:name];
    CGRect newFrame = self.m_name.frame;
    newFrame.size.width = [self labelWidth:self.m_name];
    CGFloat x = CGRectGetMaxX(newFrame) + 5;
    newFrame = self.m_hui.frame;
    newFrame.origin.x = x;
    self.m_hui.frame = newFrame;
}

- (void)setCallNumber:(NSInteger)callNumber {
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)callNumber]];
    NSInteger numberLenth = attriString.length;
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"次拨打"];
    [attriString appendAttributedString:text];
    [attriString setAttributes:@{
                                 NSForegroundColorAttributeName : [UIColor colorWithRed:240/255.0f green:177/255.0f blue:72/255.0f alpha:1]
                                ,NSFontAttributeName : [UIFont systemFontOfSize:12.5]
                                }
                         range:NSMakeRange(0, numberLenth)];
    NSInteger textLocation = numberLenth;
    [attriString setAttributes:@{
                                 NSForegroundColorAttributeName : [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1]
                                 ,NSFontAttributeName : [UIFont boldSystemFontOfSize:12]
                                 }
                         range:NSMakeRange(textLocation, attriString.length - numberLenth)];
    [self.m_call_number setAttributedText:attriString];
}

- (void)setDistance:(float)meter {
    if(meter>1)
    {

        [self.m_distance setText:[NSString stringWithFormat:@"%.2fkm",meter]];
        
    }else
    {
        [self.m_distance setText:[NSString stringWithFormat:@"%0lfm", meter*1000]];
    }

    CGFloat textWidth = [self labelWidth:self.m_distance];
    CGFloat maxX = CGRectGetMaxX(self.m_distance.frame) - textWidth - CGRectGetWidth(self.distanceImage.frame) - 5;
    CGRect newFrame = self.distanceImage.frame;
    newFrame.origin.x = maxX;
    self.distanceImage.frame = newFrame;
}

- (CGFloat)labelWidth:(UILabel *)label {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect textBounds = [label.text boundingRectWithSize:label.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGRectGetWidth(textBounds);
}

@end
