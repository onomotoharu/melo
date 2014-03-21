//
//  MLWebViewController.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/21.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLWebViewController.h"

#import "UIColor+Addition.h"

@interface MLWebViewController () <UIWebViewDelegate, UIActionSheetDelegate> {
@private
    NSURL *_url;
    UIWebView *_webView;
    UIBarButtonItem *_goForwardBtn;
    UIBarButtonItem *_goBackBtn;
}
@end

@implementation MLWebViewController

- (id)initWithUrl:(NSString *)urlString
{
    self = [super init];
    if (self) {
        [self setUrl:[NSURL URLWithString:urlString]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)setUrl:(NSURL *)url {
    _url = url;
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, NNViewWidth(self.view), NNViewHeight(self.view) - [MLDevice tabBarHeight])];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        
        [self.view addSubview:_webView];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:request];
    self.title = @"読み込み中";
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
    
    UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    UIBarButtonItem *actionBtn = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action)];
    
    UIBarButtonItem *fixspacer = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:fixspacer, wrapperGoBackBtn, fixspacer, _goForwardBtn, fixspacer, refreshBtn, fixspacer, actionBtn, fixspacer, nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack {
    [_webView goBack];
}

- (void)goForward {
    [_webView goForward];
}

- (void)refresh {
    [_webView reload];
}

- (void)action {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"キャンセル"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"safariで開く", @"リンクをコピー", nil];
    
    [actionSheet showInView:[MLGetAppDelegate window]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_webView stringByEvaluatingJavaScriptFromString:@"document.URL"]]];
            break;
        case 1: {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setValue:[_webView stringByEvaluatingJavaScriptFromString:@"document.URL"] forPasteboardType:@"public.utf8-plain-text"];
        }
        default:
            break;
    }
}

-(void)webViewDidStartLoad:(UIWebView*)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self setToolBarItemsControl];
}

-(void)webViewDidFinishLoad:(UIWebView*)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self setToolBarItemsControl];
}

@end
