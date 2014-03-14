//
//  MLConnector.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLConnector.h"

#import "MLHttpRequest.h"

static MLConnector *_sharedConnector = nil;

@interface MLConnector () {
    @private
    NSMutableDictionary *_requests;
}

@end

@implementation MLConnector

+ (MLConnector *)sharedConnector {
    @synchronized(self) {
        if (_sharedConnector == nil) {
            _sharedConnector = [[self alloc] init];
        }
    }
    return _sharedConnector;
}

- (id)init {
    self = [super init];
    if (self) {
        _networkAccessing = NO;
        _requests = [@{} mutableCopy];
        [self addObserver:self forKeyPath:@"networkAccessing" options:0 context:nil];
    }
    return self;
}

- (BOOL)startRequest:(MLHttpRequest *)request {
    if ([[_requests allKeys] containsObject:request.urlString]) {
        return NO;
    }
    [_requests setObject:request forKey:request.urlString];
    self.networkAccessing = YES;
    return YES;
}

- (void)finishRequest:(MLHttpRequest *)request {
    [_requests removeObjectForKey:request.urlString];
    if (_requests.count == 0) {
        self.networkAccessing = NO;
    }
}

#pragma mark - HTTP Method

- (void)get:(NSString *)urlString success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    __weak MLConnector *weakSelf = self;
    MLHttpRequest *request = [[MLHttpRequest alloc] initWithUrlString:urlString delegate:weakSelf];
    if ([self startRequest:request]) {
        [request get:success failure:failure];
    }
}

- (void)post:(NSString *)urlString success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters {
    __weak MLConnector *weakSelf = self;
    MLHttpRequest *request = [[MLHttpRequest alloc] initWithUrlString:urlString delegate:weakSelf];
    if ([self startRequest:request]) {
        [request post:success failure:failure parameters:parameters];
    }
}

- (void)delete:(NSString *)urlString success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure parameters:(NSDictionary *)parameters {
    __weak MLConnector *weakSelf = self;
    MLHttpRequest *request = [[MLHttpRequest alloc] initWithUrlString:urlString delegate:weakSelf];
    if ([self startRequest:request]) {
        [request delete:success failure:failure parameters:parameters];
    }
}



#pragma mark - MLHttpRequestDelegate

- (void)successRequest:(MLHttpRequest *)request responseObject:(id)responseObject {
    [self finishRequest:request];
}

- (void)errorRequest:(MLHttpRequest *)request {
    [self finishRequest:request];
}

#pragma mark - KVO Pattern

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"networkAccessing"]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = _networkAccessing;
    }
}

@end
