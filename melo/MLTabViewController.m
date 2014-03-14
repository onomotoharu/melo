//
//  MLTabViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLTabViewController.h"

@interface MLTabViewController ()

@end

@implementation MLTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTabBarItems {
    NSArray *itemTitles = @[@"home", @"post", @"mypage"];
    for (int i = 0; i < itemTitles.count; i++) {
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        item.title = itemTitles[i];
    }
}

@end
