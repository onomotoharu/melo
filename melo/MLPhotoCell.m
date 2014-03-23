//
//  MLPhotoCell.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/23.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLPhotoCell.h"

#import "MLImageManager.h"
#import "MLNotificationCenter.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MLPhotoCell () {
    @private
    UIImageView *_imageView;
    UIActivityIndicatorView *_indicatorView;
    NSString *_urlString;
}

@end

@implementation MLPhotoCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setImageView];
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    [self loadImage];
}

// TODO : module化
- (void)setImageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, NNViewWidth(self), NNViewHeight(self))];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.frame = CGRectMake((NNViewWidth(self) - 50) / 2, (NNViewHeight(self) - 50) / 2, 50, 50);
        [_imageView addSubview:_indicatorView];
        [_indicatorView startAnimating];
    }
}

- (void)loadImage {
    [_imageView setImage:nil];
    if (!_urlString) {
        [_indicatorView stopAnimating];
        return;
    }
    [_indicatorView startAnimating];
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    // TODO : observer検討
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MLNotificationCenter registerGetImageNotification:self url:_urlString];
    
    [imageManager.imageCache queryDiskCacheForKey:_urlString done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            [_imageView setImage:image];
            self.backgroundColor = [UIColor clearColor];
            [_indicatorView stopAnimating];
        } else {
            [[MLImageManager sharedManager] performSelectorInBackground:@selector(load:) withObject:_urlString];
        }
    }];
}

- (void)loadedImage:(NSNotification *)n {
    [self performSelectorOnMainThread:@selector(_loadedImage:) withObject:[n userInfo][@"image"] waitUntilDone:YES];
}

- (void)_loadedImage:(UIImage *)image {
    self.backgroundColor = [UIColor clearColor];
    [_indicatorView stopAnimating];
    _imageView.alpha = 0;
    [_imageView setImage:image];
    [UIView animateWithDuration:0.5 animations:^{
        _imageView.alpha = 1;
    }];
    [_imageView setImage:image];
}

@end
