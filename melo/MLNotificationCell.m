//
//  MLNotificationCell.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotificationCell.h"

#import "MLNotificationCellContentView.h"

@interface MLNotificationCell () {
    @private
    MLNotificationCellContentView *_contentView;
}

@end

@implementation MLNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initContentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initContentView {
    if (!_contentView) {
        _contentView = [[MLNotificationCellContentView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_contentView];
    }
}

- (void)setCellInfo:(NSDictionary *)cellInfo {
    [_contentView setCellInfo:cellInfo];
}

- (void)resizeContentView {
    self.contentView.frame = self.bounds;
    CGRect contentViewFrame = self.bounds;
    _contentView.frame = contentViewFrame;
}


@end
