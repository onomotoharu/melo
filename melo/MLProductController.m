//
//  MLProductController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductController.h"

#import "MLProduct.h"
#import "MLConnector.h"

@implementation MLProductController

+ (void)getProducts:(NSString *)type parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@", type];
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:parameters];
}

+ (void)getRelations:(NSNumber *)productId parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@/relationships", productId];
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:parameters];
}

+ (void)getProduct:(NSNumber *)productId success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@", productId];
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:@{}];
}

+ (void)postReport:(NSNumber *)productId parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@/report", productId];
    [[MLConnector sharedConnector] post:urlString success:success failure:failure parameters:parameters];
}

+ (void)postWant:(NSNumber *)productId success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@/want", productId];
    [[MLConnector sharedConnector] post:urlString success:success failure:failure parameters:@{}];

}

+ (void)deleteWant:(NSNumber *)productId success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/account/products/%@", productId];
    [[MLConnector sharedConnector] delete:urlString success:success failure:failure parameters:@{}];
}

@end
