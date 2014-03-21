//
//  MLStartFollowView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLStartFollowView.h"

#import "MLUserController.h"
#import "MLFollowUserCell.h"
#import "MLIndicator.h"
#import "UIColor+Addition.h"

NSInteger MLStartFollowViewFollowCount = 1;
NSInteger MLStartFollowViewBtnHeight = 44;

@interface MLStartFollowView () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    @private
    __weak id _controllerDelegate;
    short _followNum;
    UIButton *_completeBtn;
    NSMutableArray *_neighbors;
}

@end

@implementation MLStartFollowView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _controllerDelegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [UIView new]; // remove extra separator
        [self getNeighbor];
    }
    return self;
}

- (void)setFollowNum:(short)followNum {
    _followNum = followNum;
    if (_followNum >= MLStartFollowViewFollowCount) {
        [self setCompleteBtn];
    } else {
        [self removeCompleteBtn];
    }
}

- (void)setCompleteBtn {
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _completeBtn.frame = CGRectMake(0, NNViewMaxY(self.superview) - MLStartFollowViewBtnHeight, NNViewWidth(self), MLStartFollowViewBtnHeight);
        _completeBtn.backgroundColor = [UIColor basePinkColor];
        [_completeBtn setTitle:@"完了！" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_completeBtn addTarget:_controllerDelegate action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:_completeBtn];
        CGRect frame = self.frame;
        frame.size.height -= MLStartFollowViewBtnHeight;
        self.frame = frame;
    }
}

- (void)removeCompleteBtn {
    if (_completeBtn) {
        CGRect frame = self.frame;
        frame.size.height += MLStartFollowViewBtnHeight;
        self.frame = frame;
    }
    [_completeBtn removeFromSuperview];
    _completeBtn = nil;
}

- (void)drawRect:(CGRect)rect {
    // line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 219 / 255.f, 220 / 255.f, 220 / 255.f, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, NNViewWidth(self), 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - Neighbor

- (void)getNeighbor {
    _neighbors = [@[] mutableCopy];
    //[MLIndicator show:nil]; // TODO : 表示されない原因の調査
    [MLUserController getNeighbor:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setNeighbor:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failedGetNeighbor];
    }];
}

- (void)setNeighbor:(id)responseObject {
    if (!responseObject[@"users"]) {
        [self failedGetNeighbor];
        return;
    }
    [MLIndicator dissmiss];
    for (NSDictionary *json in responseObject[@"users"]) {
        [self initDate:json];
    }
    [self reloadData];
}

- (void)failedGetNeighbor {
    [MLIndicator showErrorWithStatus:@"エラーにより情報を取得できませんでした。"];
}

#pragma mark - MLFollowUserCellDelegate

- (void)successFollowUser:(MLFollowUserCell *)view {
    [self setFollowNum:_followNum + 1];
}

- (void)successUnFollowUser:(MLFollowUserCell *)view {
    [self setFollowNum:_followNum - 1];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _neighbors.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"MLFollowUserCell";
    MLFollowUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        __weak MLStartFollowView *weakSelf = self;
        cell = [[MLFollowUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = weakSelf;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.neighbor = _neighbors[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MLFollowUserCell height:_neighbors[indexPath.row][@"products"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

- (void)initDate:(id)json {
    MLUser *user = [MLUser createEntity];
    if (json) {
        [user update:json];
    }
    
    NSMutableArray *products = [@[] mutableCopy];
    NSArray *productArray = [json objectForKey:@"products"];
    if (productArray) {
        for (NSDictionary *productDic in productArray) {
            MLProduct *product = [MLProduct createEntity];
            [product update:productDic];
            [products addObject:product];
        }
    }
    [_neighbors addObject:@{@"user": user, @"products": products}];
}

@end
