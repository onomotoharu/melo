//
//  MLNotificationCellLayout.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotificationCellLayout.h"

#import "MLNotification.h"

UIEdgeInsets MLNotificationCellMessagePadding = {15, 20, 15, 20};
NSInteger MLNotificationCellMessageFontSize = 14;
NSInteger MLNotificationCellMessageMinHeight = 55;

@implementation MLNotificationCellLayout

+ (NSAttributedString *)message:(MLNotification *)notification {
    NSAttributedString *attrMessage;
    switch ([notification.notificationType shortValue]) {
        case MLNotificationTypeInfo:
            attrMessage = [self infoMessage:notification];
            break;
        case MLNotificationTypeWant:
            attrMessage = [self wantMessage:notification];
            break;
        case MLNotificationTypeFollow:
            attrMessage = [self followMessage:notification];
            break;
        default:
            attrMessage = [self infoMessage:notification];
            break;
    }
    return attrMessage;
}

#pragma mark - Message

// info message
+ (NSAttributedString *)infoMessage:(MLNotification *)notification {
    NSString *message = notification.detail;
    message = [message componentsSeparatedByString:@"\n"][0];
    NSMutableAttributedString *attrMessage = [[[NSAttributedString alloc] initWithString:message attributes:[self messageAttributes]] mutableCopy];
    
    return attrMessage;
}

// want message
+ (NSAttributedString *)wantMessage:(MLNotification *)notification {
    NSString *action = @"いいね！";
    NSString *message = [NSString stringWithFormat:@"%@さんがあなたの投稿した商品に%@と言っています。", notification.actedUser.name, action];
    NSMutableAttributedString *attrMessage = [[[NSAttributedString alloc] initWithString:message attributes:[self messageAttributes]] mutableCopy];
    [attrMessage addAttributes:[self emphasisAttributes] range:[message rangeOfString:notification.actedUser.name]];
    [attrMessage addAttributes:[self emphasisAttributes] range:[message rangeOfString:action]];

    return attrMessage;
}

// follow message
+ (NSAttributedString *)followMessage:(MLNotification *)notification {
    NSString *action = @"フォロー";
    NSString *message = [NSString stringWithFormat:@"%@さんがあなたを%@しました。", notification.actedUser.name, action];
    NSMutableAttributedString *attrMessage = [[[NSAttributedString alloc] initWithString:message attributes:[self messageAttributes]] mutableCopy];
    [attrMessage addAttributes:[self emphasisAttributes] range:[message rangeOfString:notification.actedUser.name]];
    [attrMessage addAttributes:[self emphasisAttributes] range:[message rangeOfString:action]];
    
    return attrMessage;
}

#pragma mark - Attributes

+ (NSDictionary *)messageAttributes {
    return @{NSFontAttributeName: [UIFont systemFontOfSize:MLNotificationCellMessageFontSize]};
}

+ (NSDictionary *)emphasisAttributes {
    return @{NSFontAttributeName: [UIFont boldSystemFontOfSize:MLNotificationCellMessageFontSize]};
}

#pragma mark - MessageRect

+ (CGRect)messageRect:(NSAttributedString *)message {
    CGFloat contentwidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) - MLNotificationCellMessagePadding.left * 2;
    CGSize messageSize = [message boundingRectWithSize:CGSizeMake(contentwidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGRect messageRect = CGRectMake(MLNotificationCellMessagePadding.left,
                                    MLNotificationCellMessagePadding.top,
                                    messageSize.width, messageSize.height + MLNotificationCellMessagePadding.bottom);
    if (CGRectGetMaxY(messageRect) < MLNotificationCellMessageMinHeight) {
        messageRect = CGRectMake(MLNotificationCellMessagePadding.left,
                                 (MLNotificationCellMessageMinHeight - messageSize.height) / 2,
                                 messageSize.width, messageSize.height);
    }
    return messageRect;
}

+ (NSDictionary *)cellInfo:(MLNotification *)notification {
    NSAttributedString *message = [self message:notification];
    CGRect messageRect = [self messageRect:message];
    CGFloat height = CGRectGetMaxY(messageRect);
    if (CGRectGetMaxY(messageRect) < MLNotificationCellMessageMinHeight) {
        height = MLNotificationCellMessageMinHeight;
    }
    return @{@"message": message, @"messageRect": [NSValue valueWithCGRect:messageRect], @"height": @(height)};
}
@end
