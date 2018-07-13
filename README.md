# 1. 项目介绍
本项目是对BRPickerViewDemo的改进，BRPickerViewDemo示例了BRPickerView的具体用法，实现了如下效果演示的列表功能。需要强调的是本文中所说的BRPickerViewDemo和BRPickerView是有区别的。
而BRPickerView 封装的是iOS中常用的选择器组件。高度封装，只需一句代码即可完成调用，使用比较灵活支持自定义主题颜色。选择器类型主要包括：日期选择器、时间选择器、地址选择器、自定义字符串选择器。
BRPickerView项目原地址：https://github.com/91renb/BRPickerView
本项目地址：https://github.com/imsz5460/BRPickViewDemo-Post-packaging


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
- (void)setCell {
    __weak typeof (self) weakSelf = self;
    SZTextFieldCellItem *item1 = [SZTextFieldCellItem rowItemWithTitle: @"姓名" placeholder: @"请输入姓名" isNeedStar:YES];
    SZTextFieldCellItem *item2 = [SZTextFieldCellItem rowItemWithTitle: @"姓名" placeholder: @"请输入姓名" isNeedStar:NO editingBlock:^(NSString *str) {
         weakSelf.curTextField[1].text  = str;
//        或者
         self.infoModel.nameStr = str;
    }];

    SZTextFieldSelItem *item3 = [SZTextFieldSelItem rowItemWithTitle:@"性别" placeholder:@"请选择" tapAcitonBlock:^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [BRStringPickerView showStringPickerWithTitle:@"宝宝性别" dataSource:@[@"男", @"女", @"其他"] defaultSelValue:weakSelf.curTextField[2].text resultBlock:^(id selectValue) {
              strongSelf.curTextField[2].text = strongSelf.infoModel.genderStr = selectValue;
            }];
    }];
    
    SZTextFieldSelItem *item4 = [SZTextFieldSelItem rowItemWithTitle:@"出生日期" placeholder:@"请选择" tapAcitonBlock:^{
        NSDate *minDate = [NSDate br_setYear:1990 month:3 day:12];
        NSDate *maxDate = [NSDate date];
        [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:BRDatePickerModeYMD defaultSelValue:weakSelf.curTextField[3].text minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
            weakSelf.curTextField[3].text = self.infoModel.birthdayStr = selectValue;
        } cancelBlock:^{
            NSLog(@"点击了背景或取消按钮");
        }];
    }];
    
    SZTextFieldSelItem *item5 = [SZTextFieldSelItem rowItemWithTitle:@"出生时刻" placeholder:@"请选择" tapAcitonBlock:^{
        NSDate *minDate = [NSDate br_setHour:8 minute:10];
        NSDate *maxDate = [NSDate br_setHour:20 minute:35];
        [BRDatePickerView showDatePickerWithTitle:@"出生时刻" dateType:BRDatePickerModeTime defaultSelValue:weakSelf.curTextField[4].text minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:[UIColor orangeColor] resultBlock:^(NSString *selectValue) {
            weakSelf.curTextField[4].text = self.infoModel.birthtimeStr = selectValue;
        }];
    }];
    
    SZTextFieldSelItem *item6 = [SZTextFieldSelItem rowItemWithTitle:@"出生地址" placeholder:@"请选择" tapAcitonBlock:^{
        //         【转换】：以@" "自字符串为基准将字符串分离成数组，如：@"浙江省 杭州市 西湖区" ——》@[@"浙江省", @"杭州市", @"西湖区"]
        NSArray *defaultSelArr = [ weakSelf.curTextField[5].text componentsSeparatedByString:@" "];
        NSArray *dataSource = [weakSelf getAddressDataSource];  //从外部传入地区数据源
//        NSArray *dataSource = nil; // dataSource 为空时，就默认使用框架内部提供的数据源（即 BRCity.plist）
        [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:dataSource defaultSelected:defaultSelArr isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            weakSelf.curTextField[5].text = self.infoModel.addressStr = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
            NSLog(@"省[%@]：%@，%@", @(province.index), province.code, province.name);
            NSLog(@"市[%@]：%@，%@", @(city.index), city.code, city.name);
            NSLog(@"区[%@]：%@，%@", @(area.index), area.code, area.name);
            NSLog(@"--------------------");
        } cancelBlock:^{
            NSLog(@"点击了背景视图或取消按钮");
        }];
    }];
    
    SZTextFieldSelItem *item7 = [SZTextFieldSelItem rowItemWithTitle:@"学历" placeholder:@"请选择" tapAcitonBlock:^{
//        NSArray *dataSource = @[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"];
        NSString *dataSource = @"testData1.plist"; // 可以将数据源（上面的数组）放到plist文件中
        [BRStringPickerView showStringPickerWithTitle:@"学历" dataSource:dataSource defaultSelValue:weakSelf.curTextField[6].text isAutoSelect:YES themeColor:nil resultBlock:^(id selectValue) {
            weakSelf.curTextField[6].text = self.infoModel.educationStr = selectValue;
        } cancelBlock:^{
            NSLog(@"点击了背景视图或取消按钮");
        }];
    }];
    
    SZTextFieldSelItem *item8 = [SZTextFieldSelItem rowItemWithTitle:@"其他" placeholder:@"请选择" tapAcitonBlock:^{
        NSArray *dataSource = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
                    // NSString *dataSource = @"testData3.plist"; // 可以将数据源（上面的数组）放到plist文件中
                    NSArray *defaultSelArr = [weakSelf.curTextField[7].text componentsSeparatedByString:@"，"];
                    [BRStringPickerView showStringPickerWithTitle:@"自定义多列字符串" dataSource:dataSource defaultSelValue:defaultSelArr isAutoSelect:YES themeColor:BR_RGB_HEX(0xff7998, 1.0f) resultBlock:^(id selectValue) {
                        weakSelf.curTextField[7].text = self.infoModel.otherStr = [NSString stringWithFormat:@"%@，%@", selectValue[0], selectValue[1]];
                    } cancelBlock:^{
                        NSLog(@"点击了背景视图或取消按钮");
                    }];
    }];
    self.itemArray = @[item1,item2,item3,item4,item5,item6,item7,item8];
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
    //cell.textField.delegate = self;
    //保存每一个textField
    self.curTextField[indexPath.row] = cell.textField;
    //取出当前组的每一个行模型
    SZTextFieldCellItem *rowItem = self.itemArray[indexPath.row];
    //每个cell绑定tag
    rowItem.celltag = indexPath.row;
    //给Cell进行赋值.
    cell.rowItem = rowItem;
    return cell;
}
```

#后话：
如果你看过原作者的demo，你肯定注意到了我的使用方式要简洁方便很多，其实就是把一些逻辑封装到了内部，这样在使用的时候是不是方便不少呢？感谢原作者给我们提供了这么好用的选择器组件。站在巨人的肩膀上，做一个代码的搬运工，也挺好！

