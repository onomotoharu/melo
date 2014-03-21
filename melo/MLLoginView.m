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
NSInteger const MLLoginViewButtonY = 400;

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
    self.backgroundColor = [UIColor whiteColor];
    
    // TODO : 差し替える
    UIImage *bgImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://stat.ameba.jp/user_images/20111024/13/bamubamupamupamu/5b/d1/j/o0480048011567279919.jpg"]]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, [MLDevice topMargin:NO] + MLLoginViewTitleHeight, NNViewWidth(self), NNViewHeight(self) - ([MLDevice topMargin:NO] + MLLoginViewTitleHeight));
    [self addSubview:bgImageView];
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NNViewWidth(bgImageView), NNViewHeight(bgImageView))];
    maskView.backgroundColor = [UIColor colorWithDecRed:255 green:255 blue:255 alpha:0.3];
    [bgImageView addSubview:maskView];
}

- (void)setTitle {
    NSString *title = @"ダウンロードありがとうございます！";
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
    UIColor *titleColor = [UIColor colorWithDecRed:154 green:153 blue:154 alpha:1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [MLDevice topMargin:NO], NNViewWidth(self), MLLoginViewTitleHeight)];
    [titleLabel setText:title];
    [titleLabel setTextColor:titleColor];
    [titleLabel setFont:titleFont];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];
    
    // TODO : あとで消す
    UILabel *meloLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, NNViewWidth(self), 50)];
    meloLabel.backgroundColor = [UIColor clearColor];
    meloLabel.text = @"melo";
    meloLabel.textColor = [UIColor baseBlueColor];
    meloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:45];
    meloLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:meloLabel];
}

- (void)setBtn {
    int width = 220; // TODO : 画像サイズに変更
    int height = 40;
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startBtn.backgroundColor = [UIColor basePinkColor];
    startBtn.frame = CGRectMake((NNViewWidth(self) - width) / 2, MLLoginViewButtonY, width, height);
    [startBtn setTitle:@"スタート" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
