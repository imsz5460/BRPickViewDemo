//
//  TestViewController.m
//  BRPickerViewDemo
//
//  Created by 任波 shizhi on 2017/8/11.
//  Copyright © 2017年 91renb. shizhi All rights reserved.
//

#import "TestViewController.h"
#import "BRPickerView.h"
#import "BRInfoCell.h"
#import "BRInfoModel.h"
#import "BRPickerViewMacro.h"
#import "SZTextFieldSelItem.h"
#import "SZTextFieldCellItem.h"
#import "BRTextField.h"

@interface TestViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BRInfoModel *infoModel;
@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) NSMutableArray <BRInfoCell *>*tempArr;
@property (nonatomic, strong) NSMutableArray <BRTextField *>*curTextField;


@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试选择器的使用";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveBtn)];
    [self loadData];
    [self initUI];
    
    [self setGroup0];
}

- (void)loadData {
    NSLog(@"-----加载数据-----");
    self.infoModel.nameStr = @"";
    self.infoModel.genderStr = @"";
    self.infoModel.birthdayStr = @"";
    self.infoModel.birthtimeStr = @"";
    self.infoModel.phoneStr = @"";
    self.infoModel.addressStr = @"";
    self.infoModel.educationStr = @"";
    self.infoModel.otherStr = @"";
}

- (void)initUI {
    self.tableView.hidden = NO;
}

- (void)clickSaveBtn {
    NSLog(@"-----保存数据-----");
    NSLog(@"姓名：%@", self.infoModel.nameStr);
    NSLog(@"性别：%@", self.infoModel.genderStr);
    NSLog(@"出生日期：%@", self.infoModel.birthdayStr);
    NSLog(@"出生时刻：%@", self.infoModel.birthtimeStr);
    NSLog(@"联系方式：%@", self.infoModel.phoneStr);
    NSLog(@"地址：%@", self.infoModel.addressStr);
    NSLog(@"学历：%@", self.infoModel.educationStr);
    NSLog(@"其它：%@", self.infoModel.otherStr);
    
//    方法二
    NSLog(@"姓名：%@", self.tempArr[0].textField.text);
    NSLog(@"性别：%@", self.tempArr[1].textField.text);
//    方法三
    NSLog(@"姓名：%@", self.curTextField[0].text);
    NSLog(@"性别：%@", self.curTextField[1].text);
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
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


//设置一组
- (void)setGroup0 {
    __weak typeof (self) weakSelf = self;
    SZTextFieldCellItem *item0 = [SZTextFieldCellItem rowItemWithTitle: @"姓名" placeholder: @"请输入姓名" isNeedStar:YES editingBlock:^(NSString *str) {
        weakSelf.curTextField[0].text = str;
        //        或者
        weakSelf.infoModel.nameStr = str;
    }];

    SZTextFieldSelItem *item1 = [SZTextFieldSelItem rowItemWithTitle:@"性别" placeholder:@"请选择" tapAcitonBlock:^{
        [BRStringPickerView showStringPickerWithTitle:@"宝宝性别" dataSource:@[@"男", @"女", @"其他"] defaultSelValue:weakSelf.curTextField[1].text resultBlock:^(id selectValue) {
            weakSelf.curTextField[1].text = weakSelf.infoModel.genderStr = selectValue;
        }];
    }];
    
    SZTextFieldSelItem *item2 = [SZTextFieldSelItem rowItemWithTitle:@"出生日期" placeholder:@"请选择" tapAcitonBlock:^{
        NSDate *minDate = [NSDate br_setYear:1990 month:3 day:12];
        NSDate *maxDate = [NSDate date];
        [BRDatePickerView showDatePickerWithTitle:@"出生日期" dateType:BRDatePickerModeYMD defaultSelValue:weakSelf.curTextField[2].text minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:nil resultBlock:^(NSString *selectValue) {
            weakSelf.curTextField[2].text = weakSelf.infoModel.birthdayStr = selectValue;
        } cancelBlock:^{
            NSLog(@"点击了背景或取消按钮");
        }];
    }];
    
    SZTextFieldSelItem *item3 = [SZTextFieldSelItem rowItemWithTitle:@"出生时刻" placeholder:@"请选择" tapAcitonBlock:^{
        NSDate *minDate = [NSDate br_setHour:8 minute:10];
        NSDate *maxDate = [NSDate br_setHour:20 minute:35];
        [BRDatePickerView showDatePickerWithTitle:@"出生时刻" dateType:BRDatePickerModeTime defaultSelValue:weakSelf.curTextField[3].text minDate:minDate maxDate:maxDate isAutoSelect:YES themeColor:[UIColor orangeColor] resultBlock:^(NSString *selectValue) {
            weakSelf.curTextField[3].text = weakSelf.infoModel.birthtimeStr = selectValue;
        }];
    }];
    
    SZTextFieldCellItem *item4 = [SZTextFieldCellItem rowItemWithTitle: @"联系方式" placeholder: @"请输入联系方式" isNeedStar:YES editingBlock:^(NSString *str) {
        
        weakSelf.curTextField[4].text = str;
        //        或者
        weakSelf.infoModel.nameStr = str;
        
    }];
    
    SZTextFieldSelItem *item5 = [SZTextFieldSelItem rowItemWithTitle:@"出生地址" placeholder:@"请选择" tapAcitonBlock:^{
        //         【转换】：以@" "自字符串为基准将字符串分离成数组，如：@"浙江省 杭州市 西湖区" ——》@[@"浙江省", @"杭州市", @"西湖区"]
        NSArray *defaultSelArr = [ weakSelf.curTextField[5].text componentsSeparatedByString:@" "];
        NSArray *dataSource = [weakSelf getAddressDataSource];  //从外部传入地区数据源
//        NSArray *dataSource = nil; // dataSource 为空时，就默认使用框架内部提供的数据源（即 BRCity.plist）
        [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:dataSource defaultSelected:defaultSelArr isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            weakSelf.curTextField[5].text = weakSelf.infoModel.addressStr = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
            NSLog(@"省[%@]：%@，%@", @(province.index), province.code, province.name);
            NSLog(@"市[%@]：%@，%@", @(city.index), city.code, city.name);
            NSLog(@"区[%@]：%@，%@", @(area.index), area.code, area.name);
            NSLog(@"--------------------");
        } cancelBlock:^{
            NSLog(@"点击了背景视图或取消按钮");
        }];
    }];
    
    SZTextFieldSelItem *item6 = [SZTextFieldSelItem rowItemWithTitle:@"学历" placeholder:@"请选择" tapAcitonBlock:^{
//        NSArray *dataSource = @[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"];
        NSString *dataSource = @"testData1.plist"; // 可以将数据源（上面的数组）放到plist文件中
        [BRStringPickerView showStringPickerWithTitle:@"学历" dataSource:dataSource defaultSelValue:weakSelf.curTextField[6].text isAutoSelect:YES themeColor:nil resultBlock:^(id selectValue) {
            weakSelf.curTextField[6].text = weakSelf.infoModel.educationStr = selectValue;
        } cancelBlock:^{
            NSLog(@"点击了背景视图或取消按钮");
        }];
    }];
    
    SZTextFieldSelItem *item7 = [SZTextFieldSelItem rowItemWithTitle:@"其他" placeholder:@"请选择" tapAcitonBlock:^{
        NSArray *dataSource = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
        // NSString *dataSource = @"testData3.plist"; // 可以将数据源（上面的数组）放到plist文件中
        NSArray *defaultSelArr = [weakSelf.curTextField[7].text componentsSeparatedByString:@"，"];
        [BRStringPickerView showStringPickerWithTitle:@"自定义多列字符串" dataSource:dataSource defaultSelValue:defaultSelArr isAutoSelect:YES themeColor:BR_RGB_HEX(0xff7998, 1.0f) resultBlock:^(id selectValue) {
            weakSelf.curTextField[7].text = weakSelf.infoModel.otherStr = [NSString stringWithFormat:@"%@，%@", selectValue[0], selectValue[1]];
        } cancelBlock:^{
            NSLog(@"点击了背景视图或取消按钮");
        }];
    }];
    
    self.itemArray = @[item0,item1,item2,item3,item4,item5,item6,item7];
}
#warning - 上面infoModel的赋值不是必需的，可以采用curTextField数组赋值的方式。

