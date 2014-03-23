//
//  MLProductPhotosView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/23.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLProductPhotosView : UICollectionView

@property (weak) id controllerDelegate;

- (void)setPhotos:(NSMutableArray *)photos;
@end

@interface NSObject (MLProductPhotosViewDelegate)

- (void)selectedPhoto:(MLProductPhotosView *)view imageUrlString:(NSString *)imageUrlString;

@end
