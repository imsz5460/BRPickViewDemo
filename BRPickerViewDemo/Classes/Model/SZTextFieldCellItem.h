//
//  SZTextFieldCellItem.h
//  BRPickerViewDemo
//
//  Created by shizhi on 2017/8/11.
//  Copyright © 2018年 shizhi. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef void(^EditingBlock)(NSString *str);


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


+ (instancetype)rowItemWithTitle:(NSString *)title placeholder:(NSString *)placeholder isNeedStar:(BOOL)isNeedStar;
+ (instancetype)rowItemWithTitle:(NSString *)title placeholder:(NSString *)placeholder isNeedStar:(BOOL)isNeedStar editingBlock:(EditingBlock)editingText;
@end
