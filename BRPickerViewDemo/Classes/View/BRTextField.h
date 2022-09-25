//
//  BRTextField.h
//  BRPickerViewDemo
//
//  Created by 任波 on 2017/8/11.
//  Copyright © 2017年 renb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZResultModel.h"
#import "SZTextFieldCellItem.h"

@class BRTextField;

typedef void(^BRTapAcitonBlock)(BRTextField *textF, SZResultModel *resultM);
typedef void(^BREndEditBlock)(NSString *text);

@interface BRTextField : UITextField<UITextFieldDelegate>
/** textField 的点击回调 */
@property (nonatomic, copy) BRTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) BREndEditBlock endEditBlock;

@property (nonatomic, strong) SZResultModel *resultM;

@property (nonatomic ,strong) SZTextFieldCellItem *rowItem;



@end
