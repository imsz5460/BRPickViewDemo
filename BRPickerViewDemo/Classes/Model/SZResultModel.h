//
//  SZResultModel.h
//  BRPickerViewDemo
//
//  Created by 曾觉新 on 2022/9/22.
//  Copyright © 2022 91renb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BRResultModel;
@interface SZResultModel : NSObject

@property (nonatomic, strong) BRResultModel *resultModel;
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, strong) NSArray *indexes;
@property (nonatomic, strong) NSArray<BRResultModel *> *resultModelArr;

@end
NS_ASSUME_NONNULL_END
