//
//  ColMenu.m
//  incommunit
//
//  Created by 李忠良 on 14/11/5.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "ColMenu.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

static CGRect startRect;

@interface ColMenuCell : UITableViewCell

@end

@implementation ColMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = TOP_BAR_YELLOW;
        self.selectedBackgroundView = selectionColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    
//    CGFloat lineWidth = 0.2f;
//    CGFloat move = 1.0f - lineWidth;
//    // Draw them with a 2.0 stroke width so they are a bit more visible.
//    CGContextSetLineWidth(context, lineWidth);
//    
//    CGContextMoveToPoint(context, 0.0f, CGRectGetHeight(rect) - move); //start at this point
//    
//    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect) - move); //draw to this point
//    
//    // and now draw the Path!
//    CGContextStrokePath(context);
}

@end

@interface ColMenuTable : UITableView

@end

@implementation ColMenuTable

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGFloat lineWidth = 0.2f;
    CGFloat space = 15;
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, lineWidth);
    
    CGContextMoveToPoint(context, CGRectGetWidth(rect) - lineWidth, space); //start at this point
    
    CGContextAddLineToPoint(context, CGRectGetWidth(rect) - lineWidth, CGRectGetHeight(rect) - space); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);
}

@end

@interface ColMenuView : UIView <UITableViewDataSource, UITableViewDelegate>
@end

@interface ColMenuOverlay : UIView
@end

@implementation  ColMenuOverlay

// - (void) dealloc { NSLog(@"dealloc %@", self); }

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect rectangle = CGRectMake(0, CGRectGetMaxY(startRect), CGRectGetWidth(rect), CGRectGetHeight(rect) - CGRectGetMaxY(startRect));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // #define BK_GRAY [UIColor colorWithRed:233/255.0f green:232/255.0f blue:232/255.0f alpha:1.0]
    CGContextSetRGBFillColor(context, 233/255.0f, 232/255.0f, 232/255.0f, 0.8);
    CGContextSetRGBStrokeColor(context, 233/255.0f, 232/255.0f, 232/255.0f, 0.8);
    CGContextFillRect(context, rectangle);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touched = [[touches anyObject] view];
    if (touched == self) {
        
        for (UIView *v in self.subviews) {
            if ([v isKindOfClass:[ ColMenuView class]]
                && [v respondsToSelector:@selector(dismissMenu:)]) {
                
                [v performSelector:@selector(dismissMenu:) withObject:@(YES)];
            }
        }
    }
}

@end


@implementation ColMenuView {
    UIView              *_contentView;
    UIButton            *sureButton;
    ColMenuOverlay      *overlay;
    id<ColMenuDelegate> _colMenuDelegate;
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if(self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        self.alpha = 0;
        
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowRadius = 2;
    }
    
    return self;
}

- (void) setupFrameInView:(UIView *)view
                 fromRect:(CGRect)fromRect
{
    
}

