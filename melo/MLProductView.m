//
//  MLProductView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductView.h"

#import "MLProduct.h"
#import "MLProductController.h"
#import "MLImageManager.h"
#import "MLNotification.h"
#import "MLIndicator.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIColor+Addition.h"

NSInteger const MLProductViewImageMargin = 20;
NSInteger const MLProductViewTextLeftMargin = 20;
NSInteger const MLProductViewTextTopMargin = 15;
NSInteger const MLProductViewLineTopMargin = 10;

@interface MLProductView () <UIActionSheetDelegate> {
    @private
    MLProduct *_product;
    UIImageView *_imageView;
    UIButton *_reportBtn;
    UIButton *_wantBtn;
    UIButton *_buyBtn;
    UIButton *_userBtn;
}

@end

@implementation MLProductView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setProduct:(MLProduct *)product {
    _product = product;
    
    [self setImageView];
    [self setReportBtn];
    [self setWantBtn];
    [self setBuyBtn];
    [self setNeedsDisplay];
}

- (void)setImageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MLProductViewImageMargin,
                                                                   MLProductViewImageMargin,
                                                                   NNViewWidth(self) - MLProductViewImageMargin * 2,
                                                                   NNViewWidth(self) - MLProductViewImageMargin * 2)];
        [self addSubview:_imageView];
    }
    [self loadImage];
}

- (void)loadImage {
    NSString *url = _product.image;
    if (!url) {
        return;
    }
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    // TODO : observer検討
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MLNotification registerGetImageNotification:self url:url];
    
    [imageManager.imageCache queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            _imageView.image = image;
        } else {
            [[MLImageManager sharedManager] performSelectorInBackground:@selector(load) withObject:url];
        }
    }];
}

- (void)loadedImage:(NSNotification *)n {
    [self performSelectorOnMainThread:@selector(_loadedImage:) withObject:[n userInfo][@"image"] waitUntilDone:YES];
}

- (void)_loadedImage:(UIImage *)image {
    _imageView.alpha = 0;
    [_imageView setImage:image];
    [UIView animateWithDuration:0.5 animations:^{
        _imageView.alpha = 1;
    }];
    [_imageView setImage:image];
}

