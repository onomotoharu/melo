//
//  MLPostViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/21.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLPostViewController.h"

#import "MLProductController.h"
#import "MLStoreTableView.h"
#import "MLPostViewController.h"
#import "MLModalViewController.h"
#import "MLProductPhotosViewController.h"
#import "MLIndicator.h"
#import "UIColor+Addition.h"

NSString *GoogleSearchUrl = @"https://www.google.com/search?q=";

@interface MLPostViewController () <UIWebViewDelegate, UISearchBarDelegate> {
@private
    UIWebView *_webView;
    MLStoreTableView *_tableView;
    UISearchBar *_searchBar;
    UIBarButtonItem *_goForwardBtn;
    UIBarButtonItem *_goBackBtn;
}
@end

@implementation MLPostViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setWebView];
    [self setTableView];
    [self setNotification];
    [self setSearchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self makeToolBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_webView stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize

- (void)setNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setWebView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, NNViewWidth(self.view), NNViewHeight(self.view) - [MLDevice tabBarHeight])];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
}

- (void)setSearchBar {
    _searchBar = [UISearchBar new];
    _searchBar.placeholder = @"Enter a store URL";
    _searchBar.keyboardType = UIKeyboardTypeURL;
    self.navigationItem.titleView = _searchBar;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, NNViewWidth(self.view), 44);
    _searchBar.delegate = self;
    
    [_searchBar becomeFirstResponder];
}

- (void)setTableView {
    __weak MLPostViewController *weakSelf = self;
    CGRect tableViewRect = CGRectMake(0, [MLDevice topMargin:YES], NNViewWidth(self.view), NNViewHeight(self.view) - [MLDevice tabBarHeight] - [MLDevice topMargin:YES]);
    _tableView = [[MLStoreTableView alloc] initWithFrame:tableViewRect];
    _tableView.controllerDelegate = weakSelf;
    
    //[self.view addSubview:_tableView];
}

- (void)makeToolBar {
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    self.navigationController.toolbar.barTintColor = [UIColor whiteColor];
    self.navigationController.toolbar.tintColor = [UIColor lightGrayColor];
    self.navigationController.toolbar.translucent = NO;
    
    _goBackBtn = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goBack)];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
    bar.barTintColor = [UIColor whiteColor];
    bar.tintColor = [UIColor lightGrayColor];
    bar.translucent = NO;
    bar.transform = CGAffineTransformMakeScale(-1,1);
    [bar setItems:[NSArray arrayWithObject:_goBackBtn]];
    UIBarButtonItem *wrapperGoBackBtn = [[UIBarButtonItem alloc] initWithCustomView:bar];
    _goBackBtn.enabled = NO;
    
    _goForwardBtn = [[UIBarButtonItem alloc]
                     initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goForward)];
    _goForwardBtn.enabled = NO;
    
    UIButton *postUIBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postUIBtn.frame = CGRectMake(0, 0, 120, 36);
    [postUIBtn setBackgroundColor:[UIColor basePinkColor]];
    [postUIBtn setTitle:@"Post Product" forState:UIControlStateNormal];
    [postUIBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postUIBtn addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *postBtn = [[UIBarButtonItem alloc] initWithCustomView:postUIBtn];
    
    UIBarButtonItem *fixspacer = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:wrapperGoBackBtn, _goForwardBtn, fixspacer, postBtn, nil];
    self.toolbarItems = items;
}

- (void)setToolBarItemsControl {
    if ([_webView canGoBack]) {
        _goBackBtn.enabled = YES;
    } else {
        _goBackBtn.enabled = NO;
    }
    
    if ([_webView canGoForward]) {
        _goForwardBtn.enabled = YES;
    } else {
        _goForwardBtn.enabled = NO;
    }
}

#pragma mark - ButtonAction

- (void)goBack {
    [_webView goBack];
}

- (void)goForward {
    [_webView goForward];
}

#pragma mark - Search

- (void)search:(NSString *)urlString {
    [_searchBar setText:urlString];
    [MLIndicator show:@"searching..."];
    [_tableView removeFromSuperview];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
    [_searchBar resignFirstResponder];
}

#pragma mark - Post

- (void)post {
    [MLIndicator show:@"画像取得中..."];
    NSString *externalUrl = [_webView.request.URL absoluteString];
    externalUrl = [externalUrl stringByReplacingOccurrencesOfString:@"sp/" withString:@""];
    NSDictionary *parameter = [MLProductController createParameter:@{@"external_url": externalUrl}];
    [MLProductController newProduct:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"photos"] count] == 0) {
            [self failurePost];
        } else {
            [self successPost:responseObject[@"photos"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self failurePost];
    }];
}

- (void)successPost:(NSArray *)photos {
    MLProductPhotosViewController *photosViewController = [MLProductPhotosViewController new];
    MLModalViewController *modalViewController = [[MLModalViewController alloc] initWithRootViewController:photosViewController];
    modalViewController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:modalViewController animated:NO completion:^{
        [photosViewController setPhotos:photos];
        [photosViewController setParameters:@{@"external_url": [_webView.request.URL absoluteString]}];
        [MLIndicator dissmiss];
    }];
}

- (void)failurePost {
    [MLIndicator showErrorWithStatus:@"このページでは画像の取得ができませんでした。"];
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView*)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self setToolBarItemsControl];
}

-(void)webViewDidFinishLoad:(UIWebView*)webView {
    [MLIndicator dissmiss];
    [_searchBar setText:[_webView.request.URL absoluteString]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self setToolBarItemsControl];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        [MLIndicator showErrorWithStatus:@"読み込みに失敗しました。"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    NSString *searchString = [NSString stringWithFormat:@"%@%@", GoogleSearchUrl, searchBar.text];
    NSString *encordSearchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self search:encordSearchString];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addSubview:_tableView];
}

#pragma mark - MLStoreTableViewDelegate

- (void)didSelectRow:(MLStoreTableView *)view urlString:(NSString *)urlString {
    [self search:urlString];
}

#pragma mark - KeyboardDelegate

- (void)keyboardWillShow:(NSNotification *)n {
    CGRect keyboardRect = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    [UIView animateWithDuration:animationDuration animations:^{
        _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top, 0, CGRectGetHeight(keyboardRect) - [MLDevice tabBarHeight], 0);
    }];
}

- (void)keyboardWillHide:(NSNotification*)n {
    _tableView.contentInset = UIEdgeInsetsMake(_tableView.contentInset.top, 0, 0, 0);
}

@end
