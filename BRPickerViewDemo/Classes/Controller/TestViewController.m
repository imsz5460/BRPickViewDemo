//
//  TestViewController.m
//  BRPickerViewDemo
//
//

#import "TestViewController.h"
#import "BRPickerView.h"
#import "BRInfoCell.h"
#import "BRInfoModel.h"
#import "BRPickerViewMacro.h"
#import "SZTextFieldSelItem.h"
#import "SZTextFieldCellItem.h"
#import "BRTextField.h"
#import "SZResultModel.h"

@interface TestViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BRInfoModel *infoModel;
@property (nonatomic, strong) NSArray <SZTextFieldCellItem *>*itemArray;



@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试选择器的使用";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveBtn)];
    [self loadData];
    [self initUI];
    
    [self setCells];
}

- (void)loadData {
//    NSLog(@"-----加载数据-----");
//    self.infoModel.nameStr = @"";
//    self.infoModel.genderStr = @"";
//    self.infoModel.birthdayStr = @"";
//    self.infoModel.birthtimeStr = @"";
//    self.infoModel.phoneStr = @"";
//    self.infoModel.addressStr = @"";
//    self.infoModel.educationStr = @"";
//    self.infoModel.otherStr = @"";
}

- (void)initUI {
    self.tableView.hidden = NO;
}

- (void)clickSaveBtn {
    NSLog(@"-----保存数据-----");
//    方法一
//    NSLog(@"姓名：%@", self.infoModel.nameStr);
//    NSLog(@"性别：%@", self.infoModel.genderStr);
//    NSLog(@"出生日期：%@", self.infoModel.birthdayStr);
//    NSLog(@"出生时刻：%@", self.infoModel.birthtimeStr);
//    NSLog(@"联系方式：%@", self.infoModel.phoneStr);
//    NSLog(@"地址：%@", self.infoModel.addressStr);
//    NSLog(@"学历：%@", self.infoModel.educationStr);
//    NSLog(@"其它：%@", self.infoModel.otherStr);
    
//    方法二
    NSLog(@"姓名：%@", self.itemArray[0].str);
    NSLog(@"性别：%@", self.itemArray[1].str);
    NSLog(@"出生日期：%@", self.itemArray[2].str);
    NSLog(@"出生时刻：%@", self.itemArray[3].str);
    NSLog(@"联系方式：%@", self.itemArray[4].str);
    NSLog(@"地址：%@", self.itemArray[5].str);
    NSLog(@"学历：%@", self.itemArray[6].str);
    NSLog(@"其它：%@", self.itemArray[7].str);
    
}

- (UITableView *)tableView {
    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        //使用UITableViewController可以自动防止键盘遮挡输入文字，iOS 12以后这个功能失效了（iOS11不确定是否有效）
        _tableView = [[UITableViewController alloc] initWithStyle: UITableViewStylePlain].tableView;
        _tableView.frame = self.view.bounds;
        if (@available(iOS 13.0, *)) {
            _tableView.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            _tableView.backgroundColor = [UIColor whiteColor];
        }
        _tableView.backgroundColor = [UIColor whiteColor];
        // 设置子视图的大小随着父视图变化
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

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
//        NSDate *minDate = [NSDate br_setHour:8 minute:10];
//        NSDate *maxDate = [NSDate br_setHour:20 minute:35];

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
//        addressPickerView.selectValues = [self.infoModel.addressStr componentsSeparatedByString:@" "];
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
//        stringPickerView.plistName = @"testData1.plist";
        stringPickerView.dataSourceArr = dataSource;
        stringPickerView.selectIndex = resultM.resultModel.index;
//        stringPickerView.selectValue = self.infoModel.educationStr;
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


#pragma mark - UITableViewDataSource, UITableViewDelegate
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

#pragma mark - 获取地区数据源
- (NSArray *)getAddressDataSource {
    // 加载地区数据源（实际开发中这里可以写网络请求，从服务端请求数据。可以把 BRCity.json 文件的数据放到服务端去维护，通过接口获取这个数据源数组）
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BRCity.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *dataSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    return dataSource;
}

//设置return键位退出
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BRInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[BRInfoModel alloc]init];
    }
    return _infoModel;
}
#warning - 上面infoModel不是必需的，可以采用itemArray数组赋值的方式。

@end
