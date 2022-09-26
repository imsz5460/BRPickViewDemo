# 1. 项目介绍
本项目是对BRPickerView的优雅封装，实现了如下效果演示的列表功能。
BRPickerView 是iOS中常用的选择器组件。高度封装，只需一句代码即可完成调用，使用比较灵活支持自定义主题颜色。选择器类型主要包括：日期选择器、时间选择器、地址选择器、自定义字符串选择器。

BRPickerView项目原地址：https://github.com/91renb/BRPickerView


# 2. 效果演示

查看并运行 `BRPickerViewDemo.xcodeproj`

| ![效果图1.gif](https://upload-images.jianshu.io/upload_images/4320229-18cb883107d9db4d.gif?imageMogr2/auto-orient/strip) | ![效果图2.gif](https://upload-images.jianshu.io/upload_images/4320229-bb9643f32d1eca75.gif?imageMogr2/auto-orient/strip) |
| :--------------------------------------: | :--------------------------------------: |
|               框架Demo运行效果图1               |               框架Demo运行效果图2               |


# 3. 系统要求

- iOS 8.0+
- ARC

# 4. 我为什么对原demo进行修改
BRPickerView原作者给出的demo，即textField列表，其实是APP中常用的一个功能模块。可能是原作者重点不在于该列表的实现而在于选择器BRPickerView，我发现这个demo的使用方式很繁琐，开发者需要在好些个不同的方法中编写相应的代码，而且这些代码之间还需要建立对应的逻辑关系，如果某个方法有疏漏，就容易造成数据错乱。本人在使用过程中就因为疏漏导致cell复用而数据错乱，一度以为该demo是有严重bug的。这也是我对该demo进行改进的初衷。特别说明的是我并没有对BRPickerView进行修改，希望大家能够明白。这样在更新BRPickerView的时候不要有顾虑。

# 5. 使用
#### 5.1. 初始化
我封装了两个模型类：SZTextFieldCellItem和SZTextFieldSelItem，分别对应普通的textField cell和带选择功能的textField cell。看代码就明白了：
```objective-c
- (void)setCells {
    __weak typeof (self) weakSelf = self;
    SZTextFieldCellItem *item0 = [SZTextFieldCellItem rowItemWithTitle: @"姓名" placeholder: @"请输入姓名" isNeedStar:YES editingBlock:^(BRTextField *textF, NSString *str) { 
//        weakSelf.infoModel.nameStr = str;
    }];
    
    SZTextFieldSelItem *item1 = [SZTextFieldSelItem rowItemWithTitle:@"性别" placeholder:@"请选择" tapAcitonBlock:^(BRTextField *textF, SZResultModel *resultM) {
       
        // 性别
        BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
        stringPickerView.pickerMode = BRStringPickerComponentSingle;
        stringPickerView.title = @"请选择性别";
        stringPickerView.dataSourceArr = @[@"男", @"女", @"其他"];
        stringPickerView.selectIndex = resultM.resultModel.index;
        
        stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
            resultM.resultModel = resultModel;
            textF.text = self.infoModel.genderStr = resultModel.value;
        };
        [stringPickerView show];
    }];
    
    SZTextFieldSelItem *item2 = [SZTextFieldSelItem rowItemWithTitle:@"出生日期" placeholder:@"请选择" tapAcitonBlock:^(BRTextField *textF, SZResultModel *resultM) {
    
        // 出生年月日
        BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
        datePickerView.pickerMode = BRDatePickerModeYMD;
        datePickerView.title = @"请选择年月日";
        datePickerView.selectDate = resultM.selectDate;
        datePickerView.minDate = [NSDate br_setYear:2018 month:3 day:10];
        datePickerView.maxDate = [NSDate br_setYear:2025 month:10 day:20];
        datePickerView.isAutoSelect = YES;
        //datePickerView.monthNames = @[@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月"];
        //datePickerView.customUnit = @{@"year": @"Y", @"month": @"M", @"day": @"D", @"hour": @"H", @"minute": @"M", @"second": @"S"};
        // 指定不可选择的日期
        //datePickerView.nonSelectableDates = @[[NSDate br_setYear:2020 month:8 day:1], [NSDate br_setYear:2020 month:9 day:10]];
        datePickerView.keyView = self.view; // 将组件 datePickerView 添加到 self.view 上，默认是添加到 keyWindow 上
        datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            resultM.selectDate = selectDate;
            textF.text = weakSelf.infoModel.birthdayStr = selectValue;
            NSLog(@"selectValue=%@", selectValue);
            NSLog(@"selectDate=%@", selectDate);
            NSLog(@"---------------------------------");

        };

        datePickerView.resultRangeBlock = ^(NSDate * _Nullable selectStartDate, NSDate * _Nullable selectEndDate, NSString * _Nullable selectValue) {
            NSLog(@"selectValue=%@", selectValue);
            NSLog(@"selectStartDate=%@", selectStartDate);
            NSLog(@"selectStartDate=%@", selectEndDate);
            NSLog(@"---------------------------------");
        };

        // 设置年份背景
        UILabel *yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 216)];
        yearLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        yearLabel.backgroundColor = [UIColor clearColor];
        yearLabel.textAlignment = NSTextAlignmentCenter;
        yearLabel.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2f];
        yearLabel.font = [UIFont boldSystemFontOfSize:100.0f];
        NSString *yearString = resultM.selectDate ? @(resultM.selectDate.br_year).stringValue : @([NSDate date].br_year).stringValue;
        if (self.itemArray[2].str && [self.itemArray[2].str containsString:@"自定义"]) {
            yearString = @"";
        }
        yearLabel.text = yearString;
        [datePickerView.alertView addSubview:yearLabel];
        // 滚动选择器，动态更新年份
        datePickerView.changeBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            yearLabel.text = selectDate ? @(selectDate.br_year).stringValue : @"";

        };

        BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
        customStyle.pickerColor = [UIColor clearColor];
        customStyle.selectRowTextColor = [UIColor blueColor];
        datePickerView.pickerStyle = customStyle;

        [datePickerView show];
    }];
    
    SZTextFieldSelItem *item3 = [SZTextFieldSelItem rowItemWithTitle:@"出生时刻" placeholder:@"请选择" tapAcitonBlock:^(BRTextField *textF, SZResultModel *resultM) {
        // 出生时刻
        BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
        datePickerView.pickerMode = BRDatePickerModeHMS;
        datePickerView.title = @"出生时刻";
        datePickerView.selectDate = resultM.selectDate;

        datePickerView.isAutoSelect = YES;
        datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
            resultM.selectDate = selectDate;
            textF.text = /*weakSelf.infoModel.birthtimeStr =*/ selectValue;
        };

        // 自定义弹框样式
        BRPickerStyle *customStyle = [BRPickerStyle pickerStyleWithThemeColor:[UIColor darkGrayColor]];
        datePickerView.pickerStyle = customStyle;
        [datePickerView show];
    }];
    
    SZTextFieldCellItem *item4 = [SZTextFieldCellItem rowItemWithTitle: @"联系方式" placeholder: @"请输入联系方式" isNeedStar:YES editingBlock:^(BRTextField *textF, NSString *str) {
//        weakSelf.infoModel.nameStr = str;
    }];
    
    SZTextFieldSelItem *item5 = [SZTextFieldSelItem rowItemWithTitle:@"出生地址" placeholder:@"请选择" tapAcitonBlock:^(BRTextField *textF, SZResultModel *resultM) {
//        //         【转换】：以@" "自字符串为基准将字符串分离成数组，如：@"浙江省 杭州市 西湖区" ——》@[@"浙江省", @"杭州市", @"西湖区"]
        NSArray *dataSource = [weakSelf getAddressDataSource];  //从外部传入地区数据源
        // 地区
        BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]init];
        addressPickerView.pickerMode = BRAddressPickerModeArea;
        addressPickerView.title = @"请选择地区";
        addressPickerView.selectIndexs = resultM.indexes;
        addressPickerView.dataSourceArr = dataSource;
        addressPickerView.isAutoSelect = YES;
        addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            resultM.indexes = @[@(province.index), @(city.index), @(area.index)];
            NSLog(@"省[%@]：%@，%@", @(province.index), province.code, province.name);
            NSLog(@"市[%@]：%@，%@", @(city.index), city.code, city.name);
            NSLog(@"区[%@]：%@，%@", @(area.index), area.code, area.name);
            NSLog(@"--------------------");
            textF.text = weakSelf.infoModel.addressStr = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
        };
        [addressPickerView show];
    }];

    SZTextFieldSelItem *item6 = [SZTextFieldSelItem rowItemWithTitle:@"学历" placeholder:@"请选择" tapAcitonBlock:^(BRTextField *textF, SZResultModel *resultM) {
        // 学历
        NSArray *dataSource = @[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"];
        BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
        stringPickerView.pickerMode = BRStringPickerComponentSingle;
        stringPickerView.title = @"请选择学历";
        stringPickerView.dataSourceArr = dataSource;
        stringPickerView.selectIndex = resultM.resultModel.index;
        stringPickerView.isAutoSelect = YES;
        stringPickerView.resultModelBlock = ^(BRResultModel *resultModel) {
            resultM.resultModel = resultModel;
            textF.text = /*weakSelf.infoModel.educationStr = */resultModel.value;
        };

        // 自定义弹框样式
        BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
        if (@available(iOS 13.0, *)) {
            customStyle.pickerColor = [UIColor secondarySystemBackgroundColor];
        } else {
            customStyle.pickerColor = BR_RGB_HEX(0xf2f2f7, 1.0f);
        }
        customStyle.separatorColor = [UIColor clearColor];
        stringPickerView.pickerStyle = customStyle;

        [stringPickerView show];
    }];

    SZTextFieldSelItem *item7 = [SZTextFieldSelItem rowItemWithTitle:@"其他" placeholder:@"请选择" tapAcitonBlock:^(BRTextField *textF, SZResultModel *resultM) {
        /// 多列字符串
        NSArray *dataSource = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
        BRStringPickerView *stringPickerView = [[BRStringPickerView alloc]init];
        stringPickerView.pickerMode = BRStringPickerComponentMulti;
        stringPickerView.title = @"其他";
        stringPickerView.dataSourceArr = dataSource;
        stringPickerView.selectIndexs = @[@(resultM.resultModelArr[0].index),@(resultM.resultModelArr[1].index)];
        stringPickerView.isAutoSelect = YES;
        stringPickerView.resultModelArrayBlock = ^(NSArray<BRResultModel *> *resultModelArr) {
            resultM.resultModelArr = resultModelArr;
            textF.text = /*weakSelf.infoModel.otherStr = */[NSString stringWithFormat:@"%@ %@", resultModelArr[0].value, resultModelArr[1].value];
        };

        // 使用模板样式2
        stringPickerView.pickerStyle = [BRPickerStyle pickerStyleWithDoneTextColor:[UIColor blueColor]];
        [stringPickerView show];

    }];
    self.itemArray = @[item0,item1,item2,item3,item4,item5,item6,item7];
}
说明：如果该行 是带选择器的cell，则每个item方法里调用的block就是点击textFiled所实现的方法。这样你甚至可以灵活改用其他选择器控件。关于BRPickerView选择器的详细使用方法可以参阅原作者项目说明。
```
#### 5.2. 实现数据源方法
```objective-c
//一组当中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

//返回每一组当中每一行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRInfoCell *cell = [BRInfoCell cellWithTable:tableView];
    cell.textField.delegate = self;
    //取出当前组的每一个行模型
    SZTextFieldCellItem *rowItem = self.itemArray[indexPath.row];
    //给Cell进行赋值.
    cell.rowItem = rowItem;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
```

# 6. 后话：
如果你看过原作者的demo，你肯定注意到了我的使用方式要简洁方便很多，其实就是把一些逻辑封装到了内部，这样在使用的时候是不是方便不少呢？感谢原作者给我们提供了这么好用的选择器组件。站在巨人的肩膀上，做一个代码的搬运工，也挺好！

