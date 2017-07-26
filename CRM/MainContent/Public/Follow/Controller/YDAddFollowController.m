//
//  YDAddFollowController.m
//  CRM
//
//  Created by ios on 16/7/27.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDAddFollowController.h"
#import "YDTool.h"
#import "YDCustCellModel.h"

//cell
#import "YDUpdateCusInfoS2Cell.h"
#import "YDUpdateCusInfoS4Cell.h"
#import "YDUpdateCusInfoS5Cell.h"
#import "YDFollowChooseCell.h"
#import "YDDataService.h"
#import "YDSearchIntentionTVC.h"
#import "YDCustomerModel.h"


@interface YDAddFollowController () <UITableViewDataSource,UITableViewDelegate>
{
    NSString *orderTime; //下订时间
    NSString *getCarTime; //提车时间
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) NSMutableDictionary *parameterDic; //添加跟进参数

@property (nonatomic, strong) YDCustomerModel *customerModel;

@property (nonatomic, strong) YDCustCellModel *priceCellModel; //报价金额的cellModel

@property (nonatomic, strong) YDCustCellModel *nextFollowTimeCellModel; //下次跟进时间cellModel

@property (nonatomic, strong) YDCustCellModel *getCarTimeCellModel; //下订时间CellModel


@property (nonatomic, strong) NSMutableDictionary *custLevelDic;

@property (nonatomic, copy) NSString *eventStaues; //事件的选中状态，默认@“000”

//记住tableview原来的偏移量，编辑完成后改回来
@property (nonatomic, assign) CGPoint oldOffset;


@end

@implementation YDAddFollowController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDateChooseCancleNotification object:nil];
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _parameterDic = [NSMutableDictionary dictionary];
        _eventStaues = @"000";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupNavigationBar];
    [self setupViewData];
    [self loadCustomerInfoFromNetWorking];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRightButton) name:kDateChooseCancleNotification object:nil];
}

- (void)showRightButton
{
    _doneButton.hidden = NO;
}

#pragma mark 设置view的数据
- (void)setupViewData
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib(@"YDUpdateCusInfoS2Cell")];
    [self.tableView registerNib(@"YDFollowChooseCell")];
    [self.tableView registerNib(@"YDUpdateCusInfoS5Cell")];
    [self.tableView registerNib(@"YDUpdateCusInfoS4Cell")];
    
    if (self.addFollowType == AddFollowTypeManual) {
        //手动添加跟进
        self.cellArray = [NSMutableArray arrayWithArray:[YDTool cellModelArrayWithCellName:@"addFollowManualCell"]];
        
        //删除报价金额
        NSMutableArray *secondArray = self.cellArray[1];
        _priceCellModel = secondArray[3];
        [secondArray removeObjectAtIndex:3];
        
        self.nextFollowTimeCellModel = self.cellArray[2][0];
        
    } else {
        //电话跟进
        self.cellArray = [NSMutableArray arrayWithArray:[YDTool cellModelArrayWithCellName:@"addFollowPhoneCell"]];
    }
    
    
}

