//
//  MLUserView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLUserView : UIView

+ (CGFloat)height;

- (void)setUser:(MLUser *)user;
- (void)updateUser;
@end