#pragma mark - UITableViewDataSource, UITableViewDelegate
//一组当中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

//返回每一组当中每一行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BRInfoCell *cell = [BRInfoCell cellWithTable:tableView];
    cell.textField.delegate = self;
    
    self.curTextField[indexPath.row] = cell.textField;
    //取出当前组的每一个行模型
    SZTextFieldCellItem *rowItem = self.itemArray[indexPath.row];
    //每个cell绑定tag
    rowItem.celltag = indexPath.row;
    //给Cell进行赋值.
    cell.rowItem = rowItem;
    return cell;
}

#pragma mark -- 懒加载tempArr 获取每一行cell对象，非必需实现的方法。
-(NSMutableArray *)tempArr {
    if (!_tempArr) {
        _tempArr = [NSMutableArray arrayWithCapacity:10];
        for (int i= 0; i < self.itemArray.count; i++) {
            NSIndexPath *  indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            BRInfoCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [_tempArr addObject:cell];
        }
    }
    return _tempArr;
}

-(NSMutableArray *)curTextField {
    if (!_curTextField) {
        _curTextField = [NSMutableArray array];
    }
    return _curTextField;
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

////#pragma mark - 刷新指定行的数据
////- (void)reloadData:(NSInteger)section row:(NSInteger)row {
////    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
////    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
////}


- (BRInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[BRInfoModel alloc]init];
    }
    return _infoModel;
}

@end
