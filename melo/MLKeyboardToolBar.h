//
//  MLKeyboardToolBar.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger MLKeyboardToolBarHeight;

@interface MLKeyboardToolBar : UIToolbar

@property (weak) id keyboardDelegate;

@end

@interface NSObject (MLKeyBoardToolBarDelegate)

- (void)pushCompleteBtn:(MLKeyboardToolBar *)view;

@end


