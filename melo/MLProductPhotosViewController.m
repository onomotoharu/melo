//
//  MLProductPhotosViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/23.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductPhotosViewController.h"

#import "MLProductController.h"
#import "MLProductPhotosView.h"
#import "MLProductPhotosCollectionLayout.h"
#import "MLIndicator.h"

@interface MLProductPhotosViewController () {
    @private
    NSMutableArray *_photos;
    NSMutableDictionary *_parameters;
    MLProductPhotosView *_photosView;
}

@end

@implementation MLProductPhotosViewController

- (id)init {
    self = [super init];
    if (self) {
        _photos = [@[] mutableCopy];
        _parameters = [@{} mutableCopy];
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"投稿する商品を選んでください";
    [self initCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCollectionView {
    __weak MLProductPhotosViewController *weakSelf = self;
    MLProductPhotosCollectionLayout *layout = [MLProductPhotosCollectionLayout new];
    _photosView = [[MLProductPhotosView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _photosView.controllerDelegate = weakSelf;
    [_photosView setPhotos:_photos];
    [self.view addSubview:_photosView];
}

- (void)setPhotos:(NSArray *)photos {
    _photos = [photos mutableCopy];
    if (_photosView) {
        [_photosView setPhotos:_photos];
    }
}

- (void)setParameters:(NSDictionary *)parameters {
    _parameters = [parameters mutableCopy];
}

#pragma mark - MLProductPhotosViewDelegate

- (void)selectedPhoto:(MLProductPhotosView *)view imageUrlString:(NSString *)imageUrlString {
    [_parameters setObject:imageUrlString forKey:@"original_photo_url"];
    [MLIndicator show:@"post..."];
    [self post];
}

- (void)post {
    [MLProductController createProduct:[MLProductController createParameter:_parameters] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self successPost];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NNLog(@"%@", error)
        [self failurePost];
    }];
}

- (void)successPost {
    [MLIndicator showSuccessWithStatus:@"投稿しました。"];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


- (void)failurePost {
    [MLIndicator showErrorWithStatus:@"問題が起きて投稿に失敗しました。"];
}
@end