#pragma mark 设置导航条
- (void)setupNavigationBar
{
    self.title = @"添加跟进";
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _doneButton.frame = CGRectMake(0, 0, 35.0f, 20.0f);
    [_doneButton addTarget:self action:@selector(rightDoneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
    self.navigationItem.rightBarButtonItem = doneItem;
}


#pragma mark - =========================网络请求部分=========================
#pragma mark 根据客户ID获取客户的信息
- (void)loadCustomerInfoFromNetWorking
{
    NSDictionary *dic = @{@"customerId" : self.customerId};
    NSString *getCustUrl = [NSString stringWithFormat:@"%@sid=%@",kGetCustomerInfoAddress,getNSUser(@"youdao.CRM_SID")];
    
    [YDDataService startRequest:dic url:getCustUrl block:^(id result) {
        NSDictionary *resultDic = result;
        if ([resultDic[@"code"] isEqualToString:@"S_OK"]) {
            //客户信息
            NSDictionary *custDic = resultDic[@"var"];
            _customerModel = [YDCustomerModel instanceWithDict:custDic];
            
            //获取级别对应的跟进天数
            [self lodaDaysWithCustomerLevelFromNetWorking];
            
        }
        
    } failBlock:^(id error) {
        
    }];
}

#pragma mark 获取客户级别对应的跟进天数
- (void)lodaDaysWithCustomerLevelFromNetWorking
{
    _custLevelDic = getNSUser(kCustomerLevelKey);

    //设置默认数据
    [self setupFollowInfoDefaultValue];

}

#pragma mark 获取到客户信息后，设置默认值
- (void)setupFollowInfoDefaultValue
{
    
    //跟进时间有默认值
    YDCustCellModel *timeModel = self.cellArray[0][0];
    NSDate *data = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    timeModel.subTitle = [dateFormatter stringFromDate:data];
    [_parameterDic setValue:timeModel.subTitle forKey:@"currFollowTime"];
    
    //设置客户级别、意向车型、下次跟进时间的默认值
    NSArray *secondGroup = self.cellArray[1];
    //客户级别默认值
    YDCustCellModel *levelCellModel = secondGroup[0];
    levelCellModel.subTitle = [NSString stringWithFormat:@"%@级", _customerModel.intentionInfo.customerLevel];
    [_parameterDic setValue:_customerModel.intentionInfo.customerLevel forKey:@"customerLevel"];
    if ([_customerModel.intentionInfo.customerLevel isEqualToString:@"Z"]) {
        levelCellModel.subTitle = @"C级";
        [_parameterDic setValue:@"C" forKey:@"customerLevel"];
    }
    
    //客户意向车型默认值
    NSMutableDictionary *defaultCar = [NSMutableDictionary dictionary];
    YDCustCellModel *carCellModel = secondGroup[1];
   
    [defaultCar setValue:_customerModel.intentionInfo.brandsId forKey:@"brandsId"];
    [defaultCar setValue:_customerModel.intentionInfo.carsId forKey:@"carsId"];
    [defaultCar setValue:_customerModel.intentionInfo.carTypeId forKey:@"carTypeId"];
    [defaultCar setValue:@(1) forKey:@"type"];
    
    carCellModel.subTitle = _customerModel.intentionInfo.carTypeName;
    [_parameterDic setValue:@[defaultCar] forKey:@"carRel"];
    
    //下次跟进时间的默认值
    [self setCustomerNextFollowTimeWithCustmoerLevel:levelCellModel.subTitle];
    
    [self.tableView reloadData];
    
}

#pragma mark 根据客户级别设置客户的下次跟进时间
- (void)setCustomerNextFollowTimeWithCustmoerLevel:(NSString *)custmerLevel
{
    NSString *nextFollowTime = nil;
    if ([custmerLevel isEqualToString:@"H级"]) {
        NSInteger day = [[_custLevelDic valueForKey:@"H"] integerValue];
        nextFollowTime = [YDTool getNDay:day];
    } else if ([custmerLevel isEqualToString:@"A级"]) {
        NSInteger day = [[_custLevelDic valueForKey:@"A"] integerValue];
        nextFollowTime = [YDTool getNDay:day];
    } else if ([custmerLevel isEqualToString:@"B级"]) {
        NSInteger day = [[_custLevelDic valueForKey:@"B"] integerValue];
        nextFollowTime = [YDTool getNDay:day];
    } else if ([custmerLevel isEqualToString:@"C级"]) {
        NSInteger day = [[_custLevelDic valueForKey:@"C"] integerValue];
        nextFollowTime = [YDTool getNDay:day];
    }
    
    if ([custmerLevel isEqualToString:@"战败"]) {
        NSMutableArray *thirdArray = self.cellArray[2];
        if (thirdArray.count > 1) {
            [thirdArray removeObjectAtIndex:0];
        }
        
        YDCustCellModel *remarkCellModel = thirdArray[0];
        remarkCellModel.title = @"战败原因";
        remarkCellModel.placeholder = @"请说明战败原因";
        remarkCellModel.isMust = YES;
    } else {
        
        NSMutableArray *thirdArray = self.cellArray[2];
        if (thirdArray.count < 2) {
            [thirdArray insertObject:_nextFollowTimeCellModel atIndex:0];
        }
        
        YDCustCellModel *remarkCellModel = thirdArray[1];
        remarkCellModel.title = @"备注";
        remarkCellModel.placeholder = @"请填写备注";
        remarkCellModel.isMust = NO;
    }
   
    //设置下次跟进时间
    _nextFollowTimeCellModel.subTitle = nextFollowTime;
    
    //设置下次跟进时间
    [_parameterDic setValue:nextFollowTime forKey:@"nextFollowTime"];
    
    [self.tableView reloadData];
}

#pragma mark 右边完成按钮点击方法
- (void)rightDoneButtonClick
{
    //检查必填项
    for (NSArray *groupArray in self.cellArray) {
        for (YDCustCellModel *cellModel in groupArray) {
            if (cellModel.isMust && cellModel.subTitle.length <= 0) {
                [MBProgressHUD showTips:[NSString stringWithFormat:@"%@不能为空", cellModel.title] toView:kWindow];
                return;
            }
        }
    }
    
    //战败申请
    NSArray *lastArray = self.cellArray.lastObject;
    YDCustCellModel *lastCellModel = lastArray.lastObject;
    if ([lastCellModel.title isEqualToString:@"战败原因"]) {
        //当前时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDate = [dateFormatter stringFromDate:[NSDate new]];
        
        NSDictionary *applyDic = @{@"customerId" : _customerId,
                                   @"reason" : lastCellModel.subTitle,
                                   @"attr" : _customerModel.intentionInfo.customerLevel,
                                   @"createTime" : currentDate};
        NSString *defeatApplyAddress = [NSString stringWithFormat:@"%@&sid=%@", kDefeatApplyAddress, getNSUser(kCRM_SIDKey)];
        [YDDataService startRequest:applyDic url:defeatApplyAddress block:^(id result) {
            
            if ([[result valueForKey:@"code"] isEqualToString:@"CRM_IS_APPLYING_DEFEAT_0X001"]) {
                [[[UIAlertView alloc] initWithTitle:@"您申请的客户正在申请战败" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil] show];
                return ;
            }
            [self addFollowRequest];
            
        } failBlock:^(id error) {
            
        }];
    } else {
    
        [self addFollowRequest];
    }

}

- (void)addFollowRequest
{
    //添加跟进
    [_parameterDic setValue:_customerId forKey:@"customerId"];
    
    NSString *addFollowUrl = [NSString stringWithFormat:@"%@type=follow&sid=%@",kCrmAddFollow,getNSUser(@"youdao.CRM_SID")];
    
    [YDDataService startRequest:_parameterDic url:addFollowUrl block:^(id result) {
        
        if ([[result valueForKey:@"code"] isEqualToString:@"S_OK"]) {
            
            [MBProgressHUD showTips:@"添加成功" toView:kWindow];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddFollowSuccessNotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCustListNotification object:nil];
            
            NSInteger eventState = [self.eventStaues integerValue];
            eventState = eventState%10;
            if (eventState == 1) {
                //点击了下订
                [[NSNotificationCenter defaultCenter] postNotificationName:kAddOrderFollowSuccessNotification object:nil];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (eventState == 1) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            });
        } else {
            if ([[result valueForKey:@"code"] isEqualToString:@"FOLLOW_S_FAL_0X003"]) {
                [[[UIAlertView alloc] initWithTitle:@"您申请的客户正在申诉中\n暂时不能申请战败" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil] show];
            } else {
                [MBProgressHUD showTips:@"添加失败" toView:kWindow];
            }
        }
        
    } failBlock:^(id error) {
        
    }];
}

