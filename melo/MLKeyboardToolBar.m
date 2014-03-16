//
//  MLKeyboardToolBar.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLKeyboardToolBar.h"

NSInteger MLKeyboardToolBarHeight = 44;

@interface MLKeyboardToolBar () {
    @private
    NSMutableArray *_toolBarItems;
}

@end

@implementation MLKeyboardToolBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _toolBarItems = [@[] mutableCopy];
        self.barStyle = UIBarStyleBlackTranslucent;
        [self sizeToFit];
        [self makeBtn];
    }
    return self;
}

- (void)makeBtn {
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *compBtn = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStylePlain target:self action:@selector(closeKeyboard:)];
    [_toolBarItems addObject:spacer];
    [_toolBarItems addObject:compBtn];
    [self setItems:_toolBarItems animated:YES];
}

-(void)closeKeyboard:(id)sender {
    if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(pushCompleteBtn:)]) {
        [_keyboardDelegate pushCompleteBtn:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
