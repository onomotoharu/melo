//
//  MLNotificationView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLNotificationView.h"

NSInteger MLNotificationViewFontSize = 14;
UIEdgeInsets MLNotificationViewDetailPadding = {20, 20, 20, 20};

@interface MLNotificationView () {
    @private
    NSAttributedString *_detail;
    CGSize _detailSize;
}

@end

@implementation MLNotificationView

- (id)initWithFrame:(CGRect)frame detail:(NSString *)detail {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setDetail:detail];
    }
    return self;
}

- (void)setDetail:(NSString *)detail {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:MLNotificationViewFontSize]};
    _detail = [[NSAttributedString alloc] initWithString:detail attributes:attributes];
    [self setHeight];
}

- (void)setHeight {
    _detailSize = [_detail boundingRectWithSize:CGSizeMake(NNViewWidth(self) - MLNotificationViewDetailPadding.left * 2, 10000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    // set height
    CGRect frame = self.frame;
    frame.size.height = _detailSize.height +  MLNotificationViewDetailPadding.top * 2;
    self.frame = frame;
}

- (void)drawRect:(CGRect)rect {
    if (!_detail) {
        return;
    }
    
    CGRect detailRect = CGRectMake(MLNotificationViewDetailPadding.left,
                                   MLNotificationViewDetailPadding.top,
                                   _detailSize.width, _detailSize.height);
    [_detail drawInRect:detailRect];
}


@end
