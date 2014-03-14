//
//  MLLoginView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/12.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLLoginView : UIView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
@end

@interface  NSObject (MLLoginViewDelegate)

- (void)start:(MLLoginView *)view;

@end