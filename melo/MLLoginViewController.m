//
//  MLLoginViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/12.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLLoginViewController.h"

#import "MLLoginView.h"
#import "MLStartFollowViewController.h"

@interface MLLoginViewController ()

@end

@implementation MLLoginViewController

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    __weak MLLoginViewController *weakSelf = self;
    MLLoginView *loginView = [[MLLoginView alloc] initWithFrame:self.view.frame delegate:weakSelf];
    [self.view addSubview:loginView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MLLoginViewDelegate

- (void)start:(MLLoginView *)view {
    MLStartFollowViewController *startFollowController = [MLStartFollowViewController new];
    [self.navigationController pushViewController:startFollowController animated:YES];
}

@end
