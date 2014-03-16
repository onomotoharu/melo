//
//  MLNotificationCenter.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotificationCenter.h"

/* naming rule
 post notification method:     post + () + Notification
 register notification method: register + () + Notification
 */

#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation MLNotificationCenter

static NSNotificationCenter *NotificationCenter;

+ (NSNotificationCenter *)center {
    if (!NotificationCenter) {
        NotificationCenter = [NSNotificationCenter defaultCenter];
    }
    return NotificationCenter;
}

#pragma mark - Post Notification

+ (void)postGetImageNotification:(UIImage *)image url:(NSString *)url {
    [self.center postNotificationName:url object:nil userInfo:@{@"image" : image}];
}

#pragma mark - Register Notification

+ (void)registerGetImageNotification:(id)observer url:(NSString *)url {
    [self.center addObserver:observer selector:@selector(loadedImage:) name:url object:nil];
}

@end
