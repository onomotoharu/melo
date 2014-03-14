//
//  UIImage+Addition.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)

+ (UIImage *)getPngImage:(NSString *)imageName {
    imageName = [imageName stringByAppendingString:@"@2x"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    return image;
}

@end
