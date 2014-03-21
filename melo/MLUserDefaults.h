//
//  MLUserDefaults.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLUserDefaults : NSObject

+ (NSString *)getUUID;
+ (void)setUUID:(NSString *)UUID;

+ (bool)getFinishedStartGuide;
+ (void)setFinishedStartGuide:(BOOL)finished;
@end
