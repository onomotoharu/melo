//
//  MLStoreTableView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/21.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLStoreTableView : UITableView

@property (weak) id controllerDelegate;

@end

@interface NSObject (MLStoreTableViewDelegate)

- (void)didSelectRow:(MLStoreTableView *)view urlString:(NSString *)urlString;

@end
