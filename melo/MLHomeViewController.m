//
//  MLHomeViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLHomeViewController.h"

#import "MLProductManager.h"
#import "MLProductController.h"
#import "MLHomeTabView.h"
#import "MLProductCollectionView.h"
#import "MLProductCollectionLayout.h"
#import "MLProductViewController.h"
#import "MLNavigationViewController.h"
#import "MLTabViewController.h"

NSInteger const MLHomeTabViewHeight = 30;

@interface MLHomeViewController () <UIScrollViewDelegate>{
    @private
    NSInteger _activeTab;
    MLHomeTabView *_tabView;
    UIScrollView *_scrollView;
    NSMutableDictionary *_collectionViews;
    BOOL _isFullScrean;
}

@end

@implementation MLHomeViewController

- (id)init {
    self = [super init];
    if (self) {
        _collectionViews = [@{} mutableCopy];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"melo";
    [self setScrollView];
    [self setActiveTab:MLProductTypeHot];
    [self setTabView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController performSelector:@selector(createBarItemNotification)];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTabView {
    __weak MLHomeViewController *weakSelf = self;
    
    CGRect tabRect = CGRectMake(0, [MLDevice topMargin:YES], NNViewWidth(self.view), MLHomeTabViewHeight);
    _tabView = [[MLHomeTabView alloc] initWithFrame:tabRect];
    _tabView.delegate = weakSelf;
    [self.view addSubview:_tabView];
}

- (void)setScrollView {
    if (!_scrollView) {
        CGRect scrollViewRect = CGRectMake(0, 0, NNViewWidth(self.view), NNViewHeight(self.view));
        _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(NNViewWidth(_scrollView) * 3, _scrollView.contentSize.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
}

- (void)setCollectionView:(NSInteger)type {
    __weak MLHomeViewController *weakSelf = self;
    MLProductCollectionLayout *layout = [[MLProductCollectionLayout alloc] initTimeLineLayout];
    CGRect collectionRect = CGRectMake(NNViewWidth(_scrollView) * type, 0, NNViewWidth(_scrollView), NNViewHeight(_scrollView));
    MLProductCollectionView *collectionView = [[MLProductCollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout fixed:NO];
    collectionView.contentInset = UIEdgeInsetsMake(MLHomeTabViewHeight, 0, [MLDevice tabBarHeight], 0);
    collectionView.type = type;
    collectionView.controllerDelegate = weakSelf;
    [_scrollView addSubview:collectionView];
    [_collectionViews setObject:collectionView forKey:MLProductTypes[type]];
    [collectionView startIndicatorView];
}

- (void)getProducts:(NSInteger)type {
    [self load:type page:0];
}

- (void)load:(NSInteger)type page:(NSInteger)page {
    // TODO : fix
    NSString *typeString = MLProductTypes[type];
    if (type == MLProductTypeFollow) {
        typeString = @"";
    }
    [MLProductController getProducts:typeString parameters:@{@"page": @(page)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setProducts:responseObject type:type];
    } failure:^(AFHTTPRequestOperation *operation, NSError *erroe) {
        [self failedGetProducts:type];
    }];
}

- (void)setProducts:(id)responseObject type:(NSInteger)type {
    if (responseObject[@"products"]) {
        [[MLProductManager sharedManager] setProducts:responseObject[@"products"] type:MLProductTypes[type]];
        [[_collectionViews objectForKey:MLProductTypes[type]] setProducts:[[MLProductManager sharedManager] getProducts:MLProductTypes[type]]];
        [[_collectionViews objectForKey:MLProductTypes[type]] loaded:YES];
    }
}

- (void)failedGetProducts:(NSInteger)type {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"エラーにより情報を取得できませんでした。\n時間が経ってからもう一度おためしください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    [[_collectionViews objectForKey:MLProductTypes[type]] loaded:YES];
}

#pragma mark - MLProductCollectionViewDelegate

- (void)didSelectItem:(MLProductCollectionView *)view product:(MLProduct *)product {
    MLProductViewController *productViewController = [[MLProductViewController alloc] initWithProduct:product];
    [self.navigationController pushViewController:productViewController animated:YES];
    [self showHeaderFooter:NO];
}

#pragma mark - MLHomeTabViewDelegate

- (void)selectTab:(MLHomeTabView *)view tabNum:(NSInteger)tabNum {
    [self setActiveTab:tabNum];
}

- (void)setActiveTab:(NSInteger)activeTab {
    if (_activeTab == activeTab) {
        return;
    }
    _activeTab = activeTab;
    if (!_collectionViews[MLProductTypes[_activeTab]]) {
        [self setCollectionView:_activeTab];
        [self getProducts:activeTab];
    }
    [_scrollView setContentOffset:CGPointMake(NNViewWidth(_scrollView) * _activeTab, _scrollView.contentOffset.y) animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)endScroll {
    NSInteger activeTab = (NSInteger)(_scrollView.contentOffset.x / NNViewWidth(_scrollView));
    if (_activeTab == activeTab) {
        return;
    }
    [_tabView activeTab:activeTab];
    [self setActiveTab:activeTab];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self endScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if(!decelerate) {
		[self endScroll];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	[self endScroll];
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
    [self.navigationController setNavigationBarHidden:NO animated:animation];
    [_tabView setHidden:NO animated:animation];
}

- (void)hideHeaderFooter:(BOOL)animation {
    MLTabViewController *tabViewController = (MLTabViewController *)[[MLGetAppDelegate window] rootViewController];
    if ([tabViewController respondsToSelector:@selector(setHiddenTabBar:animation:)]) {
        [tabViewController setHiddenTabBar:YES animation:animation];
    }
    [self.navigationController setNavigationBarHidden:YES animated:animation];
    [_tabView setHidden:YES animated:animation];
}

@end
