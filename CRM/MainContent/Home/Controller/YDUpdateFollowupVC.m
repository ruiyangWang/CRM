//
//  YDUpdateFollowupVC.m
//  CRM
//
//  Created by YD_iOS on 16/7/25.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDUpdateFollowupVC.h"
#import "YDSearchIntentionTVC.h"
#import "YDSearchCarModelTVC.h"
#import "YDPriceListInfoVC.h"

#import "YDUpdateCusInfoS2Cell.h"
#import "YDUpdateCusInfoS4Cell.h"
#import "YDUpdateCusInfoS5Cell.h"

#import "YDAlertController.h"
#import "YDRemarksController.h"
#import "YDCalendarPicker.h"
#import "YDTool.h"

@interface YDUpdateFollowupVC (){
    NSMutableArray *_title;
    NSMutableDictionary *_subTitle;
    
    UIView *enableView;//当前响应键盘的view
    CGFloat oldTableCenterY;//保存tableview的y轴中心点
    
    NSString *_brandID;
    NSString *_carsID;
    NSString *_carTypeID;
    NSString *_lowerRemark;  //战败原因
    NSString *_remark;  //备注
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) YDCalendarPicker *calendarPicker;
@property (nonatomic, strong) NSMutableDictionary *custLevelDic;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, copy) NSString *customerLevelBeforeDefeat; //战败之前的客户等级

@end

@implementation YDUpdateFollowupVC

