//
//  MLUserController.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLUserController : NSObject

+ (void)signup:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)update:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)getNeighbor:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)follow:(MLUser *)user success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
@end
