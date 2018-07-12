//
//  BRInfoCell.h
//  BRPickerViewDemo
//
//  Created by 任波 shizhi on 2018/4/16.
//  Copyright © 2018年 91renb. shizhi All rights reserved.
//

#import <UIKit/UIKit.h>
@class BRTextField;
@class SZTextFieldCellItem;

@interface BRInfoCell : UITableViewCell
@property (nonatomic, assign) BOOL isNeed;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) BRTextField *textField;
@property (nonatomic, assign) BOOL isNext;

@property (nonatomic ,strong) SZTextFieldCellItem *rowItem;

+ (instancetype)cellWithTable:(UITableView *)tableView;

@end
