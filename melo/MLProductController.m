//
//  MLProductController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductController.h"

@implementation MLProductController

+ (void)getProducts:(NSString *)type parameters:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = [NSString stringWithFormat:@"/products/%@", type];
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:parameters];
}

@end
