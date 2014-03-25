//
//  MLHomeTabView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLHomeTabView.h"

#import "UIColor+Addition.h"

NSInteger const MLHomeTabViewTabCount = 3;
NSInteger const MLHomeTabViewFooterHeight = 0;

@interface MLHomeTabView () {
    @private
    NSMutableArray *_activeTabs;
    NSMutableArray *_tabBtns;
    NSArray *_btnTitles;
    UILabel *_footer;
}

@end

@implementation MLHomeTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.9];
        self.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0] CGColor];
        self.layer.borderWidth = 0.5;
        [self setActiveTabs];
        [self setTabBtns];
        [self setFooter]; // TODO : 不要かも
    }
    return self;
}

- (void)setActiveTabs {
    _activeTabs = [@[] mutableCopy];
    for (int i = 0; i < MLHomeTabViewTabCount; i++) {
        UIView *activeTab = [[UIView alloc] initWithFrame:CGRectMake(0 + NNViewWidth(self) / 3 * i,
                                                                     0,
                                                                     NNViewWidth(self) / 3,
                                                                     NNViewHeight(self) - MLHomeTabViewFooterHeight)];
        activeTab.backgroundColor = [UIColor whiteColor];
        [self addSubview:activeTab];
        [_activeTabs addObject:activeTab];
    }
}

- (void)setTabBtns {
    _tabBtns = [@[] mutableCopy];
    _btnTitles = @[@"フォロー", @"新着", @"人気"];
    for (int i = 0; i < MLHomeTabViewTabCount; i++) {
        UIButton *tabBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        tabBtn.frame = CGRectMake(0 + NNViewWidth(self) / 3 * i, 0, NNViewWidth(self) / 3, NNViewHeight(self) - MLHomeTabViewFooterHeight);
        [tabBtn setTitle:_btnTitles[i] forState:UIControlStateNormal];
        [tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[tabBtn titleLabel] setFont:[UIFont boldSystemFontOfSize:14]];
        [tabBtn addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        tabBtn.tag = i;
        [self addSubview:tabBtn];
        [_tabBtns addObject:tabBtn];
    }
    [self activeTab:1]; // default tab
}

- (void)setFooter {
    _footer = [[UILabel alloc] initWithFrame:CGRectMake(0, NNViewHeight(self) - MLHomeTabViewFooterHeight, NNViewWidth(self), MLHomeTabViewFooterHeight)];
    [_footer setBackgroundColor:[UIColor whiteColor]];
    _footer.text = _btnTitles[1];
    _footer.font = [UIFont boldSystemFontOfSize:10];
    _footer.textAlignment = NSTextAlignmentCenter;
    _footer.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0] CGColor];
    _footer.layer.borderWidth = 0.5;
    [self addSubview:_footer];
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
            [tabBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _footer.text = _btnTitles[i];
        } else {
            activeTab.hidden = YES;
            [tabBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            CGRect tabViewRect = self.frame;
            if (hidden) {
                tabViewRect.origin.y = [MLDevice topMargin:YES] - 44;
            } else {
                tabViewRect.origin.y = [MLDevice topMargin:YES];
            }
            self.frame = tabViewRect;
        }];
    }
    
}

@end
