//
//  MLSettingView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLSettingView.h"

@interface MLSettingView () <UITableViewDataSource, UITableViewDelegate> {
    @private
    NSArray *_contents;
    MLSettingTypes type;
}

@end

@implementation MLSettingView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeDataSource];
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [UIView new]; // remove extra separator
        [self setSeparatorInset:UIEdgeInsetsZero];

    }
    return self;
}

- (void)makeDataSource {
    _contents = @[@{@"text": @"プロフィール設定", @"contentType": @(MLSettingTypeProfile)},
                  @{@"text": @"メール・パズワード設定", @"contentType": @(MLSettingTypeMail)},
                  @{@"text": @"お問い合わせ", @"contentType": @(MLSettingTypeInquiry)}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contents.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"MLSettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _contents[indexPath.row][@"text"];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(didSelectRow:contentType:)]) {
        [_controllerDelegate didSelectRow:self contentType:_contents[indexPath.row][@"contentType"]];
    }
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

@end
