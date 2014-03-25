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
#import "MLModalViewController.h"
#import "MLWebViewController.h"
#import "MLTabViewController.h"

@interface MLProductViewController () {
    @private
    MLProduct *_product;
    MLProductView *_productView;
    MLProductCollectionView *_collectionView;
    BOOL _isFullScrean;
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
    
    self.title = @"melo"; // TODO : 一旦
    [self setRelationView];
    [self setProductView];
    [self getProduct];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setProductView {
    __weak MLProductViewController *weakSelf = self;
    _productView = [[MLProductView alloc] initWithFrame:CGRectMake(0, 0, NNViewWidth(self.view), 450)];
    [_productView setProduct:_product];
    _productView.delegate = weakSelf;
    [_collectionView addSubview:_productView];
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
        [self setRelations:responseObject[@"product"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *erroe) {
        [self failedGetProduct];
    }];
}

- (void)setProduct:(id)responseObject {
    [_product update:responseObject[@"product"]];
    [_productView setProduct:_product];
}

- (void)failedGetProduct {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"エラーにより情報を取得できませんでした。\n時間が経ってからもう一度おためしください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

//- (void)getRelations {
//    [MLProductController getRelations:_product.id parameters:@{@"page": @(0)}
//                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                  [self setRelations:responseObject];
//                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                              }];
//}

- (void)setRelations:(id)responseObject {
    if (responseObject[@"relationships"]) {
        [[MLProductManager sharedManager] setProducts:responseObject[@"relationships"] type:@"relations"];
        [_collectionView setProducts:[[MLProductManager sharedManager] getProducts:@"relations"]];
    }
}

#pragma mark - MLProductViewDelegate

- (void)pushUserName:(MLProductView *)view user:(MLUser *)user {
    MLUserViewController *userViewController = [[MLUserViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:userViewController animated:YES];
    [self showHeaderFooter:NO];
}

- (void)pushBuy:(MLProductView *)view urlString:(NSString *)urlString {
    MLWebViewController *webViewController = [[MLWebViewController alloc] initWithUrl:urlString];
    MLModalViewController *modalViewController = [[MLModalViewController alloc] initWithRootViewController:webViewController];
    [self.navigationController presentViewController:modalViewController animated:YES completion:nil];
}

#pragma mark - MLProductCollectionViewDelegate

- (void)didSelectItem:(MLProductCollectionView *)view product:(MLProduct *)product {
    MLProductViewController *productViewController = [[MLProductViewController alloc] initWithProduct:product];
    [self.navigationController pushViewController:productViewController animated:YES];
    [self showHeaderFooter:NO];
}

- (void)load:(NSInteger)type page:(NSInteger)page {
    [self getProduct];
}

- (void)scrollToUp:(MLProductCollectionView *)view {
    if (!_isFullScrean) {
        return;
    }
    _isFullScrean = NO;
    [self showHeaderFooter:YES];
}

- (void)scrollToDown:(MLProductCollectionView *)view {
    if (_isFullScrean) {
        return;
    }
    _isFullScrean = YES;
    [self hideHeaderFooter:YES];
}

- (void)showHeaderFooter:(BOOL)animation {
    MLTabViewController *tabViewController = (MLTabViewController *)[[MLGetAppDelegate window] rootViewController];
    if ([tabViewController respondsToSelector:@selector(setHiddenTabBar:animation:)]) {
        [tabViewController setHiddenTabBar:NO animation:animation];
    }
    //[self.navigationController setNavigationBarHidden:NO animated:animation];
}

- (void)hideHeaderFooter:(BOOL)animation {
    MLTabViewController *tabViewController = (MLTabViewController *)[[MLGetAppDelegate window] rootViewController];
    if ([tabViewController respondsToSelector:@selector(setHiddenTabBar:animation:)]) {
        [tabViewController setHiddenTabBar:YES animation:animation];
    }
    //[self.navigationController setNavigationBarHidden:YES animated:animation];
}

@end
