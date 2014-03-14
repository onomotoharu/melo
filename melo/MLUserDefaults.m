//
//  MLUserDefaults.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLUserDefaults.h"

@implementation MLUserDefaults

// TODO : あとで消す
// isNewUser
+ (BOOL)getIsNewUser {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"isNewUser"];
}

+ (void)setIsNewUser:(BOOL)isNewUser {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isNewUser forKey:@"isNewUser"];
    [userDefaults synchronize];
}


@end
