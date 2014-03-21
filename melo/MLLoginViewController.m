//
//  MLLoginViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/12.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLLoginViewController.h"

#import "MLUserController.h"
#import "MLLoginView.h"
#import "MLStartFollowViewController.h"
#import "MLIndicator.h"

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
    [MLIndicator show:@"サインアップ中"];
    [MLUserController signup:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self successSignup:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failureSigup];
    }];
    
}

- (void)successSignup:(id)responseObject {
    if (!responseObject[@"user"] || !responseObject[@"user"][@"uuid"]) {
        [self failureSigup];
        return;
    }
    [MLIndicator dissmiss];
    [MLCurrentUser setUUID:responseObject[@"user"][@"uuid"]];
    MLStartFollowViewController *startFollowController = [MLStartFollowViewController new];
    [self.navigationController pushViewController:startFollowController animated:YES];
}

- (void)failureSigup {
    [MLIndicator showErrorWithStatus:@"問題が起きてサインアップに失敗しました。"];
}

@end
