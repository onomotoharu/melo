//
//  MLTabViewController.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLTabViewController : UIViewController

@property (nonatomic) NSArray *viewControllers;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) UIViewController *selectedViewController;
@property (nonatomic) NSMutableArray *items;

- (void)setHiddenTabBar:(BOOL)hide animation:(BOOL)animation;
@end
