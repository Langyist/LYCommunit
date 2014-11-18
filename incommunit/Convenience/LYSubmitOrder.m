//
//  LYSubmitOrder.m
//  incommunit
//  提交订单界面
//  Created by LANGYI on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "LYSubmitOrder.h"
#import "AppDelegate.h"
#import "InsetTextField.h"
#import "SubmitOrderItemView.h"

@interface Right : UIView

@end

@implementation Right

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, SPECIAL_GRAY.CGColor);
    
    CGContextSetLineWidth(context, 0.5);
    
    CGFloat move = 5;
    CGContextMoveToPoint(context, 0, move); //start at this point
    CGContextAddLineToPoint(context, 0, CGRectGetHeight(rect) - move); //
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end

@interface SepLineView : UIView

@end

@implementation SepLineView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    
    CGFloat height = CGRectGetHeight(rect) * 0.8;
    CGContextSetLineWidth(context, height);
    
    CGContextMoveToPoint(context, 0, 0); //start at this point
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), 0); //
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end

@interface LYSubmitOrder ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet InsetTextField *reciverTextField;
@property (weak, nonatomic) IBOutlet InsetTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet InsetTextField *addressTextField;
@property (weak, nonatomic) IBOutlet InsetTextField *timeTextField;
@property (weak, nonatomic) IBOutlet InsetTextField *markTextField;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitPress:(id)sender;

@end

@implementation LYSubmitOrder {
    UIView *firstView;
    
    NSArray *dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.scrollView setBackgroundColor:BK_GRAY];
    [self modifyTextField:self.reciverTextField];
    [self modifyTextField:self.phoneTextField];
    [self modifyTextField:self.addressTextField];
    [self modifyTextField:self.timeTextField];
    [self modifyTextField:self.markTextField];

    Right *view = [[Right alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [view setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头_03"]];
    CGRect rect = imageView.frame;
    rect.size = CGSizeMake(18, 14);
    imageView.frame = rect;
    imageView.center = view.center;
    [view addSubview:imageView];
    
    self.timeTextField.rightView = view;
    self.timeTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.submitButton.layer.cornerRadius = 3.0f;
    [self.submitButton setBackgroundColor:SPECIAL_RED];
    
    dataList = @[@"", @""];
    
    [self addItemsInfo];
}

- (void)modifyTextField:(InsetTextField *)textField {
    [textField setTextInset:UIEdgeInsetsMake(0, 12, 0, 10)];
}

- (void)addItemsInfo {
    
    CGFloat y = CGRectGetMaxY(self.startLabel.frame) + 8;
    CGFloat realy = y;
    for (NSString *item in dataList) {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"SubmitOrderItemView" owner:self options:nil];
        SubmitOrderItemView *item = [nibViews objectAtIndex:0];
        CGRect rect = item.frame;
        rect.origin.y = realy;
        rect.size.width = CGRectGetWidth(self.view.frame);
        item.frame = rect;
        [item layoutSubviews];
        [self.scrollView insertSubview:item atIndex:0];
        
        realy += CGRectGetHeight(rect);
        
        [item setName:@"百事可乐"];
        [item setPrice:5];
        [item setNumber:2];
    }
    
    CGFloat move = realy - y;
    if (move) {
        move += 10;
        [self moveSubviews:self.startLabel move:move];
    }
    
    [self.scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(self.markTextField.frame) + 50)];
}

- (void)moveSubviews:(UIView *)startView move:(CGFloat)move {
    BOOL start = NO;
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            continue;
        }
        if (start) {
            CGRect rect = view.frame;
            rect.origin.y += move;
            view.frame = rect;
        }
        else {
            if (view == startView) {
                start = YES;
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    firstView = textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL ret = YES;
    if (textField == self.timeTextField) {
        ret = NO;
        
        //TUDO : 弹出选择框
    }
    return ret;
}

#pragma mark 键盘即将显示

- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(rect), 0);
                         [self.scrollView setContentInset:inset];
                         [self.scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(firstView.frame) - 50)];
                     }];
}

#pragma mark 键盘即将退出

- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [self.scrollView setContentInset:UIEdgeInsetsZero];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitPress:(id)sender {
}

@end
