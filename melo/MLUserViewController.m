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
#import "MLUserView.h"
#import "MLProductCollectionView.h"
#import "MLProductCollectionLayout.h"
#import "MLProductViewController.h"

@interface MLUserViewController () {
    @private
    MLUser *_user;
    MLProductCollectionView *_collectionView;
}

@end

@implementation MLUserViewController

- (id)initWithUser:(MLUser *)user {
    self = [super init];
    if (self) {
        _user = user;
        self.view.backgroundColor = [UIColor whiteColor];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self setCollectionView];
    [self setUserView];
    //[self getWants];
    [self getPosts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUserView {
    CGRect userViewRect = CGRectMake(0, 0, NNViewWidth(self.view), [MLUserView height]);
    MLUserView *userView = [[MLUserView alloc] initWithFrame:userViewRect];
    [userView setUser:_user];
    [_collectionView addSubview:userView];
}

- (void)setCollectionView {
    __weak MLUserViewController *weakSelf = self;
    MLProductCollectionLayout *layout = [[MLProductCollectionLayout alloc] initLayoutWithTopMargin:[MLUserView height]];
    CGRect collectionRect = CGRectMake(0, 0, NNViewWidth(self.view), NNViewHeight(self.view));
    _collectionView = [[MLProductCollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout fixed:NO];
    _collectionView.controllerDelegate = weakSelf;
    [self.view addSubview:_collectionView];
}

#pragma mark - Want

- (void)getWants {
    [MLProductController getWants:@{@"page": @(0)}
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [self setWants:responseObject];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *erroe) {
                              }];
}

- (void)setWants:(id)responseObject {
    if (responseObject[@"user_products"]) {
        [[MLProductManager sharedManager] setProducts:responseObject[@"user_products"] type:@"wants"];
        [_collectionView addProducts:[[MLProductManager sharedManager] getProducts:@"wants"]];
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
        [_collectionView addProducts:[[MLProductManager sharedManager] getProducts:@"posts"]];
    }
}

#pragma mark - MLProductCollectionViewDelegate

- (void)didSelectItem:(MLProductCollectionView *)view product:(MLProduct *)product {
    MLProductViewController *productViewController = [[MLProductViewController alloc] initWithProduct:product];
    [self.navigationController pushViewController:productViewController animated:YES];
}

@end
