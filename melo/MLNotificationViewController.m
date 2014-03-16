//
//  MLNotificationViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotificationViewController.h"

#import "MLNotification.h"
#import "MLNotificationView.h"

@interface MLNotificationViewController () {
    @private
    MLNotification *_notification;
}

@end

@implementation MLNotificationViewController

- (id)initWithNotification:(MLNotification *)notification {
    self = [super init];
    if (self) {
        _notification = notification;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"お知らせ";
    [self setNotificationView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNotificationView {
    CGRect scrollViewRect = CGRectMake(0, 0, NNViewWidth(self.view), NNViewHeight(self.view));
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
    
    MLNotificationView *notificationView = [[MLNotificationView alloc] initWithFrame:scrollViewRect detail:_notification.detail];
    [self.view addSubview:scrollView];
    [scrollView addSubview:notificationView];
    
    // set contentSize
    int contentHeight = NNViewHeight(scrollView) - [MLDevice topMargin:self] - [MLDevice tabBarHeight] + 1;
    if (contentHeight > NNViewHeight(notificationView)) {
        scrollView.contentSize = CGSizeMake(NNViewWidth(scrollView), contentHeight);
    } else {
        scrollView.contentSize = CGSizeMake(NNViewWidth(scrollView), NNViewHeight(notificationView));
    }
}

@end
