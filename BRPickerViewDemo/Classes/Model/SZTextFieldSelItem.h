//
//  SZTextFieldSelItem.h
//  BRPickerViewDemo
//
//  Created by shizhi on 2018/7/13.
//  Copyright © 2018年 shizhi. All rights reserved.
//
#import "SZTextFieldCellItem.h"
#import "BRResultModel.h"

@class BRTextField;

typedef void(^BRTapAcitonBlock)(BRTextField *textF, SZResultModel *resultM);

@interface SZTextFieldSelItem : SZTextFieldCellItem

/** textField 的点击回调 */
@property (nonatomic, copy) BRTapAcitonBlock tapAcitonBlock;

@property (nonatomic, strong) SZResultModel *resultM;


/**
 *    title:标题
 *    tapAcitonBlock： 点击textField的回调
 *
 */

+ (instancetype)rowItemWithTitle:(NSString *)title placeholder:(NSString *)placeholder tapAcitonBlock:(BRTapAcitonBlock)tapAcitonBlock;
+ (instancetype)rowItemWithTitle:(NSString *)title placeholder:(NSString *)placeholder isNeedStar:(BOOL)isNeedStar tapAcitonBlock:(BRTapAcitonBlock)tapAcitonBlock;
@end
