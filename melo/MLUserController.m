//
//  MLUserController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLUserController.h"

#import "MLConnector.h"

@implementation MLUserController

+ (void)getNeighbor:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = @"/users/neighbor";
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:@{}];
}

+ (void)follow:(MLUser *)user success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    if (user.isFollow) {
        NSString *urlString = [NSString stringWithFormat:@"/account/followeds/%@", user.id];
        [[MLConnector sharedConnector] delete:urlString success:success failure:failure parameters:@{}];
    } else {
        NSString *urlString = [NSString stringWithFormat:@"/users/%@/follow", user.id];
        [[MLConnector sharedConnector] post:urlString success:success failure:failure parameters:@{}];
    }
}


@end
