//
//  BRTextField.m
//  BRPickerViewDemo
//
//  Created by 任波 shizhi .
//  Copyright © 2017年 renb. shizhi All rights reserved.
//

#import "BRTextField.h"
#import "SZResultModel.h"
#import "SZTextFieldSelItem.h"

@interface BRTextField ()
@property (nonatomic, strong) UIView *tapView;

@end

@implementation BRTextField

- (void)setTapAcitonBlock:(BRTapAcitonBlock)tapAcitonBlock {
    _tapAcitonBlock = tapAcitonBlock;
    if (!tapAcitonBlock) {
        self.tapView.hidden = YES;
    } else {
        self.tapView.hidden = NO;
    }
}

- (void)setEndEditBlock:(BREndEditBlock)endEditBlock {
    _endEditBlock = endEditBlock;
    [self addTarget:self action:@selector(didEndEditTextField:) forControlEvents:UIControlEventEditingDidEnd];
}

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc]initWithFrame:self.bounds];
        _tapView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tapView];
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTextField)];
        [_tapView addGestureRecognizer:myTap];
    }
    return _tapView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tapView.frame = self.bounds;
}

- (void)didTapTextField {
    // 响应点击事件时，隐藏键盘
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
    NSLog(@"点击了textField，执行点击回调");
    if (self.tapAcitonBlock) {
        self.tapAcitonBlock(self, self.resultM);
    }
}

- (void)didEndEditTextField:(UITextField *)textField {
    NSLog(@"textField编辑结束，回调编辑框输入的文本内容:%@", textField.text);
    if (self.endEditBlock) {
        self.endEditBlock(textField.text);
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if ([_rowItem isMemberOfClass:[SZTextFieldSelItem class]]) {
        ((SZTextFieldSelItem*)_rowItem).str = text;
    }
}


@end
