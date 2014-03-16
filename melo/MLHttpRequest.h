//
//  MLHttpRequest.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLHttpRequest : NSObject

@property (nonatomic) NSString *urlString;
@property (weak) id delegate;

- (id)initWithUrlString:(NSString *)urlString delegate:(id)delegate;

- (void)get:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters;
- (void)post:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters;
- (void)delete:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters;
- (void)put:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters;
@end

@interface NSObject (MLHttpRequestDelegate)

- (void)successRequest:(MLHttpRequest *)request responseObject:(id)responseObject;
- (void)errorRequest:(MLHttpRequest *)request;

@end