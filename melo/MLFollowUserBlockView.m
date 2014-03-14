//
//  MLFollowUserBlockView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLFollowUserBlockView.h"

#import "MLUser.h"
#import "MLProduct.h"
#import "MLUserController.h"
#import "MLProductView.h"
#import "UIColor+Addition.h"

NSInteger MLFollowUserBlockViewTopMargin = 25;
NSInteger MLFollowUserBlockViewMiddleMargin = 15;
NSInteger MLFollowUserBlockViewBottomMargin = 25;

@interface MLFollowUserBlockView () {
    @private
    MLUser *_user;
    NSMutableArray *_products;
}

@end

@implementation MLFollowUserBlockView

- (id)initWithFrame:(CGRect)frame json:(NSDictionary *)json {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDate:json];
        [self initContent];
    }
    return self;
}

- (void)initDate:(id)json {
    _user = [MLUser createEntity];
    if (json) {
        [_user update:json];
    }
    
    NSArray *productArray = [json objectForKey:@"products"];
    _products = [@[] mutableCopy];
    if (productArray) {
        for (NSDictionary *productDic in productArray) {
            MLProduct *product = [MLProduct createEntity];
            [product update:productDic];
            [_products addObject:product];
        }
    }
}

- (void)initContent {
    // follow button
    int width = 140; // TODO : 画像サイズに変更
    int height = 25; // TODO : 画像サイズに変更
    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    followBtn.frame = CGRectMake(NNViewWidth(self) / 2, MLFollowUserBlockViewTopMargin, width, height);
    [self setFollowBtn:followBtn];
    [followBtn addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:followBtn];
    
    // user name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(NNViewWidth(self) / 2 - width, MLFollowUserBlockViewTopMargin, width, height)];
    nameLabel.text = _user.name;
    nameLabel.textColor = [UIColor baseBlueColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:13];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    
    // products panal
    float panelMinimumY = NNViewMaxY(followBtn) + MLFollowUserBlockViewMiddleMargin;
    CGRect rect = CGRectMake(0, panelMinimumY, 0, 0);
    for (int i = 0; i < _products.count; i++) {
        MLProduct *product = _products[i];
        rect = CGRectMake([MLProductView margin] + (MLProductViewWidth + [MLProductView margin]) * (i % 3),
                                 panelMinimumY + i / 3 * (MLProductViewHeight + [MLProductView margin]),
                                 MLProductViewWidth, MLProductViewHeight);
        MLProductView *productView = [[MLProductView alloc] initWithFrame:rect product:product];
        [self addSubview:productView];
    }
    
    // arange view frame
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(rect) + MLFollowUserBlockViewTopMargin;
    self.frame = frame;
}

- (void)setFollowBtn:(UIButton *)followBtn {
    followBtn.tag = _user.isFollow;
    if (followBtn.tag) { // follow
        [followBtn setTitle:@"フォロー解除" forState:UIControlStateNormal];
    } else { // unfollow
        [followBtn setTitle:@"フォロー" forState:UIControlStateNormal];
    }
}

#pragma mark - ButtonAction

- (void)follow:(UIButton *)followBtn {
    [MLUserController follow:_user success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _user.isFollow = !_user.isFollow;
        [self setFollowBtn:followBtn];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failedFollow];
    }];
}

- (void)failedFollow {
    NSString *message;
    if (_user.isFollow) {
        message = @"問題が起きてフォローを解除できませんでした。";
    } else {
        message = @"問題が起きてフォローできませんでした。";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

@end