- (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
              delegate:(id<ColMenuDelegate>)delegate
{
    assert(delegate);
    
    startRect = rect;
    
    _colMenuDelegate = delegate;
    
    _contentView = [self mkContentView:view];
    [self addSubview:_contentView];
    
    [self setupFrameInView:view fromRect:rect];
    
    overlay = [[ColMenuOverlay alloc] initWithFrame:view.bounds];
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    NSInteger sectionOfColMenu = [self sectionOfColMenu:[ColMenu sharedMenu]];
    if (sectionOfColMenu != 0) {
        CGFloat tableViewWidth = CGRectGetWidth(view.frame) / sectionOfColMenu;
        
        for (NSInteger secton = 0; secton < sectionOfColMenu; secton++) {
            ColMenuTable *tableView = [[ColMenuTable alloc] initWithFrame:CGRectMake(secton * tableViewWidth, 0, tableViewWidth, [self tableView:nil heightForRowAtIndexPath:nil]) style:UITableViewStylePlain];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[ColMenuCell class] forCellReuseIdentifier:@"ColMenuCell"];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.tag = secton;
            tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
                | UIViewAutoresizingFlexibleHeight
                | UIViewAutoresizingFlexibleBottomMargin;
            [_contentView addSubview:tableView];
        }
    }
    
    [sureButton removeFromSuperview];
    sureButton = nil;
    sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton addTarget:self action:@selector(surePress:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.hidden = YES;
    sureButton.frame = CGRectMake(CGRectGetWidth(_contentView.frame) - 44, CGRectGetHeight(_contentView.frame) - 44, 39, 41);
    [sureButton setImage:[UIImage imageNamed:@"ic_dismiss"] forState:UIControlStateNormal];
    [sureButton setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    sureButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    [_contentView addSubview:sureButton];
    
    _contentView.hidden = YES;
    self.frame = (CGRect){0, CGRectGetMaxY(rect), _contentView.frame.size};
    
    [self reloadData:YES];
}

- (void)dismissMenu:(BOOL) animated
{
    if (self.superview) {
        
        if (animated) {
            
            _contentView.hidden = YES;
            const CGRect toFrame = (CGRect){self.frame.origin, CGRectGetWidth(self.frame), 1};
            
            [UIView animateWithDuration:0.2
                             animations:^(void) {
                                 
                                 self.alpha = 0;
                                 self.frame = toFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 if ([self.superview isKindOfClass:[ColMenuOverlay class]])
                                     [self.superview removeFromSuperview];
                                 [self removeFromSuperview];
                             }];
            
        } else {
            
            if ([self.superview isKindOfClass:[ColMenuOverlay class]])
                [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }
    }
}

- (void)performAction:(id)sender
{
    [self dismissMenu:YES];
}

- (UIView *) mkContentView:(UIView *)view
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    sureButton = nil;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    contentView.backgroundColor = [UIColor clearColor];
    contentView.opaque = NO;
    
    contentView.frame = (CGRect){0, 0, CGRectGetWidth(view.frame), [self tableView:nil heightForRowAtIndexPath:nil]};
    
    return contentView;
}

- (CGFloat)reloadData:(BOOL)resizeContent {
    
    NSInteger sectionOfColMenu = [self sectionOfColMenu:[ColMenu sharedMenu]];
    
    CGFloat contentViewHeight = 0;
    for (NSInteger secton = 0; secton < sectionOfColMenu; secton++) {
        if ([_colMenuDelegate respondsToSelector:@selector(colMune:numberOfRowsInSection:)]) {
            contentViewHeight = MAX(contentViewHeight, [_colMenuDelegate colMune:[ColMenu sharedMenu] numberOfRowsInSection:secton] * [self tableView:nil heightForRowAtIndexPath:nil]);
        }
    }
    if ([_colMenuDelegate respondsToSelector:@selector(colMune:titleForHeaderOfSection:)]) {
        contentViewHeight += 44;
    }
    contentViewHeight = MIN(contentViewHeight, (CGRectGetHeight(overlay.frame) - CGRectGetMaxY(_contentView.frame)) * 0.6);
    
    if (resizeContent) {
        CGRect rect = _contentView.frame;
        rect.size.height = contentViewHeight;
        _contentView.frame = rect;
        [_contentView setNeedsLayout];
    }
    
    for (UITableView *tableView in _contentView.subviews) {
        if ([tableView isKindOfClass:[UITableView class]]) {
            [tableView reloadData];
        }
    }
    
    const CGRect toFrame = (CGRect){self.frame.origin, CGRectGetWidth(self.frame), contentViewHeight};
    CGRect contentFrame = _contentView.frame;
    contentFrame.size.height = contentViewHeight;
    
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                         _contentView.hidden = NO;
                     } completion:^(BOOL completed) {
                         _contentView.frame = contentFrame;
                         sureButton.frame = CGRectMake(CGRectGetWidth(_contentView.frame) - 44, CGRectGetHeight(_contentView.frame) - 44, 39, 41);
                         
                         sureButton.hidden = NO;
                     }];
    
    return contentViewHeight;
}

- (void)setSeletectItemOfSection:(NSInteger)section row:(NSInteger)row {
    NSInteger sectionIndex = 0;
    for (UITableView *tableView in _contentView.subviews) {
        if ([tableView isKindOfClass:[UITableView class]]) {
            if (sectionIndex == section) {
                if (row < [tableView numberOfRowsInSection:0]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                }
                break;
            }
            sectionIndex++;
        }
    }
}

- (NSInteger)sectionOfColMenu:(ColMenu *)colMenu {
    NSInteger sectionOfColMenu = 1;
    if ([_colMenuDelegate respondsToSelector:@selector(sectionOfColMenu:)]) {
        sectionOfColMenu = [_colMenuDelegate sectionOfColMenu:[ColMenu sharedMenu]];
    }
    return sectionOfColMenu;
}

