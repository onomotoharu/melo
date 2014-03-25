//
//  MLInquiryViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLInquiryViewController.h"

#import "MLInquiryView.h"

@interface MLInquiryViewController ()

@end

@implementation MLInquiryViewController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"お問い合わせ";
    [self setInquiryView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInquiryView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    CGRect inquiryViewRect = CGRectMake(0, 0, NNViewWidth(self.view), NNViewHeight(self.view) - [MLDevice topMargin:YES] - [MLDevice tabBarHeight]);
    MLInquiryView *inquiryView = [[MLInquiryView alloc] initWithFrame:inquiryViewRect];
    
    [self.view addSubview:scrollView];
    [scrollView addSubview:inquiryView];
    
    scrollView.contentSize = CGSizeMake(NNViewWidth(scrollView), NNViewHeight(inquiryView) + 1);
}

@end
