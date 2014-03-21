//
//  MLFollowUserCell.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLFollowUserCell.h"

#import "MLUserController.h"
#import "MLProductCollectionView.h"
#import "MLProductCollectionLayout.h"
#import "UIColor+Addition.h"

NSInteger MLFollowUserCellTopMargin = 25;
NSInteger MLFollowUserCellMiddleMargin = 15;
NSInteger MLFollowUserCellBottomMargin = 15;

@interface MLFollowUserCell () {
    @private
    UIButton *_followBtn;
    UILabel *_nameLabel;
    MLProductCollectionView *_collectionView;
}

@end

@implementation MLFollowUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContent];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setNeighbor:(NSDictionary *)neighbor {
    _neighbor = neighbor;
    
    [self updateData];
}

+ (CGFloat)height:(NSArray *)products {
    return MLFollowUserCellTopMargin + 25/* follow button height */ + MLFollowUserCellMiddleMargin + [self collectionHeight:products] + MLFollowUserCellBottomMargin;
}

+ (CGFloat)collectionHeight:(NSArray *)products {
    float collectionHeight = 0;
    if (products.count > 0) {
        collectionHeight = 100 * ((products.count - 1) / 3 + 1);
    }
    return collectionHeight;
}

- (void)initContent {
    // follow button
    int width = 140; // TODO : 画像サイズに変更
    int height = 25; // TODO : 画像サイズに変更
    _followBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _followBtn.frame = CGRectMake(NNViewWidth(self) / 2, MLFollowUserCellTopMargin, width, height);
    [_followBtn addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_followBtn];
    
    // user name
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(NNViewWidth(self) / 2 - width, MLFollowUserCellTopMargin, width, height)];
    _nameLabel.textColor = [UIColor baseBlueColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:13];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    // products panal
    float panelMinimumY = NNViewMaxY(_followBtn) + MLFollowUserCellMiddleMargin;
    
    MLProductCollectionLayout *layout = [[MLProductCollectionLayout alloc] initDisplayLayout];
    CGRect collectionRect = CGRectMake(0, panelMinimumY, NNViewWidth(self), 0);
    _collectionView = [[MLProductCollectionView alloc] initWithFrame:collectionRect collectionViewLayout:layout fixed:YES];
    [self.contentView addSubview:_collectionView];
}

- (void)setFollowBtn {
    _followBtn.tag = [_neighbor[@"user"] isFollow];
    if (_followBtn.tag) { // follow
        [_followBtn setTitle:@"フォロー解除" forState:UIControlStateNormal];
    } else { // unfollow
        [_followBtn setTitle:@"フォロー" forState:UIControlStateNormal];
    }
}

- (void)updateData {
    [self setFollowBtn];
    _nameLabel.text = [_neighbor[@"user"] name];
    _collectionView.frame = CGRectMake(0, NNViewMinY(_collectionView), NNViewWidth(self), [self.class collectionHeight:_neighbor[@"products"]]);
    [_collectionView setProducts:_neighbor[@"products"]];
}

#pragma mark - ButtonAction

- (void)follow:(UIButton *)followBtn {
    [MLUserController follow:_neighbor[@"user"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self successFollow];
        [self setFollowBtn];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failedFollow];
    }];
}

- (void)successFollow {
    [_neighbor[@"user"] setIsFollow:![_neighbor[@"user"] isFollow]];
    if ([_neighbor[@"user"] isFollow]) {
        if (_delegate && [_delegate respondsToSelector:@selector(successFollowUser:)]) {
            [_delegate successFollowUser:self];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(successUnFollowUser:)]) {
            [_delegate successUnFollowUser:self];
        }
    }
}

- (void)failedFollow {
    NSString *message;
    if ([_neighbor[@"user"] isFollow]) {
        message = @"問題が起きてフォローを解除できませんでした。";
    } else {
        message = @"問題が起きてフォローできませんでした。";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

@end