- (void)surePress:(id)sender {
    if ([_colMenuDelegate respondsToSelector:@selector(done:)]) {
        [_colMenuDelegate done:[ColMenu sharedMenu]];
    }
    [self dismissMenu:YES];
}

#pragma mark -
#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRowsInSection = 0;
    if ([_colMenuDelegate respondsToSelector:@selector(colMune:numberOfRowsInSection:)]) {
        numberOfRowsInSection = [_colMenuDelegate colMune:[ColMenu sharedMenu] numberOfRowsInSection:tableView.tag];
    }
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ColMenuCell" forIndexPath:indexPath];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    [selectedBackgroundView setBackgroundColor:TOP_BAR_YELLOW];
    cell.selectedBackgroundView = selectedBackgroundView;
    if ([_colMenuDelegate respondsToSelector:@selector(colMune:titleForItemOfSection:row:)]) {
        [cell.textLabel setText:[_colMenuDelegate colMune:[ColMenu sharedMenu] titleForItemOfSection:tableView.tag row:indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_colMenuDelegate respondsToSelector:@selector(colMune:didSelectItemOfSection:row:)]) {
        [_colMenuDelegate colMune:[ColMenu sharedMenu] didSelectItemOfSection:tableView.tag row:indexPath.row];
    }
    //[self dismissMenu:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat heightForHeaderInSection = 0;
    if ([_colMenuDelegate respondsToSelector:@selector(colMune:titleForHeaderOfSection:)]) {
        NSString *titleForHeaderInSection = [_colMenuDelegate colMune:[ColMenu sharedMenu] titleForHeaderOfSection:tableView.tag];
        if ([titleForHeaderInSection length]) {
            heightForHeaderInSection = 44;
        }
    }
    return heightForHeaderInSection;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewForHeaderInSection = nil;
    if ([_colMenuDelegate respondsToSelector:@selector(colMune:titleForHeaderOfSection:)]) {
        NSString *titleForHeaderInSection = [_colMenuDelegate colMune:[ColMenu sharedMenu] titleForHeaderOfSection:tableView.tag];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.separatorInset.left, 0, CGRectGetWidth(tableView.frame) - tableView.separatorInset.left - 1, 42)];
        [label setText:titleForHeaderInSection];
        [label setBackgroundColor:[UIColor whiteColor]];
//        
//        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:label.bounds];
//        label.layer.masksToBounds = NO;
//        label.layer.shadowColor = [UIColor blackColor].CGColor;
//        label.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
//        label.layer.shadowOpacity = 0.2f;
//        label.layer.shadowPath = shadowPath.CGPath;
        
        viewForHeaderInSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 44)];
        [viewForHeaderInSection addSubview:label];
        [viewForHeaderInSection setBackgroundColor:[UIColor clearColor]];
    }
    return viewForHeaderInSection;
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

static ColMenu *gColMenu;
static UIColor *gTintColor;
static UIFont *gTitleFont;

@implementation ColMenu {
    
    ColMenuView *_menuView;
    BOOL        _observing;
}

+ (instancetype) sharedMenu
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        gColMenu = [[ ColMenu alloc] init];
    });
    return gColMenu;
}

- (id) init
{
    NSAssert(!gColMenu, @"singleton object");
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void) dealloc
{
    if (_observing) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
               delegate:(id<ColMenuDelegate>)delegate
{
    NSParameterAssert(view);
    
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        
        _observing = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationWillChange:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    
    
    _menuView = [[ ColMenuView alloc] init];
    [_menuView showMenuInView:view fromRect:rect delegate:delegate];
}

- (void) dismissMenu
{
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (_observing) {
        
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void) setSeletectItemOfSection:(NSInteger)section row:(NSInteger)row {
    [_menuView setSeletectItemOfSection:section row:row];
}

- (void)reloadDataEx {
    [_menuView reloadData:YES];
}

- (void) orientationWillChange: (NSNotification *) n
{
    [self dismissMenu];
}

+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
               delegate:(id<ColMenuDelegate>)delegate
{
    [[self sharedMenu] showMenuInView:view fromRect:rect delegate:delegate];
}

+ (void) reloadData {
    [[self sharedMenu] reloadDataEx];
}

+ (void) dismissMenu
{
    [[self sharedMenu] dismissMenu];
}

+ (void) setSeletectItemOfSection:(NSInteger)section row:(NSInteger)row {
    [[self sharedMenu] setSeletectItemOfSection:section row:row];
}

@end
