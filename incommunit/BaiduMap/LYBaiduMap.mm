//
//  LYBaiduMap.m
//  incommunit
//  百度地图界面
//  Created by LANGYI on 14/10/27.
//  Copyright (c) 2014年 LANGYI. All rights reserved.
//
#define BaidKey @"lK7gaSg80peIGLH15plumdwW"
#import "LYBaiduMap.h"
@interface LYBaiduMap ()
@end

@implementation LYBaiduMap
@synthesize m_mapview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [m_mapview viewWillAppear];
    m_mapview.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [m_mapview viewWillDisappear];
    m_mapview.delegate = nil; // 不用时，置nil
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
