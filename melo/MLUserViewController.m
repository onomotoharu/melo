//
//  MLUserViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLUserViewController.h"

#import "MLProductManager.h"
#import "MLProductController.h"
#import "MLUserController.h"
#import "MLUserView.h"
#import "MLProductCollectionView.h"
#import "MLProductCollectionLayout.h"
#import "MLProductViewController.h"
#import "MLNavigationViewController.h"

@interface MLUserViewController () {
    @private
    MLUser *_user;
    MLUserView *_userView;
    MLProductCollectionView *_collectionView;
}

@end

@implementation MLUserViewController

- (id)initWithUser:(MLUser *)user {
    self = [super init];
    if (self) {
        _user = user;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self setCollectionView];
    [self setUserView];
    [self getAccount];
    //[self getWants];
    //[self getPosts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController performSelector:@selector(createBarItemSetting)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUserView {
    CGRect userViewRect = CGRectMake(0, 0, NNViewWidth(self.view), [MLUserView height]);
    _userView = [[MLUserView alloc] initWithFrame:userViewRect];
    [_userView setUser:_user];
    [_collectionView addSubview:_userView];
}

- (void)setCollectionView {
    __weak MLUserViewController *weakSelf = self;
    MLProductCollectionLayout *layout = [[MLProductCollectionLayout alloc] initLayoutWithTopMargin:[MLUserView height]];
    CGRect collectionRect = CGRectMake(0, 0, NNViewWidth(self.view), NNViewHeight(self.view));
    _collectionView = [[MLProductCollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout fixed:NO];
    _collectionView.controllerDelegate = weakSelf;
    [self.view addSubview:_collectionView];
}

#pragma mark - User

- (void)getAccount {
    [MLUserController getAccount:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MLCurrentUser update:responseObject[@"user"]];
        [_userView updateUser];
        [self setPosts:responseObject[@"user"]];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark - Want

- (void)getWants {
    [MLProductController getWants:@{@"page": @(0)}
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [self setWants:responseObject];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              }];
}

- (void)setWants:(id)responseObject {
    if (responseObject[@"user_products"]) {
        [[MLProductManager sharedManager] setProducts:responseObject[@"user_products"] type:@"wants"];
        [_collectionView setProducts:[[MLProductManager sharedManager] getProducts:@"wants"]];
    }
}

#pragma mark - Posts

- (void)getPosts {
    [MLProductController getPosts:_user.id
                       parameters:@{@"page": @(0)}
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [self setPosts:responseObject];
                          } failure:^(AFHTTPRequestOperation *operation, NSError *erroe) {
                          }];
}

- (void)setPosts:(id)responseObject {
    if (responseObject[@"products"]) {
        [[MLProductManager sharedManager] setProducts:responseObject[@"products"] type:@"posts"];
        [_collectionView setProducts:[[MLProductManager sharedManager] getProducts:@"posts"]];
    }
}

#pragma mark - MLProductCollectionViewDelegate

- (void)didSelectItem:(MLProductCollectionView *)view product:(MLProduct *)product {
    MLProductViewController *productViewController = [[MLProductViewController alloc] initWithProduct:product];
    [self.navigationController pushViewController:productViewController animated:YES];
}

@end
