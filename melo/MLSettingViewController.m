//
//  MLSettingViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLSettingViewController.h"

#import "MLSettingView.h"
#import "MLInquiryViewController.h"

@interface MLSettingViewController ()

@end

@implementation MLSettingViewController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"設定";
    [self setSettingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSettingView {
    __weak MLSettingViewController *weakSelf = self;
    MLSettingView *settingView = [[MLSettingView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    settingView.controllerDelegate = weakSelf;
    [self.view addSubview:settingView];
}

#pragma mark - MLSettingViewDelegate

- (void)didSelectRow:(MLSettingView *)view contentType:(NSNumber *)contentType {
    switch ([contentType shortValue]) {
        case MLSettingTypeProfile:
            break;
        case MLSettingTypeMail:
            break;
        case MLSettingTypeInquiry:
            [self.navigationController pushViewController:[MLInquiryViewController new] animated:YES];
            break;
        default:
            break;
    }
}

@end
