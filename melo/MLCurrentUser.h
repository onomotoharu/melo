//
//  MLCurrentUser.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLUser.h"

@interface MLCurrentUser : MLUser

+ (MLUser *)currentuser;

+ (NSString *)getUUID;
+ (void)setUUID:(NSString *)UUID;
+ (NSInteger)state;
@end
