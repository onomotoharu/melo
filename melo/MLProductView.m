//
//  MLProductView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductView.h"

#import "MLProduct.h"
#import "MLImageManager.h"
#import "MLNotification.h"
#import "SDWebImage/UIImageView+WebCache.h"

NSInteger const MLProductViewWidth = 100;
NSInteger const MLProductViewHeight = 100;

@interface MLProductView () {
    @private
    MLProduct *_product;
    UIActivityIndicatorView *_indicatorView;
    UIImageView *_imageView;
}

@end

@implementation MLProductView

+ (CGFloat)margin {
    return (CGRectGetWidth([[UIScreen mainScreen] bounds]) - MLProductViewHeight * 3) / 4;
}

- (id)initWithFrame:(CGRect)frame product:(MLProduct *)product {
    CGSize size = {MLProductViewWidth, MLProductViewHeight};
    frame.size = size;
    self = [super initWithFrame:frame];
    if (self) {
        _product = product;
        self.backgroundColor = [UIColor blackColor];
        [self setImageView];
        [self performSelectorInBackground:@selector(loadImage) withObject:nil];
    }
    return self;
}

- (void)setImageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, NNViewWidth(self), NNViewHeight(self))];
        [self addSubview:_imageView];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.frame = CGRectMake((NNViewWidth(self) - 50) / 2, (NNViewHeight(self) - 50) / 2, 50, 50);
        [_imageView addSubview:_indicatorView];
        [_indicatorView startAnimating];
    }
}

- (void)loadImage {
    NSString *url = _product.image;
    if (!url) {
        [_indicatorView stopAnimating];
        return;
    }
    [_indicatorView startAnimating];
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    // TODO : observer検討
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MLNotification registerGetImageNotification:self url:url];
    
    [imageManager.imageCache queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            _imageView.image = image;
            [_indicatorView stopAnimating];
        } else {
            [[MLImageManager sharedManager] load:url];
        }
    }];
}

- (void)loadedImage:(NSNotification *)n {
    [self performSelectorOnMainThread:@selector(_loadedImage:) withObject:[n userInfo][@"image"] waitUntilDone:YES];
}

- (void)_loadedImage:(UIImage *)image {
    [_indicatorView stopAnimating];
    [_imageView setImage:image];
}

@end
