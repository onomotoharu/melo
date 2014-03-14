//
//  MLIndicator.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/15.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLIndicator.h"

#import "SVProgressHUD.h"

@implementation MLIndicator

+ (void)show:(NSString *)status {
    [[self new] performSelectorOnMainThread:@selector(show:) withObject:status waitUntilDone:YES];
}

+ (void)showSuccessWithStatus:(NSString*)string {
    [[self new] performSelectorOnMainThread:@selector(showSuccessWithStatus:) withObject:string waitUntilDone:YES];
}

+ (void)showErrorWithStatus:(NSString *)string {
    [[self new] performSelectorOnMainThread:@selector(showErrorWithStatus:) withObject:string waitUntilDone:YES];
}

+ (void)dissmiss {
    [[self new] performSelectorOnMainThread:@selector(dissmiss) withObject:nil waitUntilDone:YES];
    [SVProgressHUD dismiss];
}

- (void)show:(NSString *)status {
    [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeGradient];
}

- (void)showSuccessWithStatus:(NSString*)string {
    [SVProgressHUD showSuccessWithStatus:string];
}

- (void)showErrorWithStatus:(NSString *)string {
    [SVProgressHUD showErrorWithStatus:string];
}

- (void)dissmiss {
    [SVProgressHUD dismiss];
}

@end
