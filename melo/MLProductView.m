//
//  MLProductView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/14.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLProductView.h"

#import "MLProductController.h"
#import "MLImageManager.h"
#import "MLNotificationCenter.h"
#import "MLIndicator.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIColor+Addition.h"

NSInteger const MLProductViewBottomMargin = 20;
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
    
    NSAttributedString *_price;
    NSAttributedString *_name;
    NSAttributedString *_brand;
    NSAttributedString *_postUser;
    NSAttributedString *_productTitle;
    
    CGRect _priceRect;
    CGRect _nameRect;
    CGRect _brandRect;
    CGRect _postUserRect;
    CGRect _productTitleRect;
    
    float _lineContentY;
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
    [self calculateHeight];
}

- (void)setImageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MLProductViewImageMargin,
                                                                   MLProductViewImageMargin,
                                                                   NNViewWidth(self) - MLProductViewImageMargin * 2,
                                                                   NNViewWidth(self) - MLProductViewImageMargin * 2)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
    }
    [self loadImage];
}

- (void)loadImage {
    NSString *url = _product.fullImage;
    if (!url) {
        return;
    }
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    // TODO : observer検討
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MLNotificationCenter registerGetImageNotification:self url:url];
    
    [imageManager.imageCache queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            _imageView.image = image;
        } else {
            [[MLImageManager sharedManager] performSelectorInBackground:@selector(load:) withObject:url];
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
        _reportBtn.frame = CGRectMake(MLProductViewTextLeftMargin, NNViewHeight(_imageView) + MLProductViewImageMargin + MLProductViewTextTopMargin, width, height);
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
        _wantBtn.frame = CGRectMake(NNViewWidth(self) / 2, NNViewHeight(_imageView) + MLProductViewImageMargin + MLProductViewTextTopMargin, width, height);
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
        _buyBtn.frame = CGRectMake(NNViewMaxX(_wantBtn) + 5, NNViewHeight(_imageView) + MLProductViewImageMargin + MLProductViewTextTopMargin, width, height);
        [_buyBtn setTitle:@"購入する" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyBtn addTarget:self action:@selector(pushBuyBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buyBtn];
    }
    if (!_product || !_product.externalUrl) {
        _buyBtn.enabled = NO;
        [_buyBtn setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        _buyBtn.enabled = YES;
        [_buyBtn setBackgroundColor:[UIColor basePinkColor]];
    }
}

- (void)setUserBtn {
    if (!_userBtn) {
        _userBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_userBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_userBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_userBtn addTarget:self action:@selector(pushUserName) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_userBtn];
    }
    NSString *userName = _product.user.name;
    [_userBtn setTitle:userName forState:UIControlStateNormal];
    [_userBtn sizeToFit];
    _userBtn.frame = CGRectMake(CGRectGetMaxX(_postUserRect),
                                CGRectGetMinY(_postUserRect) - (NNViewHeight(_userBtn) - CGRectGetHeight(_postUserRect)) / 2,
                                NNViewWidth(_userBtn), NNViewHeight(_userBtn));
}

#pragma mark - CalculateHeight

- (void)calculateHeight {
    // price
    [self calculatePriceHeight];
    
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]};
    CGSize limitSize = CGSizeMake(NNViewWidth(self) - MLProductViewTextLeftMargin * 2, 1000);
    
    // brand and name
    [self calculateNameHeight:textAttributes size:limitSize];
    [self calculateBrandHeight:textAttributes size:limitSize];
    
    
    // post user
    [self calculatePostUserHeight:textAttributes size:limitSize];
    
    _lineContentY = CGRectGetMaxY(_postUserRect) + MLProductViewLineTopMargin;
    
    // collection title
    [self caluculateCollectionTitleHeight:textAttributes size:limitSize];
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(_productTitleRect) + MLProductViewBottomMargin;
    self.frame = frame;
    
    [self setNeedsDisplay];
}

