//
//  SZTextFieldCellItem.h
//  BRPickerViewDemo
//
//  Created by shizhi on 2018/7/13.
//  Copyright © 2018年 shizhi. All rights reserved.
//
#import <Foundation/Foundation.h>
@class BRTextField;
@class SZResultModel;

typedef void(^EditingBlock)(BRTextField *textF, NSString *str);


@interface SZTextFieldCellItem : NSObject
//标题
@property (nonatomic, copy) NSString *title;
//占位文字
@property (nonatomic,copy) NSString *placeholder;
//行号
@property (nonatomic,assign) NSInteger celltag;
@property (nonatomic,assign) BOOL isNeedStar;//星标

/** textField 的点击回调 */
@property (nonatomic, copy) EditingBlock editingText;

@property (nonatomic, copy) NSString *str;



+ (instancetype)rowItemWithTitle:(NSString *)title placeholder:(NSString *)placeholder isNeedStar:(BOOL)isNeedStar;
+ (instancetype)rowItemWithTitle:(NSString *)title placeholder:(NSString *)placeholder isNeedStar:(BOOL)isNeedStar editingBlock:(EditingBlock)editingText;
@end
