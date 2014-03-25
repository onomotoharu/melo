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
    MLNavigationViewController *homeNavigationController = [[MLNavigationViewController alloc] initWithRootViewController:homeViewController];
    
    MLUserViewController *userViewController = [[MLUserViewController alloc] initWithUser:[MLCurrentUser currentuser]];
    MLNavigationViewController *userNavigationController = [[MLNavigationViewController alloc] initWithRootViewController:userViewController];
    
    MLTabViewController *tabBarController = [[MLTabViewController alloc] init];
    NSArray *tabs = @[homeNavigationController, [NSNull null], userNavigationController];
    [tabBarController setViewControllers:tabs];
    ((MLAppDelegate *)MLGetAppDelegate).window.rootViewController = tabBarController;
}

@end
