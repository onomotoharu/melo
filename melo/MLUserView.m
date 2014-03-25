//
//  MLUserView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLUserView.h"

#import "MLUserController.h"
#import "MLImageManager.h"
#import "MLNotificationCenter.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIColor+Addition.h"

NSInteger const MLUserViewImageMargin = 20;
NSInteger const MLUserViewImageWidth = 120;
NSInteger const MLUserViewImageHeight = 120;
NSInteger const MLUserViewCollectionTitleHeight = 25;

@interface MLUserView () {
    @private
    MLUser *_user;
    UIImageView *_imageView;
    UIButton *_followBtn;
}

@end

@implementation MLUserView

+ (CGFloat)height {
    return MLUserViewImageWidth + MLUserViewImageMargin * 2 + MLUserViewCollectionTitleHeight;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setUser:(MLUser *)user {
    _user = user;

    [self setImageView];
    [self setFollowBtn];
    [self setNeedsDisplay];
}

- (void)updateUser {
    [self setImageView];
    [self setFollowBtn];
    [self setNeedsDisplay];
}

- (void)setImageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MLUserViewImageMargin,
                                                                   MLUserViewImageMargin,
                                                                   MLUserViewImageWidth,
                                                                   MLUserViewImageHeight)];
        [self addSubview:_imageView];
    }
    [self loadImage];
}

- (void)setFollowBtn {
    
}

- (void)loadImage {
    NSString *url = _user.image;
    if (!url) {
        [_imageView setImage:[_user defaultImage]]; // TODO : 一時的
        return;
    }
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    // TODO : observer検討
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MLNotificationCenter registerGetImageNotification:self url:url];
    
    [imageManager.imageCache queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            _imageView.image = image;
        } else {
            [[MLImageManager sharedManager] performSelectorInBackground:@selector(load:) withObject:url];
        }
    }];
}

- (void)loadedImage:(NSNotification *)n {
    [self performSelectorOnMainThread:@selector(_loadedImage:) withObject:[n userInfo][@"image"] waitUntilDone:YES];
}

- (void)_loadedImage:(UIImage *)image {
    _imageView.alpha = 0;
    [_imageView setImage:image];
    [UIView animateWithDuration:0.5 animations:^{
        _imageView.alpha = 1;
    }];
    [_imageView setImage:image];
}

- (void)drawRect:(CGRect)rect {
    if (!_user) {
        return;
    }
    // name
    NSDictionary *nameAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                     NSForegroundColorAttributeName: [UIColor baseBlueColor]};
    NSString *name = _user.name;
    CGSize nameSize = [name boundingRectWithSize:self.frame.size options:0 attributes:nameAttributes context:nil].size;
    CGRect nameRect = CGRectMake(NNViewMaxX(_imageView) + MLUserViewImageMargin,
                                 NNViewMinY(_imageView),
                                 nameSize.width, nameSize.height);
    [name drawInRect:nameRect withAttributes:nameAttributes];
    
    // line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 219 / 255.f, 220 / 255.f, 220 / 255.f, 1.0);
    CGContextBeginPath(context);
    float lineContentY = [self.class height] - MLUserViewCollectionTitleHeight;
    CGContextMoveToPoint(context, 0, lineContentY);
    CGContextAddLineToPoint(context, NNViewWidth(self), lineContentY);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
    // collection title
    NSString *title = @"いいね！リスト";
//    NSString *title = @"投稿した商品";
    NSDictionary *titleAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]};
    CGSize titleSize = [title boundingRectWithSize:self.frame.size options:0 attributes:titleAttributes context:nil].size;
    CGRect titleRect = CGRectMake((NNViewWidth(self) - titleSize.width) / 2,
                                  lineContentY + 10,
                                  titleSize.width, titleSize.height);
    [title drawInRect:titleRect withAttributes:titleAttributes];

}


@end
