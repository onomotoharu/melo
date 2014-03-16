//
//  MLNotificationManager.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotificationManager.h"

#import "MLNotification.h"

static MLNotificationManager *_sharedManager = nil;

@interface MLNotificationManager () {
    @private
    NSMutableArray *_notifications;
}

@end

@implementation MLNotificationManager

+ (MLNotificationManager *)sharedManager {
    @synchronized(self) {
        if (_sharedManager == nil) {
            _sharedManager = [[self alloc] init];
        }
    }
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        _notifications = [@[] mutableCopy];
    }
    return self;
}

- (void)setNotifications:(NSArray *)notifications {
    [_notifications removeAllObjects]; // reset
    for (NSDictionary *notificationInfo in notifications) {
        MLNotification *notification = [MLNotification new];
        [notification update:notificationInfo];
        [_notifications addObject:notification];
    }
}

- (NSMutableArray *)getNotifications {
    return _notifications;
}

@end
