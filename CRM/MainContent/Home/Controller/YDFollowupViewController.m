//
//  YDFollowupViewController.m
//  CRM
//
//  Created by YD_iOS on 16/7/19.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDFollowupViewController.h"
#import "YDUserInfoCell.h"
#import "YDFollowupDateView.h"
#import "YDCustListModel.h"
#import "YDUpdateFollowupVC.h"
#import "YDCustomerDetailController.h"

@interface YDFollowupViewController ()

@property (weak, nonatomic) IBOutlet UIView *dateButtonBGView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *tableViewBGV;

@property (copy, nonatomic) NSMutableDictionary *mData;
@property (copy, nonatomic) NSArray *dateStrings;
@property (copy, nonatomic) NSMutableDictionary *followups; //待跟进客流

@property (assign, nonatomic) NSInteger oldDate;//存放之前显示的是第几个标签，从0开始

@property (nonatomic, strong) NSArray *overdueTimeArray; //逾期客户的时间数组，用来排序

@end

@implementation YDFollowupViewController

#pragma mark ----- vc lift cycle 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"待跟进";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _oldDate = 1;
    _mData = [NSMutableDictionary dictionary];
    _dateStrings = [NSDate nowAndAfter];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self requwstOverdueData]; //逾期未跟进
    [self loadWaitFollowCustomerFromNetwork];//待跟进
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- get and setter 属性的set和get方法
//设置dateButton的显示信息 和 点击事件
- (void)setDateButtonInfo{
    
    //刷新今日待跟进客户
    UIView *tableViewSupView = _tableViewBGV.subviews[1];
    UITableView *currentTableView = tableViewSupView.subviews.lastObject;
    [currentTableView reloadData];
 
    for (int i = 20000; i<20006; i++) {
        
        YDFollowupDateView *fView = [_dateButtonBGView viewWithTag:i];
        fView.hRow = _oldDate;
        
        if (i == 20000) {
//            fView.howRow = 0; //前面已经设置了
        }else{
            NSString *k = _dateStrings[fView.tag - 20000 - 1];
            NSArray *d = [_followups objectForKey:k];
            fView.howRow = d.count;
        }
            
        fView.ClickButtonBlock = ^(YDFollowupDateView *showView){
            
            NSInteger how = (NSInteger)( showView.frame.origin.x / (kScreenWidth/6));
            self.view.userInteractionEnabled = NO; //避免连续点击
            //刷新当前点击的tableView
            UIView *tableViewSupView = _tableViewBGV.subviews[how];
            UITableView *currentTableView = tableViewSupView.subviews.lastObject;
            [currentTableView reloadData];
            
            [UIView animateWithDuration:.25 animations:^{
                _tableViewBGV.center = CGPointMake(_tableViewBGV.center.x - kScreenWidth*(how-_oldDate), _tableViewBGV.center.y);
                
            } completion:^(BOOL finished) {
                self.view.userInteractionEnabled = YES; //避免连续点击
                _oldDate = how;
            }];
            
        };
    }
}

#pragma mark ----- event Response 事件响应(手势 通知)

#pragma mark ----- custom action for UI 界面处理有关

#pragma mark ----- custom action for DATA 数据处理有关
// 获取待跟进客户
- (void)loadWaitFollowCustomerFromNetwork{
    NSString *url = [NSString stringWithFormat:@"%@type=list&sid=%@",kCrmListFollow,getNSUser(@"youdao.CRM_SID")];
    [YDDataService startSyncRequest:@{} url:url block:^(id result) {
        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
            NSArray *data = [result objectForKey:@"var"][@"list"];
            if (![data isKindOfClass:[NSArray class]]) {
                return ;
            }
            
            _followups = [NSMutableDictionary dictionary];
            for (NSDictionary *dic in data) {
                YDCustListModel *m = [[YDCustListModel alloc] initWithDict:dic];
                m.own = YES; //待跟进全是自己的客户
                NSDate *mDate = [NSDate dateWithString:m.nextFollowTimeString  format:@"yyyy-MM-dd HH:mm:ss"];
                NSString *mString = [NSDate stringWithDate:mDate format:@"yyyy-MM-dd"];
                
                NSMutableArray *mArray = [NSMutableArray arrayWithArray:[_followups objectForKey:mString]];
                [mArray addObject:m];
                [_followups setObject:mArray forKey:mString];
            }
            [self setDateButtonInfo];
        }
        
    } failBlock:^(id error) {
        NSLog(@"获取待跟进客流失败");
    }];
}