#pragma mark - ==================tableview delegate=====================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDCustCellModel *cellModel = self.cellArray[indexPath.section][indexPath.row];
    
    if ([cellModel.cellName isEqualToString:@"YDFollowChooseCell"]) {
        YDFollowChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
        cell.ChangeBlack = ^(NSInteger index){
            [_parameterDic setValue:@(index) forKey:@"followWay"];
        };
        return cell;
    } else if ([cellModel.cellName isEqualToString:@"YDUpdateCusInfoS2Cell"]) {
        YDUpdateCusInfoS2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
        cell.titleString = cellModel.title;
        cell.subTitleString = cellModel.subTitle;
        cell.subTitle.placeholder = cellModel.placeholder;
        cell.showNextButton = cellModel.isShowArrow;
        cell.isMust = cellModel.isMust;
        
        return cell;
    }  else if ([cellModel.cellName isEqualToString:@"YDUpdateCusInfoS4Cell"]) {
        YDUpdateCusInfoS4Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
        cell.t = cellModel.title;
        cell.eventType = self.eventStaues;
        
        //如果客户级别是战败禁用下订按钮
        YDCustCellModel *custLevelCellModel = self.cellArray[1][0];
        if ([custLevelCellModel.subTitle isEqualToString:@"战败"]) {
            cell.isDisableLastButton = YES;
        } else {
            cell.isDisableLastButton = NO;
        }
        
        cell.ClickButtonBlock = ^(NSString *eType, BOOL setH, NSString *bS){
            [_parameterDic setValue:eType forKey:@"eventType"];
            self.eventStaues = eType;
            
            //报价的处理
            if ([bS isEqualToString:@"报价"]) {
                if (setH) {
                    //选中报价
                    NSMutableArray *secondGroup = self.cellArray[1];
                    [secondGroup addObject:_priceCellModel];
                    [self.tableView reloadData];
                } else {
                    //未选中报价
                    NSMutableArray *secondGroup = self.cellArray[1];
                    [secondGroup removeObject:_priceCellModel];
                    [self.tableView reloadData];
                }
                
            }
            
            //下订的处理
            if ([bS isEqualToString:@"下订"]) {
                if (setH) {
                    self.cellArray[2][0] = self.getCarTimeCellModel;
                    [_parameterDic setValue:_parameterDic[@"nextFollowTime"] forKey:@"takeCarTime"];
                    [self.tableView reloadData];
                } else {
                    self.cellArray[2][0] = self.nextFollowTimeCellModel;
                    [self.tableView reloadData];
                }
                
            }
            
        };
        return cell;
    } else if ([cellModel.cellName isEqualToString:@"YDUpdateCusInfoS5Cell"]) {
        YDUpdateCusInfoS5Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
        cell.textInfo.text = cellModel.subTitle;
        cell.textInfo.placeholder = cellModel.placeholder;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    YDCustCellModel *cellModel = self.cellArray[indexPath.section][indexPath.row];
    WEAKSELF
    
    if ([cellModel.title isEqualToString:@"客户级别"]) {
        YDSearchIntentionTVC *vc = [[YDSearchIntentionTVC alloc] initWithNibName:@"YDSearchIntentionTVC" bundle:nil];

        //如果选了下订，就不能选战败
        NSInteger staues = [self.eventStaues integerValue] % 10;
        if (staues == 1) {
            vc.showLow = NO;
        } else {
            vc.showLow = YES;
        }
        
        vc.ClickCellBlack = ^(NSString *str ){
            //参数
            if ([str isEqualToString:@"战败"]) {
                [_parameterDic setValue:@"Z" forKey:@"customerLevel"];
            } else {
                [_parameterDic setValue:str forKey:@"customerLevel"];
            }
            //显示文字
            if (![str isEqualToString:@"战败"]) {
                str = [NSString stringWithFormat:@"%@级", str];
            }
            cellModel.subTitle = str;
            [weakSelf setCustomerNextFollowTimeWithCustmoerLevel:cellModel.subTitle];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([cellModel.editMode isEqualToString:@"1"]) {
        
        //选择车型
        [self chooseCarWithTableView:tableView cellModel:cellModel chooseBlock:^(NSMutableDictionary *dic) {
            [weakSelf setupParameterWithTitle:cellModel value:dic];
        }];
        
    } else if ([cellModel.editMode isEqualToString:@"2"]) {
        
        //延迟0.2秒执行，因为编辑的时候会退出日历控件，发送通知，显示右上角完成
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _doneButton.hidden = YES;
        });
        
        //直接编辑的情况
        [self directEditWithTableView:tableView cellModel:cellModel indexPath:indexPath chooseBlock:^(NSString *str) {
            weakSelf.doneButton.hidden = NO;
            [weakSelf setupParameterWithTitle:cellModel value:str];
        }];
        
    } else if ([cellModel.editMode isEqualToString:@"3"]) {
        
        //如果是下次跟进时间
        cellModel.custmoerCreateTime = _customerModel.customerInfo.createTime;
        
        _doneButton.hidden = YES;
        //日历选择
        [self calendarPickerWithTableView:tableView cellModel:cellModel indexPath:indexPath chooseBlock:^(NSString *str) {
            weakSelf.doneButton.hidden = NO;
            cellModel.subTitle = str;
            [tableView reloadData];
            [weakSelf setupParameterWithTitle:cellModel value:str];
        }];
    } else if ([cellModel.editMode isEqualToString:@"7"]) {
        
        //备注
        [self remarksWithTableView:tableView cellModel:cellModel indexPath:indexPath chooseBlock:^(NSString *str) {
            [weakSelf setupParameterWithTitle:cellModel value:str];
        }];
        
    } else {
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return 5.0f;
}

/**
 *  设置上传参数
 *
 *  @param cellName cell标题
 *  @param value    选择的值
 */
#pragma mark - ================设置上传参数（cellName标题、value选择的值）====================
- (void)setupParameterWithTitle:(YDCustCellModel *)cellModel value:(id)value
{
    NSString *title = cellModel.title;
    //上传的格式
   
//        "customerId":"c0a808b156b119918156b16ad339000a",
//        "customerLevel":"A",
//        "type":"1",
//        "eventType":"试驾",
//        "nextFollowTime":"2016-08-25 00:00:00",
//        "remark":"感觉大脑被掏空",
//        "carRel":
//        [
//         {
//             "brandsId":"10001",
//             "carsId":"101",
//             "carTypeId":"af3c983cea7a40bab363b1e3aab93558",
//             "type": 1
//         }
//         ]
    
    
    if ([title isEqualToString:@"跟进时间"]) {
       [_parameterDic setValue:value forKey:@"currFollowTime"];
    } else if ([title isEqualToString:@"意向车型"]) {
        [value setValue:@(1) forKey:@"type"];
        [_parameterDic setValue:[NSMutableArray arrayWithObject:value] forKey:@"carRel"];
    } else if ([title isEqualToString:@"报价金额"]) {
        [_parameterDic setValue:value forKey:@"quoteMoney"];
    }  else if ([title isEqualToString:@"下次跟进时间"]) {
        [_parameterDic setValue:value forKey:@"nextFollowTime"];
    } else if ([title isEqualToString:@"提车时间"]) {
        [_parameterDic setValue:value forKey:@"takeCarTime"];
    } else if ([title isEqualToString:@"战败原因"]) {
        [_parameterDic setValue:value forKey:@"defeatApply"];
    } else if ([title isEqualToString:@"备注"]) {
        [_parameterDic setValue:value forKey:@"remark"];
    }
}

#pragma mark 直接编辑
- (void)directEditWithTableView:(UITableView *)tableView cellModel:(YDCustCellModel *)cellModel indexPath:(NSIndexPath *)indexPath chooseBlock:(BackStringBlock)block
{
    [super directEditWithTableView:tableView cellModel:cellModel indexPath:indexPath chooseBlock:block];
    
    //记录tableview的偏移量
    _oldOffset = tableView.contentOffset;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //如果不是第一组 cell.y - 44.0f;
    CGFloat offsetY = cell.y;
    if (indexPath.section == 2) {
        offsetY += 44.0f;
    }
    [UIView animateWithDuration:0.25 animations:^{
        tableView.contentOffset = CGPointMake(0, offsetY);
    }];
}

- (void)calendarPickerWithTableView:(UITableView *)tableView cellModel:(YDCustCellModel *)cellModel indexPath:(NSIndexPath *)indexPath chooseBlock:(BackStringBlock)block
{
    [super calendarPickerWithTableView:tableView cellModel:cellModel indexPath:indexPath chooseBlock:block];
    
    //记录tableview的偏移量
    _oldOffset = tableView.contentOffset;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGFloat offsetY = cell.y;
    [UIView animateWithDuration:0.25 animations:^{
        tableView.contentOffset = CGPointMake(0, offsetY);
    }];
}

#pragma mark - ===============================各种cellModel===============================
- (YDCustCellModel *)getCarTimeCellModel
{
    if (_getCarTimeCellModel == nil) {
        _getCarTimeCellModel = [[YDCustCellModel alloc] init];
        _getCarTimeCellModel.cellName = @"YDUpdateCusInfoS2Cell";
        _getCarTimeCellModel.title = @"提车时间";
        _getCarTimeCellModel.isShowArrow = NO;
        _getCarTimeCellModel.placeholder = @"请选择提车时间";
        _getCarTimeCellModel.isShowCell = YES;
        _getCarTimeCellModel.editMode = @"3";
        _getCarTimeCellModel.isMust = YES;
    }
    return _getCarTimeCellModel;
}

@end
