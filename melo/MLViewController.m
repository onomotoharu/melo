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
#import "MLStartFollowViewController.h"
#import "MLHomeViewController.h"
#import "MLUserViewController.h"

@implementation MLViewController

+ (void)setRootViewController {
    switch ([MLCurrentUser state]) {
        case MLUserStateNew:
            [self setLoginViewController];
            break;
        case MLUserStateSingup:
            [self setStartFollowViewController];
            break;
        case MLUserStateLogin:
            [self setHomeViewController];
            break;
        default:
            [MLAlert showSingleAlert:@"エラー" message:@"問題が発生しました。\nお手数ですがアプリの再起動をお願いします。"];
            break;
    }
}

+ (void)setLoginViewController {
    MLLoginViewController *loginViewController = [MLLoginViewController new];
    MLNavigationViewController *navigationViewController = [[MLNavigationViewController alloc] initWithRootViewController:loginViewController];
    ((MLAppDelegate *)MLGetAppDelegate).window.rootViewController = navigationViewController;
}

+ (void)setStartFollowViewController {
    MLStartFollowViewController *startViewController = [MLStartFollowViewController new];
    MLNavigationViewController *navigationViewController = [[MLNavigationViewController alloc] initWithRootViewController:startViewController];
    ((MLAppDelegate *)MLGetAppDelegate).window.rootViewController = navigationViewController;
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