- (instancetype)init
{
    if (self = [super init]) {
        _followType = @1;
    }
    return self;
}
#pragma mark ----- vc lift cycle 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //获取客户意向级别对应的所需跟进时间
    [self loadDataFormNetwork];
    
    self.title = @"补充本次跟进";
    _cModel.eventType = @"000";
    
    [_myTableView registerNib(@"YDUpdateCusInfoS2Cell")];
    [_myTableView registerNib(@"YDUpdateCusInfoS4Cell")];
    [_myTableView registerNib(@"YDUpdateCusInfoS5Cell")];
    _myTableView.rowHeight = 49;
    _myTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 0.1)];
    
    NSArray *a = @[[NSMutableArray arrayWithArray:@[@"客户级别",@"意向车型",@""]],
                   [NSMutableArray arrayWithArray:@[@"下次跟进时间",@"备注"]]];
    _title = [NSMutableArray arrayWithArray:a ];
    
    if ([_cModel.eventType integerValue]/100 == 1) {
        [_title[0] insertObject:@"查看报价" atIndex:3];
    }
    
    if ([_cModel.eventType integerValue]%10 == 1) {
        _title[1][0] = @"提车时间";
    }
    
    //如果进来的时候是Z，说明是战败客户，补充跟进激活，默认为C
    if ([_cModel.customerLevel isEqualToString:@"Z"]) {
        _cModel.customerLevel = @"C";
    }
    
    NSDictionary *d = @{@"客户级别":_cModel.customerLevel,
                        @"意向车型":_cModel.carTypeName,
                        @"查看报价":_cModel.quoteMoney,
                        @"下次跟进时间":[[NSDate nowAndAfter] lastObject],
                        @"提车时间":_cModel.takeCarTimeString};
    _subTitle = [NSMutableDictionary dictionaryWithDictionary:d ];
    
    [self changeLayoutWithCustomerLevel:_cModel.customerLevel];
    
    _brandID = _cModel.brandsId;
    _carsID = _cModel.carsId;
    _carTypeID = _cModel.carTypeId;
    
    _customerLevelBeforeDefeat = _cModel.customerLevel; //战败之前的客户等级
    
    //本次跟进时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _cModel.currFollowTime = [dateFormatter stringFromDate:[NSDate new]];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
    _rightButton.frame = CGRectMake(0, 0, 40, 40);
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [_rightButton addTarget:self action:@selector(clickOKButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- get and setter 属性的set和get方法
#pragma mark ----- event Response 事件响应(手势 通知)
- (void)clickOKButton{
    
    //点击保存，判断是否为自有客户，
    
    if (_cModel.own) {
        //正常提交
        [self requestNewwork];
    }else{
        //先询问是否申诉，然后提交跟进
        [YDAlertController showAlertWith:self title:nil message:@"检测到此客户不是您的客户！是否需要申请仲裁？" button1:@"申诉" button2:@"算了" confirm:^(UIAlertAction *action) {
            //走申诉流程
            [self appealRequest];
            
        } cancel:^(UIAlertAction *action) {
            //正常提交，将此跟进保存至客户档案中（原销售顾问）
            [self requestNewwork];
        }];
    }
}
- (IBAction)clickLayerView:(UIButton *)sender {
    [self tableViewAnimate_centerY:oldTableCenterY showKB:NO];
}

#pragma mark ----- custom action for UI 界面处理有关
- (void)tableViewAnimate_centerY:(NSInteger)y showKB:(BOOL)b{
    
    [UIView animateWithDuration:.25 animations:^{
        _myTableView.center = CGPointMake(kScreenWidth/2, y);
    }];
    
    if (b) {
        enableView.userInteractionEnabled = YES;
        [enableView becomeFirstResponder];
    }else{
        enableView.userInteractionEnabled = NO;
        [self.view endEditing:YES];
    }
}

#pragma mark ----- custom action for DATA 数据处理有关
- (void)requestNewwork{
    
    if ([_cModel.eventType integerValue]/100 == 1 && [[_subTitle objectForKey:@"查看报价"] length] == 0) {
        [MBProgressHUD showTips:@"报价不能为空" toView:self.view];
        return;
    }
    
    if ([_cModel.eventType integerValue]%10 == 1 && [[_subTitle objectForKey:@"提车时间"] length] == 0) {
        [MBProgressHUD showTips:@"提车时间不能为空" toView:self.view];
        return;
    }
    
    if ([[_subTitle objectForKey:@"客户级别"] isEqualToString:@"战败"] && _lowerRemark.length == 0) {
        [MBProgressHUD showTips:@"请填写战败原因" toView:self.view];
        return;
    }
    
    if ([[_subTitle objectForKey:@"客户级别"] isEqualToString:@"战败"]) {
        [self defeatApplyRequsest];
    } else {
        [self addFollowRequest];
    }
}

#pragma mark 添加跟进
- (void)addFollowRequest
{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_cModel.customerId forKey:@"customerId"];
    [dic setObject:_cModel.customerLevel forKey:@"customerLevel"];
    [dic setObject:_cModel.eventType forKey:@"eventType"];
    
    if ([_cModel.eventType integerValue]/100 == 1) {
        [dic setObject:_subTitle[@"查看报价"] forKey:@"quoteMoney"];
    }
    
    if ([_cModel.eventType integerValue]%10 == 1) {
        [dic setObject:@2 forKey:@"type"];
        [dic setObject:_subTitle[@"提车时间"] forKey:@"takeCarTime"];
    }else{
        [dic setObject:@1 forKey:@"type"];
        [dic setObject:_subTitle[@"下次跟进时间"] forKey:@"nextFollowTime"];
    }
    
    if (_remark.length > 0) {
        [dic setObject:_remark forKey:@"remark"];
    }
    
    if (_brandID.length > 0) {
        [dic setObject:@[@{@"brandsId":_brandID, @"carsId":_carsID, @"carTypeId":_carTypeID, @"type":@1}] forKey:@"carRel"];
    }
    
    //跟进方式，默认是客户到店，填写2是电话跟进
    [dic setValue:self.followType forKey:@"followWay"];
   
    //客流ID
    if (self.passengerId.length > 0) {
        [dic setValue:self.passengerId forKey:@"passengerId"];
    }
    
    //本次跟进时间
    [dic setValue:_cModel.currFollowTime forKey:@"currFollowTime"];
    
    NSString *url = [NSString stringWithFormat:@"%@type=follow&sid=%@",kCrmAddFollow,getNSUser(@"youdao.CRM_SID")];
    
    [self showHudInView:self.view hint:@""];
    [YDDataService startRequest:dic url:url block:^(id result) {
        [self hideHud];
        
        //提交的时候，如果是战败申请，会有申请失败 和成功两个情况
        
        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
            [MBProgressHUD showTips:@"添加成功" toView:kWindow];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAddFollowSuccessNotification object:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            if ([[result valueForKey:@"code"] isEqualToString:@"FOLLOW_S_FAL_0X003"]) {
                [[[UIAlertView alloc] initWithTitle:@"您申请的客户正在申诉中\n暂时不能申请战败" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil] show];
            } else {
                [self showHint:[NSString stringWithFormat:@"%@:%@", result[@"code"], result[@"msg"]]];
            }
        }
        
    } failBlock:^(id error) {
        [self hideHud];
        [MBProgressHUD showTips:@"添加跟进信息失败" toView:kWindow];
    }];
}

