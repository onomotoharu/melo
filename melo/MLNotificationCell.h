//
//  MLNotificationCell.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLNotificationCell : UITableViewCell

- (void)setCellInfo:(NSDictionary *)cellInfo;
- (void)resizeContentView;
@end