- (void)calculatePriceHeight {
    if (_product.price) {
        int priceSideMargin = 20;
        
        // TODO : category化
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setGroupingSeparator:@","];
        [formatter setGroupingSize:3];
        
        NSDictionary *priceAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17]};
        NSString *price = [NSString stringWithFormat:@"¥%@", [formatter stringFromNumber:_product.price]];
        _price = [[NSAttributedString alloc] initWithString:price attributes:priceAttributes];
        
        CGSize priceSize = [_price boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        _priceRect = CGRectMake(NNViewWidth(self) / 2 - priceSize.width - priceSideMargin,
                                NNViewMinY(_wantBtn) + (NNViewHeight(_wantBtn) - priceSize.height) / 2,
                                priceSize.width, priceSize.height);
    }
}

- (void)calculateNameHeight:(NSDictionary *)attributes size:(CGSize)size {
    if (_product.name) {
        _name = [[NSAttributedString alloc] initWithString:_product.name attributes:attributes];
        CGSize nameSize = [_name boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        _nameRect = CGRectMake(MLProductViewTextLeftMargin,
                               NNViewMaxY(_wantBtn) + MLProductViewTextTopMargin,
                               nameSize.width, nameSize.height);
    } else {
        _nameRect = CGRectMake(MLProductViewTextLeftMargin,
                               NNViewMaxY(_wantBtn) + MLProductViewTextTopMargin,
                               0, 0);
    }
}

- (void)calculateBrandHeight:(NSDictionary *)attributes size:(CGSize)size {
    if (_product.brand) {
        _brand = [[NSAttributedString alloc] initWithString:_product.brand attributes:attributes];
        CGSize brandSize = [_brand boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        _brandRect = CGRectMake(MLProductViewTextLeftMargin,
                                CGRectGetMaxY(_nameRect) + 5,
                                brandSize.width, brandSize.height);
    } else {
        _brandRect = CGRectMake(MLProductViewTextLeftMargin,
                                CGRectGetMaxY(_nameRect) + 5,
                                0, 0);
    }
}

- (void)calculatePostUserHeight:(NSDictionary *)attributes size:(CGSize)size {
    _postUser = [[NSAttributedString alloc] initWithString:@"投稿者：" attributes:attributes];
    CGSize postUserSize = [_postUser boundingRectWithSize:size options:0 context:nil].size;
    _postUserRect = CGRectMake(MLProductViewTextLeftMargin,
                               CGRectGetMaxY(_brandRect) + MLProductViewTextTopMargin,
                               postUserSize.width, postUserSize.height);
}

- (void)caluculateCollectionTitleHeight:(NSDictionary *)attributes size:(CGSize)size {
    _productTitle = [[NSAttributedString alloc] initWithString:@"これをいいね！した人が見ている商品" attributes:attributes];
    CGSize productTitleSize = [_productTitle boundingRectWithSize:size options:0 context:nil].size;
    _productTitleRect = CGRectMake((NNViewWidth(self) - productTitleSize.width) / 2,
                                   _lineContentY + 10,
                                   productTitleSize.width, productTitleSize.height);

}

- (void)drawRect:(CGRect)rect {
    if (!_product || !_product.fullImage) {
        return;
    }
    
    // price
    if (_product.price) {
        [_price drawInRect:_priceRect];
    }
    
    // brand and name
    [_name drawInRect:_nameRect];
    [_brand drawInRect:_brandRect];
    
    // post user
    [_postUser drawInRect:_postUserRect];
    
    [self setUserBtn];
    
    // line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 219 / 255.f, 220 / 255.f, 220 / 255.f, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, _lineContentY);
    CGContextAddLineToPoint(context, NNViewWidth(self), _lineContentY);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);
    
    // collection title
    [_productTitle drawInRect:_productTitleRect];
}

#pragma mark - ButtonAction

- (void)pushUserName {
    if (_delegate && [_delegate respondsToSelector:@selector(pushUserName:user:)] && _product) {
        [_delegate pushUserName:self user:_product.user];
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
    if (_delegate && [_delegate respondsToSelector:@selector(pushBuy:urlString:)]) {
        [_delegate pushBuy:self urlString:_product.externalUrl];
    }
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
                              NNLog(@"%@", error);
                              [MLIndicator showErrorWithStatus:@"問題が起きていいねを解除できませんでした。"];
                          }];
}

@end
