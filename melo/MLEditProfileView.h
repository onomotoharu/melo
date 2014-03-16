//
//  MLEditProfileView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLEditProfileView : UIView

@property (weak) id delegate;

- (void)changeImage:(UIImage *)image; // TODO : 修正
@end

@interface NSObject (MLEditProfileViewDelegate)

- (void)pushImageBtn:(MLEditProfileView *)view;

@end
