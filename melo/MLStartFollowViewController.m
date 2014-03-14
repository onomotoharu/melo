//
//  MLStartFollowViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLStartFollowViewController.h"

#import "MLStartFollowView.h"
#import "MLHomeViewController.h"

@interface MLStartFollowViewController ()

@end

@implementation MLStartFollowViewController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak MLStartFollowViewController *weakSelf = self;
    MLStartFollowView *startFollowView = [[MLStartFollowView alloc] initWithFrame:self.view.frame delegate:weakSelf];
    [self.view addSubview:startFollowView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MLStartFollowViewDelegate

- (void)complete {
    MLHomeViewController *homeViewController = [MLHomeViewController new];
    [self.navigationController pushViewController:homeViewController animated:YES];
    self.navigationController.viewControllers = [[NSArray alloc] initWithObjects:homeViewController, nil]; // clear stack
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"welcome to melo" message:@"ようこそmeloへ" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    [MLUserDefaults setIsNewUser:YES];
}

@end
