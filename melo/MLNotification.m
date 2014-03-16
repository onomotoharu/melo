//
//  MLNotification.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotification.h"

@implementation MLNotification

#pragma mark - Update

- (MLNotification *)update:(NSDictionary *)attributes {
    self.id               = attributes[@"id"];
    self.detail           = attributes[@"detail"];
    self.notificationType = attributes[@"notification_type"];
    self.isRead           = [attributes[@"read"] boolValue];
    self.sentDate         = attributes[@"sent_at"];
    if (attributes[@"acted_user"]) {
        MLUser *user = [MLUser createEntity];
        [user update:attributes[@"acted_user"]];
        self.actedUser = user;
    }
    
    return self;
}
@end
