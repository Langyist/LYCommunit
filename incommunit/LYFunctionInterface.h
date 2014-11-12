//
//  LYFunctionInterface.h
//  incommunit
//  功能主界面
//  Created by LANGYI on 14/10/26.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AsyncDownload.h"
@interface LYFunctionInterface : UIViewController<UITabBarDelegate,UIScrollViewDelegate,UIPageViewControllerDelegate,UIApplicationDelegate>
{
    UITabBar            * bar;
    @public NSString    *m_Community_ID;
    NSArray             *m_picearry;
    UIImageView         *m_imageView;
    UIPageControl       *m_page;
    UIScrollView        *m_imageScrollView;
    int                 m_timer;
    UIView *            m_View;
    @public BOOL        *Tourist ;
    
    
}
@property(nonatomic, retain)IBOutlet UITabBar       *bar;
@property(nonatomic,retain)IBOutlet UIImageView     *m_imageView;
@property (strong, nonatomic)IBOutlet UIPageControl *m_page;
@property (nonatomic,retain)IBOutlet UIScrollView  *m_imageScrollView;
@property (nonatomic,retain)IBOutlet UIView  *m_View;
+(void)Setcommunitinfo :(NSDictionary *)dic;
+(NSDictionary *)Getcommunitinfo;

+(NSMutableArray *)Getorder;

@end
