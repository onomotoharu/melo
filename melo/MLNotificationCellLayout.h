//
//  MLNotificationCellLayout.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLNotification;

@interface MLNotificationCellLayout : NSObject

+ (NSDictionary *)cellInfo:(MLNotification *)notification;
@end