#pragma mark 战败申请
- (void)defeatApplyRequsest
{
    //当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate new]];
    
    NSDictionary *applyDic = @{@"customerId" : _cModel.customerId,
                               @"reason" : _lowerRemark,
                               @"attr" : _customerLevelBeforeDefeat,
                               @"createTime" : currentDate};
    NSString *defeatApplyAddress = [NSString stringWithFormat:@"%@&sid=%@", kDefeatApplyAddress, getNSUser(kCRM_SIDKey)];
    [YDDataService startRequest:applyDic url:defeatApplyAddress block:^(id result) {
        
        [self addFollowRequest];
        
    } failBlock:^(id error) {
        
    }];
}

//申诉
- (void)appealRequest{
    
    NSDictionary *dic = @{@"customerId":_cModel.modelId};
    NSString *url = [NSString stringWithFormat:@"%@type=appeal&sid=%@",kCrmAppeal,getNSUser(@"youdao.CRM_SID")];
    
    [self showHudInView:self.view hint:@""];
    [YDDataService startRequest:dic url:url block:^(id result) {
        [self hideHud];
        
        //根据结果 提示不同信息，并 //正常提交，将此跟进保存至客户档案中（原销售顾问）
        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
            NSString *s = @"您的申诉已经提交！\n请留意消息提醒，您会第一时间收到处理结果";
            [YDAlertController showAlertWith:self title:nil message:s confirm:^(UIAlertAction *action) {
                [self requestNewwork];
                
            } cancel:nil];
            
        } else if([[result objectForKey:@"code"] isEqualToString:@"CRM_IS_APPLYING_DEFEAT_0X001"]){
            NSString *s = @"由于此客户正在申请战败\n暂不能提交申诉";
            [YDAlertController showAlertWith:self title:nil message:s confirm:^(UIAlertAction *action) {
                [self requestNewwork];
                
            } cancel:nil];
        } else if([[result objectForKey:@"code"] isEqualToString:@"CRM_IS_APPEALING_0X001 "]){
            NSString *s = @"您对此客户的申诉正在处理中";
            [YDAlertController showAlertWith:self title:nil message:s confirm:^(UIAlertAction *action) {
                [self requestNewwork];
                
            } cancel:nil];
        } else{
            sleep(1);
        }
        
    } failBlock:^(id error) {
        [self hideHud];
        [self showHint:@"申诉失败"];
    }];
}

