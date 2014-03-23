//
//  MLProductPhotosCollectionLayout.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/23.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductPhotosCollectionLayout.h"

NSInteger const MLProductPhotosCollectionCellWidth = 145;
NSInteger const MLProductPhotosCollectionCellHeight = 119;
NSInteger const MLProductPhotosCollectionheaderHeight = 20;
NSInteger const MLProductPhotosCollectionfooterHeight = 20;

@implementation MLProductPhotosCollectionLayout

- (id)init {
    self = [super init];
    if (self) {
        CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat space = (width - MLProductPhotosCollectionCellWidth * 2) / 3;
        self.itemSize = CGSizeMake(MLProductPhotosCollectionCellWidth, MLProductPhotosCollectionCellHeight);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
        self.headerReferenceSize = CGSizeMake(width, MLProductPhotosCollectionheaderHeight);
        self.footerReferenceSize = CGSizeMake(width, MLProductPhotosCollectionfooterHeight);
        self.minimumInteritemSpacing = space;
        self.minimumLineSpacing = space;
    }
    return self;
}

@end
