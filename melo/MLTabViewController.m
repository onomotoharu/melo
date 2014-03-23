//
//  MLTabViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLTabViewController.h"

#import "MLPostViewController.h"
#import "MLModalViewController.h"
#import "UIImage+Addition.h"

@interface MLTabViewController ()

@end

@implementation MLTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTabBarItems {
    NSArray *itemTitles = @[@"timeline", @"post", @"mypage"];
    NSArray *itemImages = @[@"TabBar-timeline", @"", @"TabBar-home"];
    for (int i = 0; i < itemTitles.count; i++) {
        UITabBarItem *item = [self.tabBar.items objectAtIndex:i];
        if (![itemImages[i] isEqualToString:@""]) {
            item.image = [UIImage getPngImage:itemImages[i]];
        }
        item.title = itemTitles[i];
    }
}

- (void)createPostBtn {
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postBtn.frame = CGRectMake(0.0, 0.0, 44, 44);
    [postBtn setBackgroundImage:[UIImage getPngImage:@"NavBar-postButtonWithCircle"] forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat heightDifference = NNViewHeight(postBtn) - self.tabBar.frame.size.height;
    if (heightDifference < 0) {
        postBtn.center = self.tabBar.center;
    } else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        postBtn.center = center;
    }
    
    [self.view addSubview:postBtn];
}

- (void)post {
    MLPostViewController *postViewController = [MLPostViewController new];
    MLModalViewController *modalViewController = [[MLModalViewController alloc] initWithRootViewController:postViewController];
    [self presentViewController:modalViewController animated:YES completion:nil];
}

@end
