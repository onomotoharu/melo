//
//  MLFollowUserCell.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLFollowUserCell : UITableViewCell

@property (nonatomic) NSDictionary *neighbor;
@property (weak) id delegate;

+ (CGFloat)height:(NSArray *)products;

@end

@interface NSObject (MLFollowUserCellDelegate)

- (void)successFollowUser:(MLFollowUserCell *)view;
- (void)successUnFollowUser:(MLFollowUserCell *)view;

@end