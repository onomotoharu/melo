//
//  MLNotificationCellContentView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotificationCellContentView.h"

@interface MLNotificationCellContentView () {
    @private
    NSDictionary *_cellInfo;
}

@end

@implementation MLNotificationCellContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setCellInfo:(NSDictionary *)cellInfo {
    _cellInfo = cellInfo;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!_cellInfo) {
        return;
    }
    
    [_cellInfo[@"message"] drawInRect:[_cellInfo[@"messageRect"] CGRectValue]];
}

@end
