//
//  MLHomeTabView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLHomeTabView.h"

NSInteger const MLHomeTabViewTabCount = 3;
NSInteger const MLHomeTabViewTabMargin = 5;

@interface MLHomeTabView () {
    @private
    NSMutableArray *_activeTabs;
    NSMutableArray *_tabBtns;
}

@end

@implementation MLHomeTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self setActiveTabs];
        [self setTabBtns];
    }
    return self;
}

- (void)setActiveTabs {
    _activeTabs = [@[] mutableCopy];
    for (int i = 0; i < MLHomeTabViewTabCount; i++) {
        UIView *activeTab = [[UIView alloc] initWithFrame:CGRectMake(0 + NNViewWidth(self) / 3 * i,
                                                                     MLHomeTabViewTabMargin,
                                                                     NNViewWidth(self) / 3,
                                                                     NNViewHeight(self) - MLHomeTabViewTabMargin)];
        activeTab.backgroundColor = [UIColor whiteColor];
        [self addSubview:activeTab];
        [_activeTabs addObject:activeTab];
    }
}

- (void)setTabBtns {
    _tabBtns = [@[] mutableCopy];
    NSArray *btnTitles = @[@"フォロー", @"新着", @"人気"];
    for (int i = 0; i < MLHomeTabViewTabCount; i++) {
        UIButton *tabBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        tabBtn.frame = CGRectMake(0 + NNViewWidth(self) / 3 * i, 0, NNViewWidth(self) / 3, NNViewHeight(self));
        [tabBtn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[tabBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
        [tabBtn addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        tabBtn.tag = i;
        [self addSubview:tabBtn];
        [_tabBtns addObject:tabBtn];
    }
    [self activeTab:1]; // default tab
}

- (void)selectTab:(UIButton *)sender {
    [self activeTab:sender.tag];
    if (_delegate && [_delegate respondsToSelector:@selector(selectTab:tabNum:)]) {
        [_delegate selectTab:self tabNum:sender.tag];
    }
}

- (void)activeTab:(short)tabNum {
    for (int i = 0; i < MLHomeTabViewTabCount; i++) {
        UIView *activeTab = _activeTabs[i];
        UIButton *tabBtn  = _tabBtns[i];
        if (i == tabNum) {
            activeTab.hidden = NO;
            [tabBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        } else {
            activeTab.hidden = YES;
            [tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

@end
