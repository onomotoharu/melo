//
//  MLProductView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLProduct;

@interface MLProductView : UIView

extern const NSInteger MLProductViewWidth;
extern const NSInteger MLProductViewHeight;

- (id)initWithFrame:(CGRect)frame product:(MLProduct *)product;

+ (CGFloat)margin;
@end
