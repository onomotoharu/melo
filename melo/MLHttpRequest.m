//
//  MLHttpRequest.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLHttpRequest.h"

NSString const *BaseUrl = @"http://shinbo-no-MacBook-Air.local:3000/api/";

@implementation MLHttpRequest

- (id)initWithUrlString:(NSString *)urlString delegate:(id)delegate {
    self = [super init];
    if (self) {
        _urlString = urlString;
        _delegate = delegate;
    }
    return self;
}

- (AFHTTPRequestOperationManager *)createManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}

#pragma mark - HTTP Method

- (void)get:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters {
    [[self createManager] GET:[NSString stringWithFormat:@"%@%@", BaseUrl, _urlString] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self successCallBack:success operation:operation responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failureCallBack:failure operation:operation erorr:error];
    }];
}

- (void)post:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters {
    [[self createManager] POST:[NSString stringWithFormat:@"%@%@", BaseUrl, _urlString] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self successCallBack:success operation:operation responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failureCallBack:failure operation:operation erorr:error];
    }];
}

- (void)delete:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters {
    [[self createManager] DELETE:[NSString stringWithFormat:@"%@%@", BaseUrl, _urlString] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self successCallBack:success operation:operation responseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failureCallBack:failure operation:operation erorr:error];
    }];
}

#pragma mark - Callback

- (void)successCallBack:(AFHTTPRequestSuccessBlocks)success operation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject {
    if (_delegate && [_delegate respondsToSelector:@selector(successRequest:responseObject:)]) {
        [_delegate successRequest:self responseObject:responseObject];
    }
    if (success) {
        success(operation, responseObject);
    }
}

- (void)failureCallBack:(AFHTTPRequestFailureBlocks)failure operation:(AFHTTPRequestOperation *)operation erorr:(NSError *)error {
    if (_delegate && [_delegate respondsToSelector:@selector(errorRequest:)]) {
        [_delegate errorRequest:self];
    }
    if (failure) {
        failure(operation, error);
    }
}

@end
