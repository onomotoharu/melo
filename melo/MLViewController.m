//
//  MLViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLViewController.h"

#import "MLTabViewController.h"
#import "MLNavigationViewController.h"
#import "MLLoginViewController.h"
#import "MLHomeViewController.h"
#import "MLUserViewController.h"

@implementation MLViewController

+ (void)setRootViewController {
    // TODO : あとで修正
    if ([MLUserDefaults getIsNewUser]) {
        [self setHomeViewController];
    } else {
        MLLoginViewController *loginViewController = [MLLoginViewController new];
        MLNavigationViewController *navigationViewController = [[MLNavigationViewController alloc] initWithRootViewController:loginViewController];
        ((MLAppDelegate *)MLGetAppDelegate).window.rootViewController = navigationViewController;
    }

//    NSArray *tabs = [NSArray navigationController1, navigationController2, nil];
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    [tabBarController setViewControllers:tabs animated:NO];
//    [self.window addSubview:tabBarController.view];
//    self.window.rootViewController = tabBarController;
}

+ (void)setHomeViewController {
    MLHomeViewController *homeViewController = [MLHomeViewController new];
    MLNavigationViewController *navigationController = [[MLNavigationViewController alloc] initWithRootViewController:homeViewController];
    
    // TODO : fix
    UIViewController *viewController = [UIViewController new];
    MLNavigationViewController *navigationController2 = [[MLNavigationViewController alloc] initWithRootViewController:viewController];
    
    MLUserViewController *userViewController = [[MLUserViewController alloc] initWithUser:[MLCurrentUser currentuser]];
    MLNavigationViewController *navigationController3 = [[MLNavigationViewController alloc] initWithRootViewController:userViewController];
    
    NSArray *tabs = @[navigationController, navigationController2, navigationController3];
    MLTabViewController *tabBarController = [[MLTabViewController alloc] init];
    [tabBarController setViewControllers:tabs];
    ((MLAppDelegate *)MLGetAppDelegate).window.rootViewController = tabBarController;
    [tabBarController setTabBarItems];
}

@end
