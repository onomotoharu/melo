//
//  MLStoreManager.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/21.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLStoreManager.h"

#import "MLStore.h"

static MLStoreManager *_sharedManager = nil;

@interface MLStoreManager () {
@private
    NSMutableArray *_stores;
}

@end

@implementation MLStoreManager

+ (MLStoreManager *)sharedManager {
    @synchronized(self) {
        if (_sharedManager == nil) {
            _sharedManager = [[self alloc] init];
        }
    }
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        _stores = [@[] mutableCopy];
        [self makeStoreData];
    }
    return self;
}

- (NSMutableArray *)getStores {
    return _stores;
}

// TODO : テスト用
- (void)makeStoreData {
    MLStore *zozo = [MLStore new];
    zozo.name = @"zozotown"; zozo.urlString = @"http://zozo.jp/";
    MLStore *amazon = [MLStore new];
    amazon.name = @"amazon"; amazon.urlString = @"http://www.amazon.co.jp/";
    MLStore *magaseek = [MLStore new];
    magaseek.name = @"magaseek"; magaseek.urlString = @"http://www.magaseek.com/";
    MLStore *buyma = [MLStore new];
    buyma.name = @"buyma"; buyma.urlString = @"http://www.buyma.com/";
    MLStore *locondo = [MLStore new];
    locondo.name = @"locondo"; locondo.urlString = @"http://www.locondo.jp/shop/";
    
    
    _stores = [@[zozo, amazon, magaseek, buyma, locondo, zozo, amazon, magaseek, buyma, locondo] mutableCopy];
    
}

@end
