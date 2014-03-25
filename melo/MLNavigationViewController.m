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
#import "UIImage+Addition.h"
#import "UIColor+Addition.h"

@interface MLNavigationViewController () {
    @private
    UIImage *_backImage;
}

@end

@implementation MLNavigationViewController

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderTitleFont];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Header

- (void)setHeaderTitleFont {
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor baseBlueColor],
                                               NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:20]};
}

#pragma mark - BarItem

- (void)createBarItemNotification {
    // TODO : fix name
    UIImage *buttonImage = [UIImage getPngImage:@"TabBar-notification"];
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [customButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(showNotification:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count <= 1 ) {
        return;
    }
//    if (!_backImage) {
//        _backImage = [UIImage getPngImage:@"NavBar-backButtonHover"];
//    }
//    UIButton *customView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _backImage.size.width, _backImage.size.height)];
//    [customView setBackgroundImage:_backImage forState:UIControlStateNormal];
//    [customView addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
//    
//    viewController.navigationItem.leftBarButtonItem = buttonItem;
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
