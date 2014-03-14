//
//  MLStartFollowView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLStartFollowView.h"

#import "MLUserController.h"
#import "MLFollowUserBlockView.h"
#import "UIColor+Addition.h"

NSInteger MLStartFollowViewFollowCount = 3;
NSInteger const MLStartFollowViewTitleHeight = 44;

@interface MLStartFollowView () <UIAlertViewDelegate> {
    @private
    __weak id _delegate;
    short _followNum;
    UIScrollView *_scrollView;
    UIButton *_completeBtn;
}

@end

@implementation MLStartFollowView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        [self setTitle];
        [self setScrollView];
        [self getNeighbor];
        [self setFollowNum:1];
    }
    return self;
}

- (void)setTitle {
    NSString *followNumText = [NSString stringWithFormat:@"%ld人", MLStartFollowViewFollowCount];
    NSString *title = [NSString stringWithFormat:@"センスの合う人を%@フォローしよう！", followNumText];
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-Italic" size:16];
    UIColor *titleColor = [UIColor colorWithDecRed:154 green:153 blue:154 alpha:1];
    // make attributes string
    NSMutableAttributedString *attrTitle = [[[NSAttributedString alloc] initWithString:title] mutableCopy];
    [attrTitle addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor basePinkColor] range:[title rangeOfString:followNumText]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [MLDevice topMargin], NNViewWidth(self), MLStartFollowViewTitleHeight)];
    titleLabel.attributedText = attrTitle;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];
}

- (void)setScrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MLStartFollowViewTitleHeight + [MLDevice topMargin], NNViewWidth(self), NNViewHeight(self) - MLStartFollowViewTitleHeight)];
        [self addSubview:_scrollView];
    }
}

- (void)setFollowNum:(short)followNum {
    _followNum = followNum;
    if (_followNum > 0) {
        [self setCompleteBtn];
    } else {
        [self removeCompleteBtn];
    }
}

- (void)setCompleteBtn {
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _completeBtn.frame = CGRectMake(0, NNViewHeight(self) - 44, NNViewWidth(self), 44);
        _completeBtn.backgroundColor = [UIColor basePinkColor];
        [_completeBtn setTitle:@"完了！" forState:UIControlStateNormal];
        [_completeBtn addTarget:_delegate action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_completeBtn];
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, NNViewHeight(_completeBtn), 0);
    }
}

- (void)removeCompleteBtn {
    [_completeBtn removeFromSuperview];
    _completeBtn = nil;
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Neighbor

- (void)getNeighbor {
    [MLUserController getNeighbor:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setNeighbor:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *erroe) {
        [self failedGetNeighbor];
    }];
}

- (void)setNeighbor:(id)responseObject {
    if (!responseObject[@"users"]) {
        return;
    }
    CGRect rect = CGRectMake(0, 0, NNViewWidth(self), 0);
    for (int i = 0; i < 3; i++) {
        for (NSDictionary *json in responseObject[@"users"]) {
            MLFollowUserBlockView *followUserBlock = [[MLFollowUserBlockView alloc] initWithFrame:rect json:json];
            rect.origin.y += NNViewHeight(followUserBlock);
            [_scrollView addSubview:followUserBlock];
        }
    }
    [_scrollView setContentSize:CGSizeMake(NNViewWidth(self), rect.origin.y)];
}

- (void)failedGetNeighbor {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"エラーにより情報を取得できませんでした。\n時間が経ってからもう一度おためしください。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"リトライ", nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self getNeighbor];
            break;
        default:
            break;
    }
}

@end
