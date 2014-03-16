//
//  MLNotificationCenter.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLNotificationCenter : NSObject

+ (void)postGetImageNotification:(UIImage *)image url:(NSString *)url;

+ (void)registerGetImageNotification:(id)observer url:(NSString *)url;
@end
