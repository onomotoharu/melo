//
//  MLNavigationViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/12.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNavigationViewController.h"

#import "MLNotificationTableViewController.h"
#import "MLSettingViewController.h"

@interface MLNavigationViewController ()

@end

@implementation MLNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - BarItem

- (void)createBarItemNotification {
    UIBarButtonItem* rightItem =
    [[UIBarButtonItem alloc] initWithTitle:@"通知"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(showNotification:)];
    self.topViewController.navigationItem.rightBarButtonItem = rightItem;
}

- (void)createBarItemSetting {
    UIBarButtonItem* rightItem =
    [[UIBarButtonItem alloc] initWithTitle:@"設定"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(showSetting:)];
    self.topViewController.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - ButtonAction

- (void)showNotification:(id)sender {
    MLNotificationTableViewController *notificationViewController = [MLNotificationTableViewController new];
    [self pushViewController:notificationViewController animated:YES];
}

- (void)showSetting:(id)sender {
    MLSettingViewController *settingViewController = [MLSettingViewController new];
    [self pushViewController:settingViewController animated:YES];
}

@end
