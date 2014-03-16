//
//  MLInquiryView.m
//  melo
//
//  Created by 新保 麻粋 on 2014/03/16.
//  Copyright (c) 2014年 新保 麻粋. All rights reserved.
//

#import "MLInquiryView.h"

#import "MLInquiryController.h"
#import "MLIndicator.h"
#import "MLKeyboardToolBar.h"
#import "UIColor+Addition.h"

NSInteger MLInquiryViewFontSize = 14;
NSInteger MLInquiryViewTopMargin = 30;
NSInteger MLInquiryViewBottomMargin = 20;
UIEdgeInsets MLInquiryViewTextViewMargin = {20, 25, 20, 25};
NSInteger MLInquiryViewButtonWidth = 200;
NSInteger MLInquiryViewButtonHeight = 35;

@interface MLInquiryView () <UITextViewDelegate> {
    @private
    UITextView *_textView;
    UIButton *_sendBtn;
    MLKeyboardToolBar *_keyboardToolBar;
    float _originHeight;
}

@end

@implementation MLInquiryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setNotification];
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

- (void)setTextView:(CGFloat)messageMaxY {
    if (!_textView) {
        _textView = [UITextView new];
        _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _textView.layer.borderWidth = 1;
        _textView.layer.cornerRadius = 4;
        _textView.clipsToBounds = YES;
        _textView.delegate = self;
        [self addSubview:_textView];
        [self setKeyboardToolBar];

    }
    CGRect textViewRect = CGRectMake(MLInquiryViewTextViewMargin.left,
                                     messageMaxY + MLInquiryViewTextViewMargin.top,
                                     NNViewWidth(self) - MLInquiryViewTextViewMargin.left * 2,
                                     NNViewHeight(self) - messageMaxY - MLInquiryViewTextViewMargin.bottom * 2 - MLInquiryViewButtonHeight - MLInquiryViewBottomMargin);
    _textView.frame = textViewRect;
    _originHeight = NNViewHeight(_textView);
}

- (void)setSendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _sendBtn.backgroundColor = [UIColor basePinkColor];
        [_sendBtn setTitle:@"送信" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendInquiry:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendBtn];
    }
    _sendBtn.frame = CGRectMake((NNViewWidth(self) - MLInquiryViewButtonWidth) / 2,
                                NNViewMaxY(_textView) + MLInquiryViewTextViewMargin.bottom,
                                MLInquiryViewButtonWidth, MLInquiryViewButtonHeight);
}

- (void)setKeyboardToolBar {
    __weak MLInquiryView *weakSelf = self;
    _keyboardToolBar = [[MLKeyboardToolBar alloc] initWithFrame:CGRectMake(0, 0, NNViewWidth(self), MLKeyboardToolBarHeight)];
    _keyboardToolBar.keyboardDelegate = weakSelf;
    _textView.inputAccessoryView = _keyboardToolBar;
}

- (void)drawRect:(CGRect)rect {
    // TODO : category化
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.minimumLineHeight = 22;
    paragrahStyle.maximumLineHeight = 22;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:MLInquiryViewFontSize],
                                 NSParagraphStyleAttributeName: paragrahStyle};
    NSString *message = @"meloに対するご意見や要望、\n疑問点があればお聞かせください。\n\nどんな些細なことでも構いません。\n皆様のお声お待ちしております。";
    CGSize messageSize = [message boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGRect messageRect = CGRectMake((NNViewWidth(self) - messageSize.width) / 2, MLInquiryViewTopMargin, messageSize.width, messageSize.height);
    
    [message drawInRect:messageRect withAttributes:attributes];
    
    [self setTextView:CGRectGetMaxY(messageRect)];
    [self setSendBtn];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
}

#pragma mark - ButtonAction

- (void)sendInquiry:(UIButton *)sender {
    if ([_textView.text isEqualToString:@""]) {
        [MLAlert showSingleAlert:@"" message:@"お問い合わせ内容が入力されていません。"];
        return;
    }
    [MLIndicator show:nil];
    NSDictionary *parameter = @{@"inquiry": @{@"text": _textView.text, @"user_id": [[MLCurrentUser currentuser] id]}};
    [MLInquiryController postInquiries:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MLIndicator showSuccessWithStatus:@"送信が完了しました。"];
        _textView.text = @"";
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MLIndicator showErrorWithStatus:@"問題が発生して送信に失敗しました。"];
    }];
}

#pragma mark - KeyboardDelegate

- (void)keyboardWillShow:(NSNotification *)n {
    CGRect keyboardRect = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[n userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    keyboardRect = [self convertRect:keyboardRect fromView:nil];
    
    if ([_textView isFirstResponder]) {
        [UIView animateWithDuration:animationDuration animations:^{
            int margin = 20;
            CGRect textViewFrame = _textView.frame;
            textViewFrame.size.height = NNViewHeight(self.superview) - keyboardRect.size.height - 64 - margin * 2;
            _textView.frame = textViewFrame;
            [(UIScrollView *)self.superview setContentOffset:CGPointMake(0, NNViewMinY(_textView) - margin - 64) animated:YES];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)n {
    if ([_textView isFirstResponder]) {
        CGRect textViewFrame = _textView.frame;
        textViewFrame.size.height = _originHeight;
        _textView.frame = textViewFrame;
        [(UIScrollView *)self.superview setContentOffset:CGPointMake(0, -64) animated:YES];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView*)textView {
    NSRange selection = textView.selectedRange;
    if (textView.text.length > 0 && selection.location + selection.length == textView.text.length &&
        [textView.text characterAtIndex:textView.text.length - 1] == '\n') {
        [textView layoutSubviews];
        [textView scrollRectToVisible:CGRectMake(0, textView.contentSize.height - 1, 1, 1) animated:YES];
    } else {
        [textView scrollRangeToVisible:textView.selectedRange];
    }
}

#pragma mark - MLKeyboardToolBarDelegate

- (void)pushCompleteBtn:(MLKeyboardToolBar *)view {
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
}

@end
