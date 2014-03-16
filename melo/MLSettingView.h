//
//  MLSettingView.h
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MLSettingTypeProfile = 0,
    MLSettingTypeMail = 1,
    MLSettingTypeFeedback = 2,
} MLSettingTypes;

@interface MLSettingView : UITableView

@property (weak) id controllerDelegate;

@end

@interface NSObject (MLSettingViewDelegate)

- (void)didSelectRow:(MLSettingView *)view contentType:(NSNumber *)contentType;

@end

