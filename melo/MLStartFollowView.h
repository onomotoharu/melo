//
//  MLStartFollowView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSInteger MLStartFollowViewFollowCount;

@interface MLStartFollowView : UITableView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate;
@end

@interface  NSObject (MLStartFollowViewDelegate)

- (void)complete;

@end
