//
//  MLStoreTableView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/21.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLStoreTableView.h"

#import "MLStore.h"
#import "MLStoreManager.h"
#import "UIColor+Addition.h"

NSInteger MLStoreTableViewDescriptionHeight = 100;

@interface MLStoreTableView () <UITableViewDataSource, UITableViewDelegate> {
    @private
    NSMutableArray *_stores;
}

@end

@implementation MLStoreTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createDescriptionLabel];
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [UIView new]; // remove extra separator
        [self loadStoreData];
    }
    return self;
}

- (void)createDescriptionLabel {
    self.contentInset = UIEdgeInsetsMake(MLStoreTableViewDescriptionHeight, 0, 0, 0);
    
    CGRect labelRect = CGRectMake(0, - MLStoreTableViewDescriptionHeight, NNViewWidth(self), MLStoreTableViewDescriptionHeight);
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:labelRect];
    // TODO : category化
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.minimumLineHeight = 22;
    paragrahStyle.maximumLineHeight = 22;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13],
                                 NSForegroundColorAttributeName: [UIColor baseBlueColor],
                                 NSParagraphStyleAttributeName: paragrahStyle};
    NSString *_descriptionText = @"ネット上の気になる商品をmeloに投稿すればすれば\nマイページにどんどん追加されます。";
    NSAttributedString *descriptionText = [[NSAttributedString alloc] initWithString:_descriptionText attributes:attributes];
    descriptionLabel.attributedText = descriptionText;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:descriptionLabel];
}

- (void)loadStoreData {
    _stores = [[MLStoreManager sharedManager] getStores];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_stores count];
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
    
    MLStore *store = _stores[indexPath.row];
    cell.textLabel.text = store.name;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MLStore *store = _stores[indexPath.row];
    // 検索(delegate)
    if (_controllerDelegate && [_controllerDelegate respondsToSelector:@selector(didSelectRow:urlString:)] && store.urlString) {
        [_controllerDelegate didSelectRow:self urlString:store.urlString];
    }
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

@end
