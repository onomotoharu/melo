//
//  MLProductViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductViewController.h"

#import "MLProductManager.h"
#import "MLProductController.h"
#import "MLProductView.h"
#import "MLProductCollectionView.h"
#import "MLProductCollectionLayout.h"
#import "MLUserViewController.h"

@interface MLProductViewController () {
    @private
    MLProduct *_product;
    MLProductCollectionView *_collectionView;
}

@end

@implementation MLProductViewController

- (id)initWithProduct:(MLProduct *)product {
    self = [super init];
    if (self) {
        _product = product;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRelationView];
    [self getProduct];
    [self getRelations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProductView {
    __weak MLProductViewController *weakSelf = self;
    MLProductView *productView = [[MLProductView alloc] initWithFrame:CGRectMake(0, 0, NNViewWidth(self.view), 450)];
    [productView setProduct:_product];
    productView.delegate = weakSelf;
    [_collectionView addSubview:productView];
}

- (void)setRelationView {
    __weak MLProductViewController *weakSelf = self;
    MLProductCollectionLayout *layout = [[MLProductCollectionLayout alloc] initLayoutWithTopMargin:450];
    CGRect collectionRect = CGRectMake(0, 0, NNViewWidth(self.view), NNViewHeight(self.view));
    _collectionView = [[MLProductCollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout fixed:NO];
    _collectionView.controllerDelegate = weakSelf;
    [self.view addSubview:_collectionView];
}

- (void)getProduct {
    if (!_product.id) {
        [self failedGetProduct];
        return;
    }
    [MLProductController getProduct:_product.id success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setProduct:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *erroe) {
        [self failedGetProduct];
    }];
}

- (void)setProduct:(id)responseObject {
    [_product update:responseObject[@"product"]];
    [self setProductView];
}

- (void)failedGetProduct {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"エラーにより情報を取得できませんでした。\n時間が経ってからもう一度おためしください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)getRelations {
    [MLProductController getRelations:_product.id
                           parameters:@{@"page": @(0)}
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [self setRelations:responseObject];
                              } failure:^(AFHTTPRequestOperation *operation, NSError *erroe) {
                              }];
}

- (void)setRelations:(id)responseObject {
    if (responseObject[@"products"]) {
        [[MLProductManager sharedManager] setProducts:responseObject[@"products"] type:@"relations"];
        [_collectionView addProducts:[[MLProductManager sharedManager] getProducts:@"relations"]];
    }
}

#pragma mark - MLProductViewDelegate

- (void)pushUserName:(MLProductView *)view userId:(NSNumber *)userId {
    MLUserViewController *userViewController = [MLUserViewController new];
    [self.navigationController pushViewController:userViewController animated:YES];
}

#pragma mark - MLProductCollectionViewDelegate

- (void)didSelectItem:(MLProductCollectionView *)view product:(MLProduct *)product {
    MLProductViewController *productViewController = [[MLProductViewController alloc] initWithProduct:product];
    [self.navigationController pushViewController:productViewController animated:YES];
}

@end
