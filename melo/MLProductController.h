//
//  MLProductController.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLProduct.h"
#import "MLConnector.h"

@interface MLProductController : NSObject

+ (void)getProducts:(NSString *)type parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;

@end
