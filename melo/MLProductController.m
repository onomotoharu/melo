//
//  MLProductController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductController.h"

#import "MLConnector.h"

@implementation MLProductController

// products
+ (void)getProducts:(NSString *)type parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@", type];
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:parameters];
}

// relation
+ (void)getRelations:(NSNumber *)productId parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@/relationships", productId];
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:parameters];
}

// posts
+ (void)getPosts:(NSNumber *)userId parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/users/%@/products", userId];
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:parameters];
}


// want
+ (void)getWants:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = @"/account/products";
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:parameters];
}

// product
+ (void)getProduct:(NSNumber *)productId success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@", productId];
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:@{}];
}

// report
+ (void)postReport:(NSNumber *)productId parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@/report", productId];
    [[MLConnector sharedConnector] post:urlString success:success failure:failure parameters:parameters];
}

// want
+ (void)postWant:(NSNumber *)productId success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@/want", productId];
    [[MLConnector sharedConnector] post:urlString success:success failure:failure parameters:@{}];

}

// delete want
+ (void)deleteWant:(NSNumber *)productId success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/account/products/%@", productId];
    [[MLConnector sharedConnector] delete:urlString success:success failure:failure parameters:@{}];
}

@end
