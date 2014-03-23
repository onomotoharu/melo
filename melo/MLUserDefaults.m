//
//  MLUserDefaults.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLUserDefaults.h"

@implementation MLUserDefaults

// UUID
+ (NSString *)getUUID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"UUID"];
}

+ (void)setUUID:(NSString *)UUID {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:UUID forKey:@"UUID"];
    [userDefaults synchronize];
}

// currentUserId
+ (NSNumber *)getCurrentUserid {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"currentUserId"];
}

+ (void)setCurrentUserId:(NSNumber *)currentUserId {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:currentUserId forKey:@"currentUserId"];
    [userDefaults synchronize];
}

// finished startguide
+ (bool)getFinishedStartGuide {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"finishedStartGuide"];
}

+ (void)setFinishedStartGuide:(BOOL)finished {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:finished forKey:@"finishedStartGuide"];
    [userDefaults synchronize];
}

@end
