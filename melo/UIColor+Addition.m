//
//  UIColor+Addition.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (Addition)

+ (UIColor *)colorWithDecRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha];
}

+ (UIColor *)basePinkColor {
    return [self colorWithDecRed:221 green:116 blue:134 alpha:1];
}

+ (UIColor *)baseBlueColor {
    return [self colorWithDecRed:68 green:126 blue:179 alpha:1];
}
@end
