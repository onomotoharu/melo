//
//  MLImageManager.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLImageManager.h"

#import "MLNotificationCenter.h"
#import "SDWebImage/UIImageView+WebCache.h"

static MLImageManager *_sharedInstance = nil;

@interface MLImageManager () {
@private
    NSMutableArray *_loadedImages;
}

@end

@implementation MLImageManager

+ (MLImageManager *)sharedManager {
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[self alloc] init];
        }
    }
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _loadedImages = [@[] mutableCopy];
    }
    return self;
}

- (void)load:(NSString *)url {
    if ([_loadedImages containsObject:url]) {
        return;
    }
    [_loadedImages addObject:url];
    NSURL *imageURL = [NSURL URLWithString:url];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:imageURL
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                        // 通知
                        if (image) {
                            [MLNotificationCenter postGetImageNotification:image url:url];
                        } else {
                            [_loadedImages removeObject:url];
                        }
                    }];
    
}

@end
