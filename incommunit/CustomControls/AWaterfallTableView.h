//
//  AWaterfallTableView.h
//  MarineBrothers
//
//  Created by 李忠良 on 14-7-9.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AWaterfallTableViewDelegate;

typedef NS_ENUM(NSInteger, AWaterfallTableViewStatus) {
    
    AWaterfallTableViewNormal = 0
    ,AWaterfallTableViewRefreshing
    ,AWaterfallTableViewMoring
    ,AWaterfallTableViewNomore
};

@interface AWaterfallTableView : UITableView

@property (nonatomic, readonly) AWaterfallTableViewStatus status;
@property (nonatomic) BOOL      canRefresh;
@property (nonatomic) BOOL      canMore;

//开始刷新、拉取更多
- (void)refreshStart;
- (void)moreStart;

//停止刷新、拉取更多
- (void)refreshEnd;
- (void)moreEnd;

@end

@protocol AWaterfallTableViewDelegate

/*!
 *  @abstract
 *  开始刷新触发的协议
 *  @discussion
 *
 *
 */
- (void)refresh:(AWaterfallTableView *)tableView;
/*!
 *  @abstract
 *  开始拉取更多触发的协议
 *  @discussion
 *
 *
 */
- (void)more:(AWaterfallTableView *)tableView;

@end
