//
//  MLProductCollectionLayout.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductCollectionLayout.h"

NSInteger const MLProductCollectionCellWidth = 96;
NSInteger const MLProductCollectionCellHeight = 100;
NSInteger const MLProductCollectionheaderHeight = 20;
NSInteger const MLProductCollectionfooterHeight = 20;

@implementation MLProductCollectionLayout

-(id)init {
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
@end
