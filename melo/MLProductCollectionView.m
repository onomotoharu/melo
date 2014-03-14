//
//  MLProductCollectionView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductCollectionView.h"

#import "MLProduct.h"
#import "MLProductCell.h"

@interface MLProductCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    @private
    NSMutableArray *_products;
}

@end

@implementation MLProductCollectionView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _products = [@[] mutableCopy];
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[MLProductCell class] forCellWithReuseIdentifier:@"MLProductCell"];
        [self setRefreshControl];
    }
    return self;
}

- (void)setRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshOccured:) forControlEvents:UIControlEventValueChanged];
    self.alwaysBounceVertical = YES;
    [self addSubview:refreshControl];
}

- (void)refreshOccured:(id)sender {
    [self refresh];
    [sender endRefreshing];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLProduct *product = _products[indexPath.row];
    NNLog(@"%@", product.id)
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

- (void)addProducts:(NSMutableArray *)products {
    [_products addObjectsFromArray:products];
    [self reloadData];
}

- (void)refresh {
}

@end