// 获取逾期待跟进客流
- (void)requwstOverdueData{
    
    NSString *url = [NSString stringWithFormat:@"%@type=overdue&sid=%@",kCrmListFollow,getNSUser(@"youdao.CRM_SID")];
    
    [self showHudInView:self.view hint:@""];
    [YDDataService startRequest:@{} url:url block:^(id result) {
        [self hideHud];
        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
            
            NSArray *data = result[@"var"][@"list"];
            if ([data isKindOfClass:[NSArray class]]) { //是数组再遍历
                
                _mData = [NSMutableDictionary dictionary];
                
                for (NSDictionary *dic in data) {
                    YDCustListModel *m = [[YDCustListModel alloc] initWithDict:dic];
                    m.own = YES;
                    
                    NSDate *mDate = [NSDate dateWithString:m.nextFollowTimeString format:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *mString = [NSDate stringWithDate:mDate format:@"yyyy-MM-dd"];
                    
                    NSMutableArray *mArray = [NSMutableArray arrayWithArray:[_mData objectForKey:mString]];
                    [mArray addObject:m];
                    [_mData setObject:mArray forKey:mString];
                }
               
                [self sortOverdueCustomer];
                
                [_myTableView reloadData];
                
                YDFollowupDateView *f = [_dateButtonBGView viewWithTag:20000];
                f.hRow = _oldDate;
                f.howRow = data.count;
                
            } else {
                [self showHint:@"无待跟进客流"];
            }
            
        }else{
            [self showHint:@"获取逾期待跟进客流失败"];
        }
    } failBlock:^(id error) {
        [self hideHud];
        [self showHint:@"获取逾期待跟进客流失败"];
    }];
}

- (void)sortOverdueCustomer
{

    NSArray *custArray = _mData.allKeys;
   
    _overdueTimeArray = [custArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *dateStr1 = obj1;
        NSString *dateStr2 = obj2;
        NSDate *date1 = [NSDate dateWithString:dateStr1 format:@"yyyy-MM-dd"];
        NSDate *date2 = [NSDate dateWithString:dateStr2 format:@"yyyy-MM-dd"];
        return date1 < date2;
    }];
    
}

#pragma mark ----- xxxxxx delegate 各种delegate回调
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    [tableView registerNib:[UINib nibWithNibName:@"YDUserInfoCell" bundle:nil] forCellReuseIdentifier:@"YDUserInfoCell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (tableView.tag == 30000) {
        return _overdueTimeArray.count;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 30000) {
        NSString *key = _overdueTimeArray[section];
        return [[_mData objectForKey:key] count];
    }else{
        NSArray *datas = [_followups objectForKey:_dateStrings[tableView.tag-30000-1]];
        return datas.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 30000){
        return 25;
    }
    return 0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 30000) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = kNavigationBackgroundColor;
        NSDate *date = [NSDate dateWithString:_overdueTimeArray[section] format:@"yyyy-MM-dd"];
        label.text = [NSString stringWithFormat:@"    %@",[NSDate compareDate:date]];
        return label;
    }else
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUserInfoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView.tag == 30000) {
        NSString *key = _overdueTimeArray[indexPath.section];
        cell.custListModel = _mData[key][indexPath.row];
        
    }else{

        NSArray *datas = [_followups objectForKey:_dateStrings[tableView.tag-30000-1]];
        cell.custListModel = datas[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YDUserInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    YDCustomerDetailController *VC = [[YDCustomerDetailController alloc] init];
    VC.customerId = cell.custListModel.customerId;
    [self.navigationController pushViewController:VC animated:YES];
#warning 11.26号修改需求
//    YDUpdateFollowupVC *vc = [[YDUpdateFollowupVC alloc] initWithNibName:@"YDUpdateFollowupVC" bundle:nil];
//    vc.cModel = cell.custListModel;
//    vc.canSetLow = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}


@end
