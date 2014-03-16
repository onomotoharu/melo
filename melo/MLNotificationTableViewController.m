//
//  MLNotificationTableViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotificationTableViewController.h"

#import "MLNotification.h"
#import "MLNotificationManager.h"
#import "MLNotificationController.h"
#import "MLNotificationTableView.h"
#import "MLNotificationViewController.h"
#import "MLUserViewController.h"
#import "MLIndicator.h"

@interface MLNotificationTableViewController () {
    @private
    MLNotificationTableView *_notificationTableView;
}

@end

@implementation MLNotificationTableViewController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"お知らせ";
    [self setNotificationTableView];
    [self getNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNotificationTableView {
    __weak MLNotificationTableViewController *weakSelf = self;
    CGRect tableViewRect = CGRectMake(0, 0, NNViewWidth(self.view), NNViewHeight(self.view));
    _notificationTableView = [[MLNotificationTableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    _notificationTableView.controllerDelegate = weakSelf;
    [self.view addSubview:_notificationTableView];
}

- (void)setMessageLabel:(NSString *)message {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [MLDevice topMargin:self], NNViewWidth(self.view), 60)];
    messageLabel.text = message;
    messageLabel.font = [UIFont boldSystemFontOfSize:14];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:messageLabel];
}

- (void)getNotifications {
    [MLIndicator show:@""];
    [MLNotificationController getNotifications:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self successGetNotifications:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *erroe) {
        [self failuerGetNotifications];
    }];
}

- (void)successGetNotifications:(id)responseObject {
    [MLIndicator dissmiss];
    if (responseObject[@"notifications"]) {
        [[MLNotificationManager sharedManager] setNotifications:responseObject[@"notifications"]];
        [_notificationTableView setNotifications:[[MLNotificationManager sharedManager] getNotifications]];
    } else {
        [self setMessageLabel:@"現在お知らせはありません。"];
    }
}

- (void)failuerGetNotifications {
    [MLIndicator showErrorWithStatus:@"問題が発生してお知らせを取得できませんでした。"];
    [self setMessageLabel:@"お知らせの取得に失敗しました。"];
}

#pragma mark - MLNotificationTableViewDelegate

-  (void)didSelectRow:(MLNotificationTableView *)view notification:(MLNotification *)notification {
    switch ([notification.notificationType shortValue]) {
        case MLNotificationTypeInfo:
            [self.navigationController pushViewController:[[MLNotificationViewController alloc] initWithNotification:notification] animated:YES];
            break;
        case MLNotificationTypeWant:
        case MLNotificationTypeFollow:
            [self.navigationController pushViewController:[[MLUserViewController alloc] initWithUser:notification.actedUser] animated:YES];
            break;
        default:
            break;
    }
}
@end
