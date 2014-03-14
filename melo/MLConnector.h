//
//  MLConnector.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLConnector : NSObject

@property (nonatomic) BOOL networkAccessing;

+ (MLConnector *)sharedConnector;

- (void)get:(NSString *)urlString success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters;
- (void)post:(NSString *)urlString success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters;
- (void)delete:(NSString *)urlString success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters;
@end
