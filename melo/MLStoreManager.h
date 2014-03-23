//
//  MLStoreManager.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/21.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLStoreManager : NSObject

+ (MLStoreManager *)sharedManager;

- (NSMutableArray *)getStores;
@end
