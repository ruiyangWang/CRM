//
//  YDCancelOrderVC.m
//  CRM
//
//  Created by YD_iOS on 16/8/29.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCancelOrderVC.h"
#import "YDUpdateCusInfoS2Cell.h"
#import "YDCustCellModel.h"

#import "YDCalendarPicker.h"

@interface YDCancelOrderVC () <UITableViewDataSource,UITableViewDelegate>
{
    UIView *_enableView;
    NSString *_cancelTime;
}

@property (nonatomic, strong)  UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) YDCustCellModel *cancelReasonCellModel; //取消订单原因
@property (nonatomic, strong) YDCustCellModel *cancelTimeCellModel; //取消订单时间

@end

@implementation YDCancelOrderVC

- (instancetype)init
{
    if (self = [super init]) {
        _dataArray = [NSMutableArray arrayWithObjects:self.cancelReasonCellModel, self.cancelTimeCellModel, nil];
    }
    return self;
}

#pragma mark ----- vc lift cycle 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"取消订单";
    
    [self createView];

}

#pragma mark - UI
- (void)createView
{
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView registerNib(@"YDUpdateCusInfoS2Cell")];
    _myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    _myTableView.backgroundColor = kViewControllerBackgroundColor;
    [self.view addSubview:_myTableView];
    
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 50.0f, 40.0f);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [doneButton addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    self.navigationItem.rightBarButtonItem = doneItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- custom action for DATA 数据处理有关
//取消订单
- (void)cancelOrder{
    
    for (YDCustCellModel *cellModel in self.dataArray) {
        if (cellModel.isMust && cellModel.subTitle.length <= 0) {
            [MBProgressHUD showTips:[NSString stringWithFormat:@"%@不能为空", cellModel.title] toView:kWindow];
            return;
        }
    }
    
    NSString *url = [NSString stringWithFormat:@"%@type=cannel&sid=%@",kCrmAddOrderInfo,getNSUser(@"youdao.CRM_SID")];
    NSDictionary *dic = @{@"customerId":_cModel.modelId, @"reason":self.cancelReasonCellModel.subTitle,@"createTime":self.cancelTimeCellModel.subTitle};
    
    [self showHudInView:self.view hint:@""];
    [YDDataService startRequest:dic url:url block:^(id result) {
        [self hideHud];
        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
            [self showHint:@"取消订单成功"];
        }else{
            [self showHint:@"取消订单失败"];
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
        [self showHint:@"取消订单失败"];
    }];
}

#pragma mark ----- xxxxxx delegate 各种delegate回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YDCustCellModel *cellModel = self.dataArray[indexPath.row];
    
    YDUpdateCusInfoS2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
    cell.titleString = cellModel.title;
    cell.subTitleString = cellModel.subTitle;
    cell.subTitle.placeholder = cellModel.placeholder;
    cell.showNextButton = cellModel.isShowArrow;
    cell.isMust = cellModel.isMust;
    cell.hidden = !cellModel.isShowCell;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self disableCellTextField];
    
    YDCustCellModel *cellModel = self.dataArray[indexPath.row];
    
    if ([cellModel.editMode isEqualToString:@"2"]) {
        
        //直接编辑的情况
        [self directEditWithTableView:self.myTableView cellModel:cellModel indexPath:indexPath chooseBlock:^(NSString *str) {
            cellModel.subTitle = str;
    
        }];
        
    } else if ([cellModel.editMode isEqualToString:@"3"]) {
        
        //日历选择
        [self calendarPickerWithTableView:self.myTableView cellModel:cellModel indexPath:indexPath chooseBlock:^(NSString *str) {
            str = [str substringToIndex:10];
            cellModel.subTitle = str;
            
        }];
    }
}

#pragma mark - cellModel
- (YDCustCellModel *)cancelReasonCellModel
{
    if (_cancelReasonCellModel == nil) {
        _cancelReasonCellModel = [[YDCustCellModel alloc] init];
        _cancelReasonCellModel.cellName = @"YDUpdateCusInfoS2Cell";
        _cancelReasonCellModel.title = @"取消订单原因";
        _cancelReasonCellModel.isShowArrow = NO;
        _cancelReasonCellModel.placeholder = @"请输入取消订单原因";
        _cancelReasonCellModel.isShowCell = YES;
        _cancelReasonCellModel.editMode = @"2";
        _cancelReasonCellModel.isMust = YES;
    }
    return _cancelReasonCellModel;
}

- (YDCustCellModel *)cancelTimeCellModel
{
    if (_cancelTimeCellModel == nil) {
        _cancelTimeCellModel = [[YDCustCellModel alloc] init];
        _cancelTimeCellModel.cellName = @"YDUpdateCusInfoS2Cell";
        _cancelTimeCellModel.title = @"取消订单时间";
        _cancelTimeCellModel.isShowArrow = NO;
        _cancelTimeCellModel.placeholder = @"请选择取消订单时间";
        _cancelTimeCellModel.isShowCell = YES;
        _cancelTimeCellModel.editMode = @"3";
        _cancelTimeCellModel.isMust = YES;
    }
    return _cancelTimeCellModel;
}


@end
