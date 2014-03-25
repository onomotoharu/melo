//
//  MLHomeTabView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLHomeTabView : UIView

@property (weak) id delegate;

- (void)activeTab:(short)tabNum;
- (void)setHidden:(BOOL)hidden animated:(BOOL)animation;
@end

@interface NSObject (MLHomeTabViewDelegate)

- (void)selectTab:(MLHomeTabView *)view tabNum:(NSInteger)tabNum;

@end