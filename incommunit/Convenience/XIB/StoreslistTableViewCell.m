//
//  StoreslistTableViewCell.m
//  incommunit
//
//  Created by 李忠良 on 14/10/30.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "StoreslistTableViewCell.h"
#import "AppDelegate.h"

@implementation StoreslistTableViewCell

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, SPECIAL_GRAY.CGColor);
    
    CGFloat linewidth = 0.2f;
    CGContextSetLineWidth(context, linewidth);
    
    CGContextMoveToPoint(context, 0, CGRectGetHeight(rect) - linewidth);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect) - linewidth);
    
    CGContextStrokePath(context);
}

- (void)awakeFromNib {
    // Initialization code
    
    self.oreginPriceLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOreginPrice:(NSString *)price {
    self.oreginPriceLabel.hidden = !price;
    [self.oreginPriceLabel setText:price];

    
    CGFloat width = [self labelWidth:self.oreginPriceLabel];
    CGRect rect = self.oreginPriceLabel.bounds;
    rect.size.width = width;
    self.oreginPriceLabel.bounds = rect;
    
    [self repos];
}

- (void)setPrice:(NSString *)price {
    [self.priceLabel setText:price];
    
    [self repos];
}

- (void)repos {
    if (!self.oreginPriceLabel.hidden) {
        CGFloat width = MIN([self labelWidth:self.priceLabel], CGRectGetWidth(self.priceLabel.frame));
        CGFloat x = CGRectGetMinX(self.priceLabel.frame) + width + 10;
        CGRect rect = self.oreginPriceLabel.frame;
        rect.origin.x = x;
        self.oreginPriceLabel.frame = rect;
    }
}

- (CGFloat)labelWidth:(UILabel *)label {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect textBounds = [label.text boundingRectWithSize:label.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGRectGetWidth(textBounds);
}

@end
