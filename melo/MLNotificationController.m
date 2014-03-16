//
//  MLNotificationController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotificationController.h"

#import "MLConnector.h"

@implementation MLNotificationController

// index
+ (void)getNotifications:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = @"/notifications";
    [[MLConnector sharedConnector] get:urlString success:success failure:failure parameters:@{}];
}

@end
