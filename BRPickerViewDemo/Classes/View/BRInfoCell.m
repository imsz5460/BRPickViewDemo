//
//  BRInfoCell.m
//  BRPickerViewDemo
//
//  Created by 任波 shizhi on 2018/4/16.
//  Copyright © 2018年 91renb. shizhi All rights reserved.
//

#import "BRInfoCell.h"
#import "BRPickerViewMacro.h"
#import "BRTextField.h"
#import "SZTextFieldCellItem.h"
#import "SZTextFieldSelItem.h"


#define kLeftMargin 20
#define kRowHeight 50

@interface BRInfoCell ()
<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *needLabel;
@property (nonatomic, strong) UIImageView *nextImageView;

@property (nonatomic, strong) NSMutableDictionary *currentText;
@end

@implementation BRInfoCell


-(NSMutableDictionary *)currentText {
    if (!_currentText) {
        _currentText = [NSMutableDictionary dictionary];
    }
    return _currentText;
}

- (void)setRowItem:(SZTextFieldCellItem *)rowItem {
    _rowItem = rowItem;
    //设置数据
    [self setUpData:rowItem];
}


//设置数据
- (void)setUpData:(SZTextFieldCellItem *)rowItem {
    _rowItem = rowItem;
    //设置数据
    self.textField.tag = rowItem.celltag;
    self.textField.placeholder = rowItem.placeholder;
    self.textLabel.text = rowItem.title;
    NSString *tempstr = self.currentText[@(rowItem.celltag)];
    self.textField.text = (tempstr.length ? tempstr: nil);
    self.textField.returnKeyType = UIReturnKeyDone;
    self.isNeed = rowItem.isNeedStar;
    
    if ([rowItem isKindOfClass:[SZTextFieldCellItem class]]) {
        self.isNext = NO;
        self.textField.tapAcitonBlock = nil;
//      [self.textField removeObserver:self forKeyPath:@"text" context:nil];
    }
    
    if ([rowItem isKindOfClass:[SZTextFieldSelItem class]]) {
       self.isNext = YES;
        
     [self.textField  addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context: nil];
     self.textField.tapAcitonBlock = [(SZTextFieldSelItem *)rowItem tapAcitonBlock];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.needLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.nextImageView];
    }
    return self;
}

+ (instancetype)cellWithTable:(UITableView *)tableView {
    
    static NSString *ID = @"testCell";
    BRInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 调整cell分割线的边距：top, left, bottom, right
    self.separatorInset = UIEdgeInsetsMake(0, kLeftMargin, 0, kLeftMargin);
    self.needLabel.frame = CGRectMake(kLeftMargin - 16, 0, 16, kRowHeight);
    self.titleLabel.frame = CGRectMake(kLeftMargin, 0, 100, kRowHeight);
    self.nextImageView.frame = CGRectMake(SCREEN_WIDTH - kLeftMargin - 14, (kRowHeight - 14) / 2, 14, 14);
    self.textField.frame = CGRectMake(self.nextImageView.frame.origin.x - 200, 0, 200, kRowHeight);
    if (self.isNeed) {
        self.needLabel.hidden = NO;
    } else {
        self.needLabel.hidden = YES;
    }
    if (self.isNext) {
        self.nextImageView.hidden = NO;
    } else {
        self.nextImageView.hidden = YES;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = BR_RGB_HEX(0x464646, 1.0);
        _titleLabel.font = [UIFont systemFontOfSize:16.0f * kScaleFit];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)needLabel {
    if (!_needLabel) {
        _needLabel = [[UILabel alloc]init];
        _needLabel.backgroundColor = [UIColor clearColor];
        _needLabel.font = [UIFont systemFontOfSize:16.0f * kScaleFit];
        _needLabel.textAlignment = NSTextAlignmentCenter;
        _needLabel.textColor = [UIColor redColor];
        _needLabel.text = @"*";
    }
    return _needLabel;
}

- (BRTextField *)textField {
    if (!_textField) {
        _textField = [[BRTextField alloc]init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.font = [UIFont systemFontOfSize:16.0f * kScaleFit];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.textColor = BR_RGB_HEX(0x666666, 1.0);
        [_textField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
    }
    return _textField;
}

- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc]init];
        _nextImageView.backgroundColor = [UIColor clearColor];
        _nextImageView.image = [UIImage imageNamed:@"icon_next"];
    }
    return _nextImageView;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//  NSLog(@"%ld---%@",textField.tag,textField.text);
    //替换元素
    self.currentText[@(textField.tag)] = textField.text;
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    if (_rowItem.editingText) {
        _rowItem.editingText(textField.text);
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"] && object == self.textField) {
        if ([_rowItem isKindOfClass:[SZTextFieldSelItem class]]) {
            if (![self.currentText[@(self.textField.tag)] isEqualToString:self.textField.text]) {
               self.currentText[@(self.textField.tag)] = self.textField.text;
            }
        }
        NSLog(@"textField - 输入框内容改变,当前内容为: %@",self.textField.text);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dealloc {
   [self.textField removeObserver:self forKeyPath:@"text" context:nil];
}


@end
