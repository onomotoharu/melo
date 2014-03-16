//
//  MLEditProfileViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLEditProfileViewController.h"

#import "MLEditProfileView.h"
#import "MLImageUploadController.h"

@interface MLEditProfileViewController () {
    @private
    MLImageUploadController *_imageUploadController;
    MLEditProfileView *_editProfileView;
}

@end

@implementation MLEditProfileViewController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"プロフィール設定";
    [self setEditProfileView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditProfileView {
    __weak MLEditProfileViewController *weakSelf = self;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    CGRect editProfileRect = CGRectMake(0, 0, NNViewWidth(scrollView), NNViewHeight(scrollView) - [MLDevice topMargin:YES] - [MLDevice tabBarHeight]);
    _editProfileView = [[MLEditProfileView alloc] initWithFrame:editProfileRect];
    _editProfileView.delegate = weakSelf;
    
    [self.view addSubview:scrollView];
    [scrollView addSubview:_editProfileView];
    
    scrollView.contentSize = CGSizeMake(NNViewWidth(scrollView), NNViewHeight(_editProfileView) + 1);
}

- (void)setImageUploadViewController {
    __weak MLEditProfileViewController *weakSelf = self;
    _imageUploadController = [MLImageUploadController new];
    _imageUploadController.delegate = weakSelf;
    [_imageUploadController showActionSheet];
}

#pragma mark - MLEditProfileViewDelegate

- (void)pushImageBtn:(MLEditProfileView *)view {
    [self setImageUploadViewController];
}

#pragma mark - MLImageUploadController

// TODO : 修正
- (void)selectedImage:(MLImageUploadController *)controller image:(UIImage *)image {
    [_editProfileView changeImage:image];
}

@end
