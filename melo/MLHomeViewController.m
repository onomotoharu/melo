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

NSInteger const MLHomeTabViewHeight = 44;

@interface MLHomeViewController () <UIScrollViewDelegate>{
    @private
    NSInteger _activeTab;
    MLHomeTabView *_tabView;
    UIScrollView *_scrollView;
    NSMutableDictionary *_collectionViews;
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
    
    [self setTabView];
    [self setScrollView];
    [self setActiveTab:MLProductTypeHot];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTabView {
    __weak MLHomeViewController *weakSelf = self;
    
    CGRect tabRect = CGRectMake(0, [MLDevice topMargin:self], NNViewWidth(self.view), MLHomeTabViewHeight);
    _tabView = [[MLHomeTabView alloc] initWithFrame:tabRect];
    _tabView.delegate = weakSelf;
    [self.view addSubview:_tabView];
}

- (void)setScrollView {
    if (!_scrollView) {
        CGRect scrollViewRect = CGRectMake(0, [MLDevice topMargin:self] + MLHomeTabViewHeight, NNViewWidth(self.view), NNViewHeight(self.view) - ([MLDevice topMargin:self] + MLHomeTabViewHeight + 49));
        _scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(NNViewWidth(_scrollView) * 3, NNViewHeight(_scrollView));
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
}

- (void)setCollectionView:(NSInteger)type {
    MLProductCollectionLayout *layout = [MLProductCollectionLayout new];
    CGRect collectionRect = CGRectMake(NNViewWidth(_scrollView) * type, 0, NNViewWidth(_scrollView), NNViewHeight(_scrollView));
    MLProductCollectionView *collectionView = [[MLProductCollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout];
    [_scrollView addSubview:collectionView];
    [_collectionViews setObject:collectionView forKey:MLProductTypes[type]];
}

- (void)getProducts:(NSInteger)type {
    [MLProductController getProducts:MLProductTypes[type] parameters:@{@"page": @(0)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setProducts:responseObject type:type];
    } failure:^(AFHTTPRequestOperation *operation, NSError *erroe) {
        [self failedGetProducts];
    }];
}

- (void)setProducts:(id)responseObject type:(NSInteger)type {
    NNLog(@"%@", responseObject)
    if (responseObject[@"products"]) {
        [[MLProductManager sharedManager] setProducts:responseObject[@"products"] type:@"hot"];
        [[_collectionViews objectForKey:MLProductTypes[type]] addProducts:[[MLProductManager sharedManager] getProducts:@"hot"]];
    }
}

- (void)failedGetProducts {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"エラーにより情報を取得できませんでした。\n時間が経ってからもう一度おためしください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
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
    [_scrollView setContentOffset:CGPointMake(NNViewWidth(_scrollView) * _activeTab, 0) animated:NO];
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

@end
