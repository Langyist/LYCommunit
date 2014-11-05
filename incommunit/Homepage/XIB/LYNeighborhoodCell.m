//
//  LYNeighborhoodCell.m
//  in_community
//
//  Created by wangliang on 14-10-24.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYNeighborhoodCell.h"
#import "UIImageView+AsyncDownload.h"

@interface LYNeighborhoodCell ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButton:(id)sender;

@end

@implementation LYNeighborhoodCell {
    DeletePressBlock block;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.titleImageView.layer.cornerRadius = CGRectGetHeight(self.titleImageView.frame) / 2;
    self.titleImageView.clipsToBounds = YES;
    
    self.deleteButton.layer.cornerRadius = 3.0f;
    
    block = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteButton:(id)sender {
    if (block) {
        block(self);
    }
}

- (void)setImagePath:(NSString *)imagePath {
    if (imagePath!=nil && ![imagePath isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:imagePath];
        [self.titleImageView setImageWithURL:url placeholderImage:nil];
    }
}

- (void)setName:(NSString *)name {
    [self.nameLabel setText:name];
}

- (void)setSummary:(NSString *)summray {
    [self.summaryLabel setText:summray];
}

- (void)setDeleteBlock:(DeletePressBlock)deletePressBlock {
    block = deletePressBlock;
}

@end
