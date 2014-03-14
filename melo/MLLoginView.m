//
//  MLLoginView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/12.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLLoginView.h"

#import "UIImage+Addition.h"
#import "UIColor+Addition.h"

NSInteger const MLLoginViewTitleHeight = 44;
NSInteger const MLLoginViewButtonY = 350;

@interface MLLoginView () {
    @private
    __weak id _delegate;
}

@end

@implementation MLLoginView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        [self setBackground];
        [self setTitle];
        [self setBtn];
    }
    return self;
}

- (void)setBackground {
    self.backgroundColor = [UIColor basePinkColor];
}

- (void)setTitle {
    NSString *title = @"ダウンロードありがとうございます！";
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-Italic" size:16];
    UIColor *titleColor = [UIColor colorWithDecRed:154 green:153 blue:154 alpha:1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [MLDevice topMargin:nil], NNViewWidth(self), MLLoginViewTitleHeight)];
    [titleLabel setText:title];
    [titleLabel setTextColor:titleColor];
    [titleLabel setFont:titleFont];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];
}

- (void)setBtn {
    int width = 220; // TODO : 画像サイズに変更
    int height = 40;
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startBtn.frame = CGRectMake((NNViewWidth(self) - width) / 2, MLLoginViewButtonY, width, height);
    [startBtn setTitle:@"スタート" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:startBtn];
}

#pragma mark - ButtonAction

- (void)start {
    if (_delegate && [_delegate respondsToSelector:@selector(start:)]) {
        [_delegate start:self];
    }
}

@end
