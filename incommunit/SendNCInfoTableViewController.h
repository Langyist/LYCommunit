//
//  SendNCInfoTableViewController.h
//  incommunit
//
//  Created by 李忠良 on 14/11/4.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticCell : UITableViewCell

@end

@interface SendNCInfoTableViewController : UITableViewController
<
UIActionSheetDelegate
,UIImagePickerControllerDelegate
,UINavigationControllerDelegate
>
{
    NSString *m_classContent;
    NSString *m_titleContent;
    NSString *m_detailContent;
    NSString *m_contactStyleContent;
    NSString *m_contactContent;
    NSMutableArray *m_imageArray;

}

@end
