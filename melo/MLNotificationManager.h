//
//  MLNotificationManager.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLNotificationManager : NSObject

+ (MLNotificationManager *)sharedManager;

- (void)setNotifications:(NSArray *)notifications;
- (NSMutableArray *)getNotifications;
@end
