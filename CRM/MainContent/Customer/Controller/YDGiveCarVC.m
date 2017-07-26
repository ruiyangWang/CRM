//
//  YDGiveCarVC.m
//  CRM
//
//  Created by YD_iOS on 16/8/29.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDGiveCarVC.h"
#import "YDUpdateCusInfoS2Cell.h"

#import "YDCalendarPicker.h"

#import "YDCustCellModel.h"

@interface YDGiveCarVC ()<UITableViewDelegate,UITableViewDataSource>{

    NSString *_giveTime;
}
@property (strong, nonatomic) UITableView *myTableView;

@property (nonatomic, strong) YDCustCellModel *giveCarCellModel;

@end

@implementation YDGiveCarVC

#pragma mark ----- vc lift cycle 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"成功交车";
    
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.backgroundColor = kViewControllerBackgroundColor;
    [_myTableView registerNib(@"YDUpdateCusInfoS2Cell")];
    _myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    [self.view addSubview:_myTableView];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 50.0f, 40.0f);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [doneButton addTarget:self action:@selector(giveCar) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- custom action for DATA 数据处理有关
//成功交车接口
- (void)giveCar{
    
    if ([_giveTime length] == 0) {
        [MBProgressHUD showTips:@"交车时间不能为空" toView:self.view];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@type=over&sid=%@",kCrmAddOrderInfo,getNSUser(@"youdao.CRM_SID")];
    NSDictionary *dic = @{@"customerId":_cModel.modelId, @"overTime":_giveTime};
    
    [self showHudInView:self.view hint:@""];
    [YDDataService startRequest:dic url:url block:^(id result) {
        [self hideHud];
        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
            [self showHint:@"交车成功"];
        }else{
            [self showHint:@"交车失败"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCustListNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateOrderCustDetailNotification object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isBackRootVC) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
        
    } failBlock:^(id error) {
        [self hideHud];
        [self showHint:@"交车失败"];
    }];
}

#pragma mark ----- xxxxxx delegate 各种delegate回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YDCustCellModel *cellModel = self.giveCarCellModel;
    
    YDUpdateCusInfoS2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
    cell.titleString = cellModel.title;
    cell.subTitleString = cellModel.subTitle;
    cell.subTitle.placeholder = cellModel.placeholder;
    cell.showNextButton = cellModel.isShowArrow;
    cell.isMust = cellModel.isMust;
    cell.hidden = !cellModel.isShowCell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YDCustCellModel *cellModel = self.giveCarCellModel;
    
    if ([cellModel.editMode isEqualToString:@"3"]) {
        
        //日历选择
        [self calendarPickerWithTableView:self.myTableView cellModel:cellModel indexPath:indexPath chooseBlock:^(NSString *str) {
            str = [str substringToIndex:10];
            cellModel.subTitle = str;
            _giveTime = str;
        }];
    }
}

- (YDCustCellModel *)giveCarCellModel
{
    if (_giveCarCellModel == nil) {
        _giveCarCellModel = [[YDCustCellModel alloc] init];
        _giveCarCellModel.cellName = @"YDUpdateCusInfoS2Cell";
        _giveCarCellModel.title = @"交车时间";
        _giveCarCellModel.isShowArrow = NO;
        _giveCarCellModel.placeholder = @"请选择提车时间";
        _giveCarCellModel.isShowCell = YES;
        _giveCarCellModel.editMode = @"3";
        _giveCarCellModel.isMust = YES;
    }
    return _giveCarCellModel;
}

@end
