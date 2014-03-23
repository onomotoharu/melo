//
//  MLEditProfileView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLEditProfileView.h"

#import "MLUserController.h"
#import "MLImageManager.h"
#import "MLNotificationCenter.h"
#import "MLIndicator.h"
#import "MLKeyboardToolBar.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIColor+Addition.h"

NSInteger MLEditProfileViewTopMargin = 40;
CGSize MLEditProfileViewImageSize = {150, 150};
CGSize MLEditProfileViewFieldSize = {200, 35};
NSInteger MLEditProfileViewFieldTopMargin = 20;
CGSize MLEditProfileViewButtonSize = {200, 35};

@interface MLEditProfileView () <UITextFieldDelegate> {
    @private
    UIButton *_imageBtn;
    UITextField *_nameField;
    UIButton *_changeBtn;
    MLKeyboardToolBar *_keyboardToolBar;
    NSString *_imageUrlString;
}

@end

@implementation MLEditProfileView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)drawRect:(CGRect)rect {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14]};
    NSString *message = @"タップして編集";
    CGSize messageSize = [message boundingRectWithSize:CGSizeMake(NNViewWidth(self), 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGRect messageRect = CGRectMake((NNViewWidth(self) - messageSize.width) / 2,
                                    MLEditProfileViewTopMargin,
                                    messageSize.width, messageSize.height);
    
    [message drawInRect:messageRect withAttributes:attributes];
    
    [self setImageBtn:CGRectGetMaxY(messageRect)];
    [self setNameField];
    [self setChangeBtn];
    [self setNotification];
}

#pragma mark - Image

- (void)setImageBtn:(CGFloat)messageMaxY {
    if (!_imageBtn) {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageBtn addTarget:self action:@selector(pushImageBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imageBtn];
        [self loadImage];
    }
    _imageBtn.frame = CGRectMake((NNViewWidth(self) - MLEditProfileViewImageSize.width) / 2,
                                 messageMaxY + MLEditProfileViewTopMargin,
                                 MLEditProfileViewImageSize.width, MLEditProfileViewImageSize.height);
}

- (void)changeImage:(UIImage *)image {
    [_imageBtn setImage:image forState:UIControlStateNormal];
}

- (void)pushImageBtn {
    if (_delegate && [_delegate respondsToSelector:@selector(pushImageBtn:)]) {
        [_delegate pushImageBtn:self];
    }
}

- (void)loadImage {
    _imageUrlString = [[MLCurrentUser currentuser] image];
    if (!_imageUrlString) {
        _imageUrlString = @"";
        return;
    }
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    // TODO : observer検討
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MLNotificationCenter registerGetImageNotification:self url:_imageUrlString];
    
    [imageManager.imageCache queryDiskCacheForKey:_imageUrlString done:^(UIImage *image, SDImageCacheType cacheType) {
        if (image) {
            [_imageBtn setImage:image forState:UIControlStateNormal];
        } else {
            [[MLImageManager sharedManager] performSelectorInBackground:@selector(load:) withObject:_imageUrlString];
        }
    }];
}

- (void)loadedImage:(NSNotification *)n {
    [self performSelectorOnMainThread:@selector(_loadedImage:) withObject:[n userInfo][@"image"] waitUntilDone:YES];
}

- (void)_loadedImage:(UIImage *)image {
    [_imageBtn setImage:image forState:UIControlStateNormal];
}

#pragma mark - Name

- (void)setNameField {
    if (!_nameField) {
        _nameField = [UITextField new];
        _nameField.text = [[MLCurrentUser currentuser] name];
        _nameField.textColor = [UIColor baseBlueColor];
        _nameField.textAlignment = NSTextAlignmentCenter;
        _nameField.returnKeyType = UIReturnKeyDone;
        _nameField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _nameField.layer.borderWidth = 1;
        _nameField.delegate = self;
        [self addSubview:_nameField];
        [self setKeyboardToolBar];
    }
     _nameField.frame = CGRectMake((NNViewWidth(self) - MLEditProfileViewFieldSize.width) / 2,
                                   NNViewMaxY(_imageBtn) + MLEditProfileViewFieldTopMargin,
                                   MLEditProfileViewFieldSize.width, MLEditProfileViewFieldSize.height);
}

- (void)setKeyboardToolBar {
    __weak MLEditProfileView *weakSelf = self;
    _keyboardToolBar = [[MLKeyboardToolBar alloc] initWithFrame:CGRectMake(0, 0, NNViewWidth(self), MLKeyboardToolBarHeight)];
    _keyboardToolBar.keyboardDelegate = weakSelf;
    _nameField.inputAccessoryView = _keyboardToolBar;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_nameField isFirstResponder]) {
        [_nameField resignFirstResponder];
    }
}

#pragma mark - MLKeyboardToolBarDelegate

- (void)pushCompleteBtn:(MLKeyboardToolBar *)view {
    if ([_nameField isFirstResponder]) {
        [_nameField resignFirstResponder];
    }
}

#pragma mark - Button

- (void)setChangeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _changeBtn.backgroundColor = [UIColor basePinkColor];
        [_changeBtn setTitle:@"変更" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(changeProfile:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_changeBtn];
    }
    _changeBtn.frame = CGRectMake((NNViewWidth(self) - MLEditProfileViewButtonSize.width) / 2,
                                  NNViewMaxY(_nameField) + MLEditProfileViewFieldTopMargin,
                                  MLEditProfileViewButtonSize.width, MLEditProfileViewButtonSize.height);
}

#pragma mark - ButtonAction

- (void)changeProfile:(UIButton *)sender {
    [MLIndicator show:@"保存中..."];
    NSDictionary *parameters = @{@"user": @{@"name": _nameField.text, @"avatar": _imageUrlString}};
    [MLUserController update:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MLIndicator showSuccessWithStatus:@"変更を保存しました。"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NNLog(@"%@", error)
        [MLIndicator showErrorWithStatus:@"問題が起きて変更に失敗しました。"];
    }];
}

#pragma mark - KeyboardDelegate

- (void)keyboardWillShow:(NSNotification *)n {
    CGRect keyboardRect = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    keyboardRect = [self convertRect:keyboardRect fromView:nil];
    
    if ([_nameField isFirstResponder]) {
        [UIView animateWithDuration:animationDuration animations:^{
            [(UIScrollView *)self.superview setContentOffset:CGPointMake(0, 100) animated:YES];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)n {
    if ([_nameField isFirstResponder]) {
        [(UIScrollView *)self.superview setContentOffset:CGPointMake(0, - [MLDevice topMargin:YES]) animated:YES];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_nameField isFirstResponder]) {
        [_nameField resignFirstResponder];
    }
    return YES;
}

@end
