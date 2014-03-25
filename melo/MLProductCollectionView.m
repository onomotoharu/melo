//
//  MLProductCollectionView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductCollectionView.h"

#import "MLProductCell.h"

NSInteger MLProductionCollectionViewLoadMargin = 30;

typedef enum {
    MLProductCollectionUnLoad = 0,
    MLProductCollectionLoading = 1,
    MLProductCollectionLoaded = 2,
    MLProductCollectionCompleteLoaded
} MLProductCollectionLoadState;

@interface MLProductCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    @private
    NSInteger _loadState;
    NSMutableArray *_products;
    CGFloat _startScrollContentY;
    UIActivityIndicatorView *_indicatorView;
}

@end

@implementation MLProductCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout fixed:(BOOL)fixed {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _products = [@[] mutableCopy];
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[MLProductCell class] forCellWithReuseIdentifier:@"MLProductCell"];
        if (!fixed) {
            [self setRefreshControl];
        }
    }
    return self;
}

- (void)setRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshOccured:) forControlEvents:UIControlEventValueChanged];
    self.alwaysBounceVertical = YES;
    [self addSubview:refreshControl];
}

- (void)startIndicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(0, 0, 50, 50);
        self.contentInset = UIEdgeInsetsMake(self.contentInset.top, 0, self.contentInset.bottom + 50, 0);
        [self.superview.superview addSubview:_indicatorView];
         _indicatorView.center = CGPointMake(NNViewWidth(self) / 2, NNViewHeight(self) - NNViewHeight(_indicatorView) - 20);
    }
}

- (void)refreshOccured:(id)sender {
    [self refresh];
    [sender endRefreshing];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MLProduct *product = _products[indexPath.row];
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(didSelectItem:product:)]) {
        [_controllerDelegate didSelectItem:self product:product];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _products.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MLProductCell" forIndexPath:indexPath];
    [cell setProduct:_products[indexPath.row]];
    
    return cell;
}

#pragma mark - MLProductCollectionView Method

- (void)setProducts:(NSMutableArray *)products {
    _products = products;
    [self reloadData];
    [_indicatorView stopAnimating];
}

- (void)loadProducts:(NSInteger)page {
    [_indicatorView startAnimating];
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(load:page:)]) {
        [_controllerDelegate load:_type page:page];
    }
}

- (void)loaded:(BOOL)isComplete {
    if (isComplete) {
        _loadState = MLProductCollectionCompleteLoaded;
    } else {
        _loadState = MLProductCollectionLoaded;
    }
}

- (void)refresh {
    _loadState = MLProductCollectionLoading;
    [_products removeAllObjects];
    [self reloadData];
    [self loadProducts:1];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + NNViewHeight(self) > scrollView.contentSize.height - MLProductionCollectionViewLoadMargin && _loadState != MLProductCollectionLoading) {
        _loadState = MLProductCollectionLoading;
        [self loadProducts:_products.count / 30 + 1]; // TODO : fix
    } else if (scrollView.contentOffset.y < 0 && scrollView.contentOffset.y < _startScrollContentY) {
        if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(scrollToUp:)]) {
            [_controllerDelegate scrollToUp:self];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < _startScrollContentY) {
        if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(scrollToUp:)]) {
            [_controllerDelegate scrollToUp:self];
        }
    } else {
        if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(scrollToDown:)]) {
            [_controllerDelegate scrollToDown:self];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startScrollContentY = scrollView.contentOffset.y;
}

@end
