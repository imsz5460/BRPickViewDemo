//
//  SZTextFieldSelItem.m
//  BRPickerViewDemo
//
//  Created by shizhi on 2018/7/13.
//  Copyright © 2018年 shizhi. All rights reserved.
//

#import "SZTextFieldSelItem.h"
#import "SZResultModel.h"

@implementation SZTextFieldSelItem

+ (instancetype)rowItemWithTitle:(NSString *)title placeholder:(NSString *)placeholder tapAcitonBlock:(BRTapAcitonBlock)tapAcitonBlock {
    SZTextFieldSelItem *item = [[self alloc] init];
    item.title = title;
    item.placeholder = placeholder;
    item.tapAcitonBlock = tapAcitonBlock;
    item.resultM = [[SZResultModel alloc] init];
    return item;
}

+ (instancetype)rowItemWithTitle:(NSString *)title placeholder:(NSString *)placeholder isNeedStar:(BOOL)isNeedStar tapAcitonBlock:(BRTapAcitonBlock)tapAcitonBlock {
    SZTextFieldSelItem *item = [[self alloc] init];
    item.title = title;
    item.placeholder = placeholder;
    item.tapAcitonBlock = tapAcitonBlock;
    item.isNeedStar = isNeedStar;
    item.resultM = [[SZResultModel alloc] init];
    return item;
}


@end
