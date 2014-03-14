//
//  MLProductManager.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductManager.h"

#import "MLProduct.h"

static MLProductManager *_sharedManager = nil;

@interface MLProductManager () {
    @private
    NSMutableDictionary *_products;
}

@end

@implementation MLProductManager

+ (MLProductManager *)sharedManager {
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
        _products = [@{} mutableCopy];
    }
    return self;
}

- (void)setProducts:(NSArray *)products type:(NSString *)type {
    if (![_products objectForKey:type]) {
        [_products setObject:[@[] mutableCopy] forKey:type];
    }
    for (NSDictionary *productInfo in products) {
        MLProduct *product = [MLProduct createEntity];
        [product update:productInfo];
        
        [self addProduct:product type:type];
    }
}

- (NSMutableArray *)getProducts:(NSString *)type {
    return _products[type];
}

// ================================================================================
#pragma mark - collection method

- (void)collectionControl:(block)method {
    @synchronized(self) {
        method();
    }
}

- (void)addProduct:(MLProduct *)product type:(NSString *)type {
    [self collectionControl:^{
        if (!product) {
            return;
        }
        [_products[type] addObject:product];
    }];
}

- (void)insertProduct:(MLProduct *)product type:(NSString *)type atIndex:(int)index {
    [self collectionControl:^{
        if (!product) {
            return;
        }
        if (index < 0 || index > [_products[type] count] - 1) {
            return;
        }
        [_products[type] insertObject:product atIndex:index];
    }];
}

- (void)deleteProduct:(MLProduct *)product type:(NSString *)type {
    [self collectionControl:^{
        [_products[type] removeObject:product];
    }];
}

@end
