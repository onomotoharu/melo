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
#import "MLProductCollectionView.h"
#import "MLProductCollectionLayout.h"
#import "UIColor+Addition.h"

NSInteger MLFollowUserBlockViewTopMargin = 25;
NSInteger MLFollowUserBlockViewMiddleMargin = 15;
NSInteger MLFollowUserBlockViewBottomMargin = 15;

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
    NSMutableArray *products = [@[] mutableCopy];
    for (int i = 0; i < _products.count; i++) {
        MLProduct *product = _products[i];
        [products addObject:product];
    }
    // TODO : fix
    float collectionHeight = 100 * (products.count / 3 + 1);
    if (products.count == 0) {
        collectionHeight = 0;
    }
    MLProductCollectionLayout *layout = [[MLProductCollectionLayout alloc] initDisplayLayout];
    CGRect collectionRect = CGRectMake(0, panelMinimumY, NNViewWidth(self), collectionHeight);
    MLProductCollectionView *collectionView = [[MLProductCollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout fixed:YES];
    [self addSubview:collectionView];
    [collectionView addProducts:products];

    // arange view frame
    CGRect frame = self.frame;
    frame.size.height = NNViewMaxY(collectionView) + MLFollowUserBlockViewBottomMargin;
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
