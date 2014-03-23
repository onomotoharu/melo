//
//  MLProductPhotosView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/23.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductPhotosView.h"

#import "MLPhotoCell.h"

@interface MLProductPhotosView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    @private
    NSMutableArray *_photos;
}

@end

@implementation MLProductPhotosView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _photos = [@[] mutableCopy];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[MLPhotoCell class] forCellWithReuseIdentifier:@"MLPhotoCell"];
    }
    return self;
}

#pragma mark - MLProductCollectionView Method

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    [self reloadData];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(selectedPhoto:imageUrlString:)]) {
        [_controllerDelegate selectedPhoto:self imageUrlString:_photos[indexPath.row][@"image_url"]];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MLPhotoCell" forIndexPath:indexPath];
    [cell setUrlString:_photos[indexPath.row][@"image_url"]];
    
    return cell;
}

@end
