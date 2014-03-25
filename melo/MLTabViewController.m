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
#import "UIColor+Addition.h"

@interface MLTabViewController () {
    @private
    BOOL _hide;
    UIView *_tabbarView;
    CGFloat _tabItemContentMinX;
    NSMutableArray *_itemTitles;
}

@end

@implementation MLTabViewController

- (id)init {
    self = [super init];
    if (self) {
        _selectedIndex = 2; // TO
        _items = [@[] mutableCopy];
        _itemTitles = [@[] mutableCopy];
        [self initTabbarView];
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

#pragma mark - Initialize

- (void)initTabbarView {
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, NNViewHeight(self.view) - [MLDevice tabBarHeight], NNViewWidth(self.view), [MLDevice tabBarHeight])];
    [_tabbarView setBackgroundColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:0.9]];
    [self.view addSubview:_tabbarView];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    
    [self setTabBarItems];
}

#pragma mark - Tab Getter

- (NSInteger)tabNum {
    return _viewControllers.count;
}

- (NSInteger)postTabNum {
    return [_viewControllers indexOfObject:[NSNull null]];
}

- (CGFloat)tabItemWidth {
    return (CGRectGetWidth([[UIScreen mainScreen] bounds]) - [self postTabItemWidth]) / ([self tabNum] - 1);
}

- (CGFloat)postTabItemWidth {
    return 44;
}

#pragma mark - DataSource

+ (NSArray *)itemTitles {
    return @[@"タイムライン", @"", @"マイページ"];
}

+ (NSArray *)itemImages {
    NSDictionary *timeline = @{@"nomal": @"TabBar-timeline", @"hover": @"TabBar-timelineHover"};
    NSDictionary *post = @{@"nomal": @"NavBar-postButtonWithCircle", @"hover": @"NavBar-postButtonWithCircle"};
    NSDictionary *mypage = @{@"nomal": @"TabBar-home", @"hover": @"TabBar-homeHover"};
    return @[timeline, post, mypage];
}

#pragma mark - TabViewController Method

- (void)setTabBarItems {
    NSArray *itemTitles = [self.class itemTitles];
    NSArray *itemImages = [self.class itemImages];
    for (int i = 0; i < itemTitles.count; i++) {
        [self createItem:itemTitles[i] imageUrlString:itemImages[i]];
    }
    [self selectViewController:0];
}

- (void)createItem:(NSString *)title imageUrlString:(NSDictionary *)imageUrlString {
    if (imageUrlString) {
        NSInteger tabNum = _items.count;
        
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setImage:[UIImage getPngImage:imageUrlString[@"nomal"]] forState:UIControlStateNormal];
        [itemBtn setImage:[UIImage getPngImage:imageUrlString[@"hover"]] forState:UIControlStateHighlighted];
        [itemBtn setImage:[UIImage getPngImage:imageUrlString[@"hover"]] forState:UIControlStateSelected];
        [itemBtn setSelected:YES];
        CGFloat width = [self tabItemWidth];
        if (tabNum == [self postTabNum]) {
            width = [self postTabItemWidth];
        }
        itemBtn.frame = CGRectMake(_tabItemContentMinX, 0, width, [MLDevice tabBarHeight]);
        [_tabbarView addSubview:itemBtn];
        itemBtn.tag = tabNum;
        [itemBtn addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        [_items addObject:itemBtn];
        
        if (![title isEqualToString:@""]) {
            UILabel *titleLabel = [UILabel new];
            titleLabel.frame = CGRectMake(NNViewMinX(itemBtn), NNViewMaxY(itemBtn) - 12, NNViewWidth(itemBtn), 10);
            titleLabel.text = title;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor grayColor];
            titleLabel.font = [UIFont systemFontOfSize:8];
            
            [_tabbarView addSubview:titleLabel];
            [_itemTitles addObject:titleLabel];
        } else {
            [_itemTitles addObject:[NSNull null]];
        }
        
        _tabItemContentMinX += width;
    }
}

- (void)selectViewController:(NSInteger)selectIndex {
    if ([_viewControllers count] < selectIndex) {
        return;
    }
    if (_selectedIndex == selectIndex || selectIndex == [self postTabNum]) {
        return;
    }
    [_selectedViewController.view removeFromSuperview];
    
    _selectedViewController = _viewControllers[selectIndex];
    [self.view insertSubview:_selectedViewController.view belowSubview:_tabbarView];
    [self activeTitleLabel:selectIndex];
}

- (void)activeTitleLabel:(NSInteger)selectIndex {
    if ([_itemTitles count] <= selectIndex) {
        return;
    }
    
    // selected
    UILabel *selectedTitleLabel = _itemTitles[_selectedIndex];
    UIButton *selectedBtn = _items[_selectedIndex];
    NNLog(@"-----%ld", selectIndex)
    if (selectedTitleLabel) {
        [selectedTitleLabel setTextColor:[UIColor grayColor]];
    }
    if (selectedBtn) {
        [selectedBtn setSelected:NO];
    }
    
    //select
    UILabel *selectTitleLabel = _itemTitles[selectIndex];
    UIButton *selectBtn = _items[selectIndex];
    if (selectTitleLabel) {
        [selectTitleLabel setTextColor:[UIColor activeTabColor]];
    }
    if (selectBtn) {
        [selectBtn setSelected:YES];
    }
    _selectedIndex = selectIndex;
}

#pragma mark - Tabbar

- (void)setHiddenTabBar:(BOOL)hide animation:(BOOL)animation {
    _hide = hide;
    if (animation) {
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            if (hide) {
                [self hideTabBar];
            } else {
                [self showTabBar];
            }
        }];
    } else {
        if (hide) {
            [self hideTabBar];
        } else {
            [self showTabBar];
        }
    }
}

- (void)hideTabBar {
    CGRect tabbarRect = _tabbarView.frame;
    tabbarRect.origin.y = NNViewMaxY(self.view);
    _tabbarView.frame = tabbarRect;
}

- (void)showTabBar {
    CGRect tabbarRect = _tabbarView.frame;
    tabbarRect.origin.y = NNViewMaxY(self.view) - [MLDevice tabBarHeight];
    _tabbarView.frame = tabbarRect;
}

#pragma mark - Post

- (void)selectedItem:(UIButton *)item {
    if (item.tag == [self postTabNum]) {
        [self post];
        return;
    }
    [self selectViewController:item.tag];
}

- (void)post {
    MLPostViewController *postViewController = [MLPostViewController new];
    MLModalViewController *modalViewController = [[MLModalViewController alloc] initWithRootViewController:postViewController];
    [self presentViewController:modalViewController animated:YES completion:nil];
}

@end
