//
//  MLProductCollectionView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLProduct;

@interface MLProductCollectionView : UICollectionView

@property (weak) id controllerDelegate;

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout fixed:(BOOL)fixed;

- (void)addProducts:(NSMutableArray *)products;
@end

@interface NSObject (MLProductCollectionViewDelegate)

- (void)didSelectItem:(MLProductCollectionView *)view product:(MLProduct *)product;

@end