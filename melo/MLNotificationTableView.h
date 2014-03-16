//
//  MLNotificationTableView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLNotification;

@interface MLNotificationTableView : UITableView

@property (weak) id controllerDelegate;

- (void)setNotifications:(NSArray *)notifications;
@end

@interface NSObject (MLNotificationTableViewDelegate)

- (void)didSelectRow:(MLNotificationTableView *)view notification:(MLNotification *)notification;

@end
