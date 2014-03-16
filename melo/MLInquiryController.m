//
//  MLInquiryController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLInquiryController.h"

#import "MLConnector.h"

@implementation MLInquiryController

// create
+ (void)postInquiries:(NSDictionary *)parameters success:(AFHTTPRequestSuccessBlocks)success failure:(AFHTTPRequestFailureBlocks)failure {
    NSString *urlString = @"/inquiries";
    [[MLConnector sharedConnector] post:urlString success:success failure:failure parameters:parameters];
}

@end
