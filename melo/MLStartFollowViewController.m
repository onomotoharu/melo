//
//  MLStartFollowViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/13.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLStartFollowViewController.h"

#import "MLViewController.h"
#import "MLStartFollowView.h"
#import "MLHomeViewController.h"
#import "UIColor+Addition.h"

NSInteger const MLStartFollowViewTitleHeight = 44;

@interface MLStartFollowViewController ()

@end

@implementation MLStartFollowViewController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle];
    [self setStartFollowView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitle {
    NSString *followNumText = [NSString stringWithFormat:@"%ld人", MLStartFollowViewFollowCount];
    NSString *title = [NSString stringWithFormat:@"センスの合う人を%@フォローしよう！", followNumText];
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-Italic" size:16];
    UIColor *titleColor = [UIColor colorWithDecRed:154 green:153 blue:154 alpha:1];
    // make attributes string
    NSMutableAttributedString *attrTitle = [[[NSAttributedString alloc] initWithString:title] mutableCopy];
    [attrTitle addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, attrTitle.length)];
    [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor basePinkColor] range:[title rangeOfString:followNumText]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [MLDevice topMargin:NO], NNViewWidth(self.view), MLStartFollowViewTitleHeight)];
    titleLabel.attributedText = attrTitle;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLabel];
}

- (void)setStartFollowView {
    __weak MLStartFollowViewController *weakSelf = self;
    CGRect startFollowViewRect = CGRectMake(0, MLStartFollowViewTitleHeight + [MLDevice topMargin:NO], NNViewWidth(self.view), NNViewHeight(self.view) - (MLStartFollowViewTitleHeight + [MLDevice topMargin:NO]));
    MLStartFollowView *startFollowView = [[MLStartFollowView alloc] initWithFrame:startFollowViewRect delegate:weakSelf];
    [self.view addSubview:startFollowView];
}

#pragma mark - MLStartFollowViewDelegate

- (void)complete {
    [MLViewController setHomeViewController];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"welcome to melo" message:@"ようこそmeloへ" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    [MLUserDefaults setFinishedStartGuide:YES];
}

@end
