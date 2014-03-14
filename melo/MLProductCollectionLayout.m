//
//  MLProductCollectionLayout.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductCollectionLayout.h"

NSInteger const MLProductCollectionCellWidth = 96;
NSInteger const MLProductCollectionCellHeight = 96;
NSInteger const MLProductCollectionheaderHeight = 20;
NSInteger const MLProductCollectionfooterHeight = 20;

@implementation MLProductCollectionLayout

- (id)initTimeLineLayout {
    self = [super init];
    if (self) {
        CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat space = (width - MLProductCollectionCellWidth * 3) / 4;
        self.itemSize = CGSizeMake(MLProductCollectionCellWidth, MLProductCollectionCellHeight);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
        self.headerReferenceSize = CGSizeMake(width, MLProductCollectionheaderHeight);
        self.footerReferenceSize = CGSizeMake(width, MLProductCollectionfooterHeight);
        self.minimumInteritemSpacing = space;
        self.minimumLineSpacing = space;
    }
    return self;
}

- (id)initDisplayLayout {
    self = [super init];
    if (self) {
        CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        CGFloat space = (width - MLProductCollectionCellWidth * 3) / 4;
        self.itemSize = CGSizeMake(MLProductCollectionCellWidth, MLProductCollectionCellHeight);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(0, space, 0, space);
        self.minimumInteritemSpacing = space;
        self.minimumLineSpacing = space;
    }
    return self;
}

- (id)initRelationLayout {
    self = [self initTimeLineLayout];
    self.headerReferenceSize = CGSizeMake(self.headerReferenceSize.width, self.headerReferenceSize.height + 450);
    return self;
}

@end
