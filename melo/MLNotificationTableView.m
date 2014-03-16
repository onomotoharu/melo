//
//  MLNotificationTableView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotificationTableView.h"

#import "MLNotification.h"
#import "MLNotificationCell.h"
#import "MLNotificationCellLayout.h"

@interface MLNotificationTableView () <UITableViewDelegate, UITableViewDataSource> {
    @private
    NSMutableArray *_notifications;
    NSMutableArray *_notificationInfos;
}

@end

@implementation MLNotificationTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [UIView new]; // remove extra separator
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    return self;
}

- (void)setNotifications:(NSArray *)notifications {
    _notifications = [notifications mutableCopy];
    _notificationInfos = [@[] mutableCopy];
    for (MLNotification *notification in _notifications) {
        [_notificationInfos addObject:[MLNotificationCellLayout cellInfo:notification]];
    }
    
    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _notifications.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"MLNotificationCell";
    MLNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[MLNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setCellInfo:_notificationInfos[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_notificationInfos[indexPath.row][@"height"] floatValue];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell performSelector:@selector(resizeContentView)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MLNotification *notification = _notifications[indexPath.row];
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(didSelectRow:notification:)]) {
        [_controllerDelegate didSelectRow:self notification:notification];
    }
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

@end
