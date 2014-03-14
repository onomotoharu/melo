//
//  MLDevice.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLDevice : NSObject

+ (BOOL)isIphone5;
+ (BOOL)isRetina;
+ (BOOL)isIos7;
+ (CGFloat)topMargin:(UIViewController *)viewController;
@end
