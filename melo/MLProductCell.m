//
//  MLProductCell.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductCell.h"

#import "MLImageManager.h"
#import "MLNotificationCenter.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MLProductCell () {
    @private
    MLProduct *_product;
    UIImageView *_imageView;
    UIActivityIndicatorView *_indicatorView;
}

@end

@implementation MLProductCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]]; // TODO : 修正
        [self setImageView];
    }
    return self;
}

- (void)setProduct:(MLProduct *)product {
    _product = product;
    [self loadImage];
}

- (void)setImageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, NNViewWidth(self), NNViewHeight(self))];
        [self.contentView addSubview:_imageView];
        
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
    [MLNotificationCenter registerGetImageNotification:self url:url];
    
    [imageManager.imageCache queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            _imageView.image = image;
            [_indicatorView stopAnimating];
        } else {
            [[MLImageManager sharedManager] performSelectorInBackground:@selector(load:) withObject:url];
        }
    }];
}

- (void)loadedImage:(NSNotification *)n {
    [self performSelectorOnMainThread:@selector(_loadedImage:) withObject:[n userInfo][@"image"] waitUntilDone:YES];
}

- (void)_loadedImage:(UIImage *)image {
    [_indicatorView stopAnimating];
    _imageView.alpha = 0;
    [_imageView setImage:image];
    [UIView animateWithDuration:0.5 animations:^{
        _imageView.alpha = 1;
    }];
    [_imageView setImage:image];
}

@end
