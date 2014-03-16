//
//  MLProductView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLProductView : UIView

@property (weak) id delegate;

- (void)setProduct:(MLProduct *)product;
@end

@interface NSObject (MLProductViewDelegate)

- (void)pushUserName:(MLProductView *)view userId:(NSNumber *)userId;

@end
