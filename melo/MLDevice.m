//
//  MLDevice.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLDevice.h"

NSInteger const IPHONE_5_WIDTH = 568;
NSInteger const IPHONE_4_WIDTH = 80;

@implementation MLDevice

+ (BOOL)isIphone5 {
    if (CGRectGetHeight([[UIScreen mainScreen] bounds]) == IPHONE_5_WIDTH) {
        return YES;
    }
    return NO;
}

+ (BOOL)isRetina {
    if ([UIScreen mainScreen].scale == 2.0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isIos7 {
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(osVersion >= 7.0f)  {
        return YES;
    }
    return NO;
}

+ (NSInteger)topMargin:(BOOL)navigationBar {
    if (!navigationBar) {
        return 20;
    } else {
        return 64;
    }
}

+ (NSInteger)tabBarHeight {
    return 49;
}

@end
