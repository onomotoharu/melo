//
//  MLProductManager.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLProductManager : NSObject

+ (MLProductManager *)sharedManager;

- (void)setProducts:(NSArray *)products type:(NSString *)type;
- (NSMutableArray *)getProducts:(NSString *)type;
@end
