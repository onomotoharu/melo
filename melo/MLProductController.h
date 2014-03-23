//
//  MLProductController.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLProductController : NSObject

+ (NSDictionary *)createParameter:(NSDictionary *)parameter;

+ (void)getProduct:(NSNumber *)productId success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)newProduct:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)createProduct:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)getProducts:(NSString *)type parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)getRelations:(NSNumber *)productId parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)getPosts:(NSNumber *)userId parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)getWants:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)postReport:(NSNumber *)productId parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)postWant:(NSNumber *)productId success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;
+ (void)deleteWant:(NSNumber *)productId success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure;

@end
