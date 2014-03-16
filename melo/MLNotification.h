//
//  MLNotification.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MLNotificationTypeInfo = 0,
    MLNotificationTypeWant = 1,
    MLNotificationTypeFollow = 2,
} MLNotificationTypes;

@interface MLNotification : NSObject

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;
@property (nonatomic) NSNumber *notificationType;
@property (nonatomic) NSDate *sentDate;
@property (nonatomic) BOOL isRead;
@property (nonatomic) MLUser *actedUser;

- (MLNotification *)update:(NSDictionary *)attributes;
@end
