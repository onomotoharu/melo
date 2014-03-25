//
//  MLProductCollectionView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLProductCollectionView : UICollectionView

@property (nonatomic) NSInteger type;
@property (weak) id controllerDelegate;

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout fixed:(BOOL)fixed;

- (void)setProducts:(NSMutableArray *)products;

- (void)loaded:(BOOL)isComplete;
- (void)startIndicatorView;
@end

@interface NSObject (MLProductCollectionViewDelegate)

- (void)load:(NSInteger)type page:(NSInteger)page;
- (void)didSelectItem:(MLProductCollectionView *)view product:(MLProduct *)product;
- (void)scrollToUp:(MLProductCollectionView *)view;
- (void)scrollToDown:(MLProductCollectionView *)view;

@end