//
//  AWaterfallTableView.m
//  MarineBrothers
//
//  Created by 李忠良 on 14-7-9.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import "AWaterfallTableView.h"

#define REFRESHAREAHEIGHT   60
#define REFRESHTIP          @"下拉刷新"
#define MORETIP             @"上拉刷新"
#define CANREFRESH          @"松开刷新"

@interface AWaterfallTableViewDelegate : NSObject <UITableViewDelegate> {
@public
    id<UITableViewDelegate> _userDelegate;
}

@end

@interface AWaterfallTableView () {
    UIImageView             *refreshImage;
    UILabel                 *refreshLabel;
    UIActivityIndicatorView *refreshSpinner;
    
    UIImageView             *moreImage;
    UILabel                 *moreLabel;
    UIActivityIndicatorView *moreSpinner;
}

@property (strong, nonatomic) UIImageView               *refreshImage;
@property (strong, nonatomic) UILabel                   *refreshLabel;
@property (strong, nonatomic) UIActivityIndicatorView   *refreshSpinner;
@property (strong, nonatomic) UIImageView               *moreImage;
@property (strong, nonatomic) UILabel                   *moreLabel;
@property (strong, nonatomic) UIActivityIndicatorView   *moreSpinner;

- (void)myScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)myScrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)myScrollViewDidEndDragging:(UIScrollView *)scrollView;

@end

@implementation AWaterfallTableView {
    AWaterfallTableViewDelegate *_myDelegate;
    
    AWaterfallTableViewStatus status;
    AWaterfallTableViewStatus nextStatus;
    BOOL isDragging;
    
    BOOL canRefresh;
}

@synthesize refreshImage    = _refreshImage;
@synthesize refreshLabel    = _refreshLabel;
@synthesize refreshSpinner  = _refreshSpinner;
@synthesize moreImage       = _moreImage;
@synthesize moreLabel       = _moreLabel;
@synthesize moreSpinner     = _moreSpinner;

@synthesize canRefresh;
@synthesize canMore;

@synthesize status = _status;

- (void)setCanRefresh:(BOOL)acanRefresh {
    canRefresh = acanRefresh;
//    self.refreshImage.hidden = !canRefresh;
//    self.refreshLabel.hidden = !canRefresh;
}
- (void)setCanMore:(BOOL)acanMore {
    canMore = acanMore;
//    self.moreImage.hidden = !canMore;
//    self.moreLabel.hidden = !canMore;
}

- (void)initDelegate {
    
    status = AWaterfallTableViewNormal;
    nextStatus = AWaterfallTableViewNormal;
    self.canRefresh = YES;
    self.canMore = YES;
    
    [self.refreshSpinner setHidden:YES];
    [self.refreshLabel setHidden:YES];
    [self.refreshImage setHidden:YES];
    [self.moreSpinner setHidden:YES];
    [self.moreLabel setHidden:YES];
    [self.moreImage setHidden:YES];
    
    _myDelegate = [[AWaterfallTableViewDelegate alloc] init];
    [super setDelegate:_myDelegate];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self initDelegate];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initDelegate];
    }
    return self;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    
    if (_myDelegate) {
        
        _myDelegate->_userDelegate = delegate;
    }
    
    super.delegate = nil;
    super.delegate = (id)_myDelegate;
}

- (id<UIScrollViewDelegate>)delegate {
    
    return _myDelegate->_userDelegate;
}

- (AWaterfallTableViewStatus)status {
    
    return status;
}

- (UIImageView *)refreshImage {
    if (!refreshImage) {
        CGRect frame = CGRectMake(0, -REFRESHAREAHEIGHT, REFRESHAREAHEIGHT / 2, REFRESHAREAHEIGHT / 2);
        frame.origin.x = self.center.x - frame.size.width / 2;
        refreshImage = [[UIImageView alloc] initWithFrame:frame];
        [refreshImage setImage:[UIImage imageNamed:@"refreshArrow"]];
        [self addSubview:refreshImage];
        
        if (self.refreshLabel) {
            
            frame = [self.refreshLabel frame];
            frame.origin.y = refreshImage.frame.origin.y + refreshImage.frame.size.height;
            [self.refreshLabel setFrame:frame];
        }
        
        [refreshImage setHidden:YES];
    }
    return refreshImage;
}

- (UILabel *)refreshLabel
{
    if (!refreshLabel) {
        
        CGRect frame = CGRectMake(0, -REFRESHAREAHEIGHT/2, self.frame.size.width, REFRESHAREAHEIGHT / 2);
        if (self.refreshImage) {
            
            frame.origin.y = self.refreshImage.frame.origin.y + self.refreshImage.frame.size.height;
        }
        refreshLabel = [[UILabel alloc] initWithFrame:frame];
        [refreshLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [refreshLabel setTextColor:[UIColor lightGrayColor]];
        [refreshLabel setTextAlignment:NSTextAlignmentCenter];
        [refreshLabel setText:REFRESHTIP];
        [self addSubview:refreshLabel];
        
        [refreshLabel setHidden:YES];
    }
    return refreshLabel;
}

- (UIActivityIndicatorView *)refreshSpinner
{
    if (!refreshSpinner) {
        
        CGRect frame = CGRectMake(0, -REFRESHAREAHEIGHT * 3 / 4, REFRESHAREAHEIGHT / 2, REFRESHAREAHEIGHT / 2);
        frame.origin.x = self.center.x - frame.size.width / 2;
        refreshSpinner = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        [refreshSpinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [refreshSpinner setHidesWhenStopped:YES];
        [self addSubview:refreshSpinner];
        
        [refreshSpinner setHidden:YES];
    }
    return refreshSpinner;
}

- (UIImageView *)moreImage
{
    if (!moreImage) {
        
        CGRect frame = CGRectMake(0, self.frame.size.height + self.contentInset.top + REFRESHAREAHEIGHT / 2, REFRESHAREAHEIGHT / 2, REFRESHAREAHEIGHT / 2);
        frame.origin.x = self.center.x - frame.size.width / 2;
        moreImage = [[UIImageView alloc] initWithFrame:frame];
        [moreImage setImage:[UIImage imageNamed:@"refreshArrow"]];
        [self addSubview:moreImage];
        
        if (self.moreLabel) {
            
            frame = [self.moreLabel frame];
            frame.origin.y = moreImage.frame.origin.y - moreImage.frame.size.height;
            [self.moreLabel setFrame:frame];
        }
        
        [moreImage setHidden:YES];
    }
    return moreImage;
}

- (UILabel *)moreLabel
{
    if (!moreLabel) {
        
        CGRect frame = CGRectMake(0, self.frame.size.height + self.contentInset.top, self.frame.size.width, REFRESHAREAHEIGHT / 2);
        moreLabel = [[UILabel alloc] initWithFrame:frame];
        [moreLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [moreLabel setTextColor:[UIColor lightGrayColor]];
        [moreLabel setTextAlignment:NSTextAlignmentCenter];
        [moreLabel setText:REFRESHTIP];
        [self addSubview:moreLabel];
        
        [moreLabel setHidden:YES];
    }
    return moreLabel;
}

- (UIActivityIndicatorView *)moreSpinner
{
    if (!moreSpinner) {
        
        CGRect frame = CGRectMake(0, self.frame.size.height + REFRESHAREAHEIGHT / 4 + self.contentInset.top, REFRESHAREAHEIGHT / 2, REFRESHAREAHEIGHT / 2);
        frame.origin.x = self.center.x - frame.size.width / 2;
        moreSpinner = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        [moreSpinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [moreSpinner setHidesWhenStopped:YES];
        [self addSubview:moreSpinner];
        
        [moreSpinner setHidden:YES];
    }
    return moreSpinner;
}

- (void)myScrollViewDidScroll:(UIScrollView *)scrollView {
    nextStatus = AWaterfallTableViewNormal;
    
    if (!isDragging) {
        
        return;
    }
    
    if (self.status == AWaterfallTableViewRefreshing
        || self.status == AWaterfallTableViewMoring) {
        
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat top = scrollView.contentInset.top;
    CGFloat bottom = scrollView.contentInset.bottom;
    CGFloat height = scrollView.contentSize.height;
    CGFloat viewheight = scrollView.frame.size.height;
    if (offsetY + top < 0 && self.canRefresh) {
        
        [UIView beginAnimations:nil context:NULL];
        if (offsetY + top < -REFRESHAREAHEIGHT) {
            
            nextStatus = AWaterfallTableViewRefreshing;
            
            self.refreshImage.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            [self.refreshLabel setText:CANREFRESH];
        }
        else {
            
            nextStatus = AWaterfallTableViewNormal;
            
            self.refreshImage.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            [self.refreshLabel setText:REFRESHTIP];
        }
        [self.refreshImage setHidden:NO];
        [self.refreshLabel setHidden:NO];
        [self.refreshSpinner setHidden:YES];
        [UIView commitAnimations];
    }
    else if ((offsetY + top) + (viewheight - top - bottom) - height > 0 && self.canMore) {
        
        CGRect newFrame = self.moreLabel.frame;
        newFrame.origin.y = height;
        self.moreLabel.frame = newFrame;
        newFrame = self.moreImage.frame;
        newFrame.origin.y = height + self.moreLabel.frame.size.height;
        self.moreImage.frame = newFrame;
        
        [UIView beginAnimations:nil context:NULL];
        if ((offsetY + top) + (viewheight - top - bottom) - height > REFRESHAREAHEIGHT) {
            
            nextStatus = AWaterfallTableViewMoring;
            
            self.moreImage.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            [self.moreLabel setText:CANREFRESH];
        }
        else {
            
            nextStatus = AWaterfallTableViewNormal;
            
            self.moreImage.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            [self.moreLabel setText:MORETIP];
        }
        
        [self.moreImage setHidden:NO];
        [self.moreLabel setHidden:NO];
        [self.moreSpinner setHidden:YES];
        [UIView commitAnimations];
    }
    else {
        
        nextStatus = AWaterfallTableViewNormal;
        
        [self.refreshImage setHidden:YES];
        [self.refreshLabel setHidden:YES];
        [self.moreImage setHidden:YES];
        [self.moreLabel setHidden:YES];
        [self.moreSpinner setHidden:YES];
        [self.refreshSpinner setHidden:YES];
    }
}

- (void)myScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    isDragging = YES;
}

- (void)myScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    isDragging = NO;
    
    switch (nextStatus) {
            
        case AWaterfallTableViewRefreshing: {
            [self refreshStart];
        }
            break;
        case AWaterfallTableViewMoring: {
            [self moreStart];
        }
            break;
        default:
            break;
    }
}

- (void)refreshStart {
    
    if (!self.canRefresh) {
        return;
    }
    
    self.canMore = YES;
    
    if (self.status != AWaterfallTableViewRefreshing)
    {
        status = AWaterfallTableViewRefreshing;
        
        [self.refreshImage setHidden:YES];
        [self.refreshLabel setHidden:YES];
        [self.refreshSpinner setHidden:NO];
        [self.refreshSpinner startAnimating];
        
        UIEdgeInsets inset = self.contentInset;
        inset.top += REFRESHAREAHEIGHT;
        self.contentInset = inset;
        
        if (_myDelegate && [_myDelegate->_userDelegate respondsToSelector:@selector(refresh:)]) {
            [_myDelegate->_userDelegate performSelector:@selector(refresh:) withObject:self];
        }
        else {
            [self performSelector:@selector(refreshEnd) withObject:nil afterDelay:2];
        }
    }
}

- (void)refreshEnd {
    
    if (self.status == AWaterfallTableViewRefreshing) {
        
        UIEdgeInsets inset = self.contentInset;
        inset.top -= REFRESHAREAHEIGHT;
        self.contentInset = inset;
        
        [self.refreshSpinner stopAnimating];
    }
    
    status = AWaterfallTableViewNormal;
}

- (void)moreStart {
    
    if (self.status != AWaterfallTableViewMoring)
    {
        status = AWaterfallTableViewMoring;
        
        [self.moreImage setHidden:YES];
        [self.moreLabel setHidden:YES];
        [self.moreSpinner setHidden:NO];
        [self.moreSpinner startAnimating];
        
        UIEdgeInsets inset = self.contentInset;
        inset.bottom += REFRESHAREAHEIGHT;
        self.contentInset = inset;
        
        if (_myDelegate && [_myDelegate->_userDelegate respondsToSelector:@selector(more:)]) {
            [_myDelegate->_userDelegate performSelector:@selector(more:) withObject:self];
        }
        
        else {
            [self performSelector:@selector(moreEnd) withObject:nil afterDelay:2];
        }
    }
}

- (void)moreEnd {
    
    if (self.status == AWaterfallTableViewMoring) {
        
        UIEdgeInsets inset = self.contentInset;
        inset.bottom -= REFRESHAREAHEIGHT;
        self.contentInset = inset;
        
        [self.moreSpinner stopAnimating];
    }
    
    status = AWaterfallTableViewNormal;
}

#pragma mark - overwrite

@end

@implementation AWaterfallTableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    AWaterfallTableView *tableView = (AWaterfallTableView *)scrollView;
    if ([tableView respondsToSelector:@selector(myScrollViewDidScroll:)]) {
        
        [tableView performSelector:@selector(myScrollViewDidScroll:) withObject:scrollView];
    }
    if ([_userDelegate respondsToSelector:_cmd]) {
        
        [_userDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    AWaterfallTableView *tableView = (AWaterfallTableView *)scrollView;
    if ([tableView respondsToSelector:@selector(myScrollViewWillBeginDragging:)]) {
        
        [tableView performSelector:@selector(myScrollViewWillBeginDragging:) withObject:scrollView];
    }
    if ([_userDelegate respondsToSelector:_cmd]) {
        
        [_userDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    AWaterfallTableView *tableView = (AWaterfallTableView *)scrollView;
    if ([tableView respondsToSelector:@selector(myScrollViewDidEndDragging:)]) {
        
        [tableView performSelector:@selector(myScrollViewDidEndDragging:) withObject:scrollView];
    }
    if ([_userDelegate respondsToSelector:_cmd]) {
        
        [_userDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (BOOL)respondsToSelector:(SEL)selector {
    
    return [_userDelegate respondsToSelector:selector] || [super respondsToSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // This should only ever be called from `UIScrollView`, after it has verified
    // that `_userDelegate` responds to the selector by sending me
    // `respondsToSelector:`.  So I don't need to check again here.
    [invocation invokeWithTarget:_userDelegate];
}

@end
