//
//  NCDetailTableViewController.h
//  incommunit
//
//  Created by 李忠良 on 14/11/3.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCDetailTableViewController : UITableViewController
{
    NSDictionary *m_detailData;
}
-(void)setDetailData:(NSDictionary*)dictionary;

@end
