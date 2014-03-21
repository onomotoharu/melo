//
//  MLModalViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/21.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLModalViewController.h"

@interface MLModalViewController ()

@end

@implementation MLModalViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:nil];
    if (self) {
        self.viewControllers = @[rootViewController];
    }
    return self;
}

- (void)dealloc {
    NNLog(@"dealloc")
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initCloseBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initCloseBtn {
    UIBarButtonItem* leftItem =
    [[UIBarButtonItem alloc] initWithTitle:@"閉じる"
                                     style:UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(close)];
    self.topViewController.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - ButtonAction

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