- (void)setReportBtn {
    if (!_reportBtn) {
        int width = 45; // TODO : 画像サイズに修正
        int height = 30;
        _reportBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _reportBtn.frame = CGRectMake(MLProductViewTextLeftMargin, NNViewHeight(_imageView) + MLProductViewImageMargin, width, height);
        [_reportBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_reportBtn addTarget:self action:@selector(pushReportBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reportBtn];
    }
}

- (void)setWantBtn {
    if (!_wantBtn) {
        int width = 75; // TODO : 画像サイズに修正
        int height = 30;
        _wantBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _wantBtn.frame = CGRectMake(NNViewWidth(self) / 2, NNViewHeight(_imageView) + MLProductViewImageMargin, width, height);
        [_wantBtn setTitle:@"いいね！" forState:UIControlStateNormal];
        [_wantBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_wantBtn addTarget:self action:@selector(pushWantBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_wantBtn];
    }
    if (_product.isWant) {
        [_wantBtn setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [_wantBtn setBackgroundColor:[UIColor baseBlueColor]];
    }
}

- (void)setBuyBtn {
    if (!_buyBtn) {
        int width = 75; // TODO : 画像サイズに修正
        int height = 30;
        _buyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _buyBtn.frame = CGRectMake(NNViewMaxX(_wantBtn) + 5, NNViewHeight(_imageView) + MLProductViewImageMargin, width, height);
        [_buyBtn setTitle:@"購入する" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyBtn setBackgroundColor:[UIColor basePinkColor]];
        [self addSubview:_buyBtn];
    }
}

- (void)setUserBtn:(CGRect)postUserRect {
    if (!_userBtn) {
        _userBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_userBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_userBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_userBtn addTarget:self action:@selector(pushUserName) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_userBtn];
    }
    NSString *userName = @"シンボ マイキ";
    [_userBtn setTitle:userName forState:UIControlStateNormal];
    [_userBtn sizeToFit];
    _userBtn.frame = CGRectMake(CGRectGetMaxX(postUserRect),
                                CGRectGetMinY(postUserRect) - (NNViewHeight(_userBtn) - CGRectGetHeight(postUserRect)) / 2,
                                NNViewWidth(_userBtn), NNViewHeight(_userBtn));
}

- (void)drawRect:(CGRect)rect {
    if (!_product) {
        return;
    }
    
    // price
    int priceSideMargin = 20;
    
    // TODO : category化
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setGroupingSize:3];

    NSString *price = [NSString stringWithFormat:@"¥%@", [formatter stringFromNumber:_product.price]];
    NSDictionary *priceAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};
    CGSize priceSize = [price boundingRectWithSize:self.frame.size options:0 attributes:priceAttributes context:nil].size;
    CGRect priceRect = CGRectMake(NNViewWidth(self) / 2 - priceSize.width - priceSideMargin,
                                  NNViewMinY(_wantBtn) + (NNViewHeight(_wantBtn) - priceSize.height) / 2,
                                  priceSize.width, priceSize.height);
    [price drawInRect:priceRect withAttributes:priceAttributes];
    
    // brand and name
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]};
    NSString *name = _product.name;
    CGSize nameSize = [name boundingRectWithSize:self.frame.size options:0 attributes:textAttributes context:nil].size;
    CGRect nameRect = CGRectMake(MLProductViewTextLeftMargin,
                                  NNViewMaxY(_wantBtn) + MLProductViewTextTopMargin,
                                  nameSize.width, nameSize.height);
    [name drawInRect:nameRect withAttributes:textAttributes];
    
    NSString *brand = _product.brand;
    CGSize brandSize = [brand boundingRectWithSize:self.frame.size options:0 attributes:textAttributes context:nil].size;
    CGRect brandRect = CGRectMake(MLProductViewTextLeftMargin,
                                 CGRectGetMaxY(nameRect) + 5,
                                 brandSize.width, brandSize.height);
    [brand drawInRect:brandRect withAttributes:textAttributes];
    
    // post user
    NSString *postUser = @"投稿者：";
    CGSize postUserSize = [postUser boundingRectWithSize:self.frame.size options:0 attributes:textAttributes context:nil].size;
    CGRect postUserRect = CGRectMake(MLProductViewTextLeftMargin,
                                     CGRectGetMaxY(brandRect) + MLProductViewTextTopMargin,
                                     postUserSize.width, postUserSize.height);
    [postUser drawInRect:postUserRect withAttributes:textAttributes];
    
    [self setUserBtn:postUserRect];
    
    // line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 219 / 255.f, 220 / 255.f, 220 / 255.f, 1.0);
    CGContextBeginPath(context);
    float lineContentY = CGRectGetMaxY(postUserRect) + MLProductViewLineTopMargin;
    CGContextMoveToPoint(context, 0, lineContentY);
    CGContextAddLineToPoint(context, NNViewWidth(self), lineContentY);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
    // collection title
    NSString *productTitle = @"これをいいね！した人が見ている商品";
    CGSize productTitleSize = [productTitle boundingRectWithSize:self.frame.size options:0 attributes:textAttributes context:nil].size;
    CGRect productTitleRect = CGRectMake((NNViewWidth(self) - productTitleSize.width) / 2,
                                     lineContentY + 10,
                                     productTitleSize.width, productTitleSize.height);
    [productTitle drawInRect:productTitleRect withAttributes:textAttributes];
}

#pragma mark - ButtonAction

- (void)pushUserName {
    if (_delegate && [_delegate respondsToSelector:@selector(pushUserName:userId:)] && _product) {
        [_delegate pushUserName:self userId:_product.userId];
    }
}

- (void)pushReportBtn {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"キャンセル"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"価格が違う", @"URLが違う", @"不適切な画像", nil];
    [actionSheet showInView:[MLGetAppDelegate window]];
}

- (void)pushWantBtn {
    if (_product.isWant) {
        [self deleteWant];
    } else {
        [self postWant];
    }
}

- (void)pushBuyBtn {
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 3:
            break;
        default:
            [self report:buttonIndex];
            break;
    }
}

#pragma mark - Report

- (void)report:(NSInteger)reportType {
    [MLProductController postReport:_product.id
                         parameters:@{@"report": @{@"report_type": @(reportType)}}
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [MLAlert showSingleAlert:@"" message:@"報告をしました。"];
                            }
                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                [MLAlert showSingleAlert:@"" message:@"問題が起きて報告できませんでした。"];
                            }];
}

#pragma mark - Want

- (void)postWant {
    [MLIndicator show:nil];
    [MLProductController postWant:_product.id
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [MLIndicator showSuccessWithStatus:@"いいねしました"];
                                _product.isWant = YES;
                                [self setWantBtn];
                            }
                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                [MLIndicator showErrorWithStatus:@"問題が起きていいねできませんでした。"];
                            }];
}

- (void)deleteWant {
    [MLIndicator show:nil];
    [MLProductController deleteWant:_product.id
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [MLIndicator showSuccessWithStatus:@"いいねを解除しました。"];
                              _product.isWant = NO;
                              [self setWantBtn];
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [MLIndicator showErrorWithStatus:@"問題が起きていいねを解除できませんでした。"];
                          }];
}

@end