#pragma mark ----- xxxxxx delegate 各种delegate回调
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_title[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WEAKSELF
    if (indexPath.section == 0 && indexPath.row == 2) {
        YDUpdateCusInfoS4Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUpdateCusInfoS4Cell" forIndexPath:indexPath];
        cell.t = @"事件";
        cell.eventType = _cModel.eventType;
        
        //如果客户级别为战败，就不能选下订
        if ([_cModel.customerLevel isEqualToString:@"Z"]) {
            cell.isDisableLastButton = YES;
        } else {
            cell.isDisableLastButton = NO;
        }
        
        cell.ClickButtonBlock = ^(NSString *s, BOOL setH, NSString *bs){
            _cModel.eventType = s;
            
            if ([bs isEqualToString:@"报价"]) {
                if (setH) {
                    [_title[0] insertObject:@"报价金额" atIndex:3];
                }else
                    [_title[0] removeObjectAtIndex:3];
                
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationMiddle)];
                
            }else if ([bs isEqualToString:@"下订"]){
                if (setH) {
                    _title[1][0] = @"提车时间";
                }else
                    _title[1][0] = @"下次跟进时间";
                
                [tableView reloadData];
            }

        };
        return cell;
        
    }
    else if (indexPath.section == 10){
        if ([_subTitle[@"客户级别"] isEqualToString:@"战败"]) {
            //如果是战败
            if (indexPath.row == 0) {
                YDUpdateCusInfoS5Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUpdateCusInfoS5Cell" forIndexPath:indexPath];
                cell.textInfo.placeholder = [_subTitle[@"客户级别"] isEqualToString:@"战败"]?@"战败原因":@"填写备注";
                cell.textInfo.text =  [_subTitle[@"客户级别"] isEqualToString:@"战败"]?_lowerRemark:_remark;
                cell.EndEditBlack = ^(YDUpdateCusInfoS5Cell * cell, NSString *s ){
                    [weakSelf tableViewAnimate_centerY:oldTableCenterY showKB:NO];
                    if ([cell.textInfo.placeholder isEqualToString:@"战败原因"]) {
                        _lowerRemark = s;
                        
                    }else
                        _remark = s;
                };
                return cell;
            }
        } else {
            //不是战败
            if (indexPath.row == 1) {
                YDUpdateCusInfoS5Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUpdateCusInfoS5Cell" forIndexPath:indexPath];
                cell.textInfo.placeholder = [_subTitle[@"客户级别"] isEqualToString:@"战败"]?@"战败原因":@"填写备注";
                cell.textInfo.text =  [_subTitle[@"客户级别"] isEqualToString:@"战败"]?_lowerRemark:_remark;
                cell.EndEditBlack = ^(YDUpdateCusInfoS5Cell * cell, NSString *s ){
                    [weakSelf tableViewAnimate_centerY:oldTableCenterY showKB:NO];
                    if ([cell.textInfo.placeholder isEqualToString:@"战败原因"]) {
                        _lowerRemark = s;
                        
                    }else
                        _remark = s;
                };
                return cell;
            }
        }
        
    }
    
    YDUpdateCusInfoS2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUpdateCusInfoS2Cell" forIndexPath:indexPath];
    cell.titleString = [[_title objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.subTitleString = _subTitle[cell.titleString];
    if ([cell.titleString isEqualToString:@"报价金额"]) {
        cell.showNextButton = NO;
        cell.subTitle.keyboardType = UIKeyboardTypeNumberPad;
        cell.subTitle.placeholder = @"输入金额";
        cell.isShowDoneTool = YES;
    } else if ([cell.titleString isEqualToString:@"备注"]) {
        cell.subTitle.placeholder = @"请填写备注";
    } else if ([cell.titleString isEqualToString:@"战败原因"]) {
        cell.subTitle.placeholder = @"请说明战败原因";
    } else if ([cell.titleString isEqualToString:@"提车时间"]) {
        cell.subTitle.placeholder = @"请选择提车时间";
    }
    
    cell.EndEditBlack = ^(YDUpdateCusInfoS2Cell *cell, NSString *s ) {
        
        _subTitle[cell.titleString] = s;

    };
    
    cell.ReturnBlack = ^(void){
        [weakSelf tableViewAnimate_centerY:oldTableCenterY showKB:NO];
    };
    
    if (indexPath.section == 1) {
        cell.showNextButton = NO;
    }
    
    if ([cell.titleString isEqualToString:@"意向车型"] || [cell.titleString isEqualToString:@"下次跟进时间"] || [cell.titleString isEqualToString:@"提车时间"]) {
        cell.isMust = YES;
    } else {
        cell.isMust = NO;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            YDSearchIntentionTVC *vc = [[YDSearchIntentionTVC alloc] initWithNibName:@"YDSearchIntentionTVC" bundle:nil];
            vc.showLow = _canSetLow;
            
            //如果选了下订，就不能选战败
            NSInteger status = [_cModel.eventType integerValue] % 10;
            if (status == 1) {
                vc.showLow = NO;
            } else {
                vc.showLow = YES;
            }
            
            if (_canSetLow == NO) {
                vc.showLow = NO;
            }
            
            vc.ClickCellBlack = ^(NSString *str ){
                _subTitle[@"客户级别"] = str;
                [self changeLayoutWithCustomerLevel:str];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 1){
            
            YDSearchCarModelTVC *tvc = [[YDSearchCarModelTVC alloc]initWithNibName:@"YDSearchCarModelTVC" bundle:nil];
            tvc.SearchCarRowBlack = ^(NSString *bID, NSString *cID, NSString *ctID, NSString *name){
                _brandID = bID;
                _carsID = cID;
                _carTypeID = ctID;
                _subTitle[@"意向车型"] = name;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            };
            [self.navigationController pushViewController:tvc animated:YES];
            
        }else if (indexPath.row == 3){
            
//            YDPriceListInfoVC *vc = [[YDPriceListInfoVC alloc]initWithNibName:@"YDPriceListInfoVC" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
            
            oldTableCenterY = tableView.center.y;

            YDUpdateCusInfoS2Cell *cell = [tableView cellForRowAtIndexPath:indexPath];
            enableView = cell.subTitle;
            [self tableViewAnimate_centerY:tableView.center.y-(cell.center.y-24.5) showKB:YES];
        }
    }else if(indexPath.section == 1){
        
        oldTableCenterY = tableView.center.y;
        NSString *cellTitle = _title[1][0];
        if ([cellTitle isEqualToString:@"下次跟进时间"] || [cellTitle isEqualToString:@"提车时间"]) {
            
            YDUpdateCusInfoS2Cell *cell = [tableView cellForRowAtIndexPath:indexPath];
            enableView = cell.subTitle;
            if ([cell.titleString isEqualToString:@"备注"]) {
                YDUpdateCusInfoS2Cell *cell = [tableView cellForRowAtIndexPath:indexPath];
                YDRemarksController *remarkVC = [[YDRemarksController alloc] init];
                remarkVC.title = cell.titleString;
                remarkVC.contentText = cell.subTitle.text;
                [self.navigationController pushViewController:remarkVC animated:YES];
                remarkVC.ChangeBlock = ^(NSString *str) {
                    cell.subTitleString = str;
                    _remark = str;
                };
                return;
            }
            self.calendarPicker.selectDateString = _subTitle[@"下次跟进时间"];
            [self.view addSubview:self.calendarPicker];
            //日历高度
            CGFloat height = ((CGFloat)kScreenWidth/7) * 4 + 30.0f + 50.0f;
            //右上角完成按钮隐藏
            _rightButton.hidden = YES;
            [UIView animateWithDuration:0.25 animations:^{
                tableView.contentOffset = CGPointMake(0, cell.y);
                self.calendarPicker.frame = CGRectMake(0, kScreenHeight - height, kScreenWidth, height);
            }];
            
            WEAKSELF
            self.calendarPicker.ClickDateButton = ^(YDCalendarPicker *calendar, NSDate *date ){
                
                NSDate *nowDate = [NSDate new];
                NSTimeInterval secondsInterval= [nowDate timeIntervalSinceDate:date];
                if (secondsInterval > 86400) {
                    [MBProgressHUD showTips:@"下次跟进时间不能选择今天以前" toView:weakSelf.view];
                    return;
                }
                //右上角完成按钮显示
                _rightButton.hidden = NO;
                
                //更新数据 UI
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。 HH:mm:ss zzz
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *destDateString = [dateFormatter stringFromDate:date];
                _subTitle[cell.titleString] = destDateString;
                [_myTableView reloadData];
                
                //tableview回归
                [UIView animateWithDuration:0.25f animations:^{
                    tableView.contentOffset = CGPointMake(0, 0);
                }];
                
                [weakSelf removeCalendar];
                
            };
            
        } else {
            
            YDUpdateCusInfoS2Cell *cell = [tableView cellForRowAtIndexPath:indexPath];
            YDRemarksController *remarkVC = [[YDRemarksController alloc] init];
            remarkVC.title = cell.titleString;
            remarkVC.contentText = cell.subTitle.text;
            [self.navigationController pushViewController:remarkVC animated:YES];
            remarkVC.ChangeBlock = ^(NSString *str) {
                cell.subTitleString = str;
                _lowerRemark = str;
            };
        }
    }
    
}


#pragma mark - 根据选择的客户级别改变下次跟进时间或填写战败原因
- (void)changeLayoutWithCustomerLevel:(NSString *)level
{
    if ([level isEqualToString:@"战败"]) {
        _title[1] = [NSMutableArray arrayWithObjects:@"战败原因", nil];
        _cModel.customerLevel = @"Z";
    } else {
        _title[1] = [NSMutableArray arrayWithObjects:@"下次跟进时间", @"备注", nil];
        NSInteger spaceDay = [self.custLevelDic[level] integerValue];
        _subTitle[@"下次跟进时间"] = [YDTool getNDay:spaceDay];
        _cModel.customerLevel = level;
    }
    
    [_myTableView reloadData];
}

#pragma mark - ====================日历控件====================
#pragma mark 移除日历选择控件
- (void)removeCalendar
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.calendarPicker.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 220.0f);
        
    } completion:^(BOOL finished) {
        
        [self.calendarPicker removeFromSuperview];
        self.calendarPicker = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDateChooseCancleNotification object:nil];
    }];
}

- (YDCalendarPicker *)calendarPicker
{
    if (_calendarPicker == nil) {
        _calendarPicker = [[YDCalendarPicker alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 220)];
    }
    return _calendarPicker;
}



#pragma mark - 获取客户意向级别对应的所需跟进时间
- (void)loadDataFormNetwork
{
    _custLevelDic = getNSUser(kCustomerLevelKey);
}

@end
