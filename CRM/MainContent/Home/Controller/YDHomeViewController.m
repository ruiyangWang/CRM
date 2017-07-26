//
//  YDHomeViewController.m
//  CRM
//
//  Created by YD_iOS on 16/7/15.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDHomeViewController.h"
#import "YDSalesListViewController.h"
#import "YDUpdateCustomersViewController.h"
#import "YDFollowupViewController.h"
#import "YDMessageVC.h"
#import "YDUserInfoCell.h"
#import "YDCircleProgressView.h"
#import "YDCustomerDetailController.h"
#import "YDDataService.h"

#import "YDCalendarPicker.h"

#import "YDMessageModel.h"
#import "YDPassengerModel.h"
#import "YDSalesModel.h"
#import "YDUserInfoFMDB.h"
#import "YDActiveCustomerListController.h"
#import "YDSalesHTMLController.h"

#import <QMUIKit/QMUIKit.h>

#import "AFNetworking.h"
#import "JPUSHService.h"

//IM
#import "NTESSessionListViewController.h"
#import "NSString+NTES.h"
#import "NTESLoginManager.h"
#import "NTESService.h"

@interface YDHomeViewController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *messageLabelBGView;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet YDCircleProgressView *followUpcpView;
@property (weak, nonatomic) IBOutlet YDCircleProgressView *getCarcpView;
@property (weak, nonatomic) IBOutlet YDCircleProgressView *listcpView;
@property (weak, nonatomic) IBOutlet UILabel *fLabel;
@property (weak, nonatomic) IBOutlet UILabel *gLabel;
@property (weak, nonatomic) IBOutlet UILabel *lLabel;
@property (weak, nonatomic) IBOutlet UILabel *passengerLabel;
@property (weak, nonatomic) IBOutlet UILabel *followupLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) QMUIButton *titleButton; //组织信息按钮

@property (copy, nonatomic) NSMutableArray *messages;   //未读消息
@property (assign, nonatomic) NSInteger passengerCount; //待补充客流数量
@property (assign, nonatomic) NSInteger followTodayCount; //今日待跟进数量
@property (copy, nonatomic) NSMutableArray *liveness; //活跃客户
@property (copy, nonatomic) NSArray *salesScale;//销售总览比例
@property (copy, nonatomic) NSArray *showData;//销售总览显示值
@property (nonatomic, strong) NSMutableArray *orgsArray; //组织信息
@property (nonatomic, assign) NSInteger selectOrgIndex; //选中的组织的下标

@end

@implementation YDHomeViewController

#pragma mark ----- vc lift cycle 生命周期

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.navigationBar.translucent = YES;
    
    NSString *isAddPassenger = [[NSUserDefaults standardUserDefaults] valueForKey:@"isNewPassenger"];
    if (isAddPassenger && [isAddPassenger isEqualToString:@"1"]) {
        [self clickUpdateCustomersButton:nil];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isNewPassenger"];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isNewPassenger"];
    }
    [JPUSHService resetBadge];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _messages = [NSMutableArray array];
    _liveness = [NSMutableArray array];
    _selectOrgIndex = 0;
    
    [self updateUI];
    
    [self getCustomerLevelFormNetwork];
    
    [self doLogin];
    
    [self loadLeaveMessageFormNetwork];
    
    //[self updateAPP];
}

//强制更新APP提示
- (void)updateAPP
{
    
    
    UIAlertController *VC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [VC addAction:action1];
    [self presentViewController:VC animated:YES completion:nil];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self homeDataFromNetwork];
    [self showHudInView:kWindow hint:@""];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //
    NSArray *arr = @[_followUpcpView, _getCarcpView, _listcpView];
    for (YDCircleProgressView *cpView in arr) {
        [cpView removeView];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- get and setter 属性的set和get方法
#pragma mark ----- event Response 事件响应(手势 通知)

- (IBAction)clickUpdateCustomersButton:(id)sender {
    YDUpdateCustomersViewController *vc = [[YDUpdateCustomersViewController alloc]initWithNibName:@"YDUpdateCustomersViewController" bundle:nil];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickFollowUpButton:(id)sender {
    YDFollowupViewController *vc = [[YDFollowupViewController alloc]initWithNibName:@"YDFollowupViewController" bundle:nil];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickMessageButton:(id)sender {
    
    YDMessageVC *vc = [[YDMessageVC alloc]initWithNibName:@"YDMessageVC" bundle:nil];
    vc.messages = _messages;
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickBuyAllButton:(id)sender {
    
}
- (IBAction)rankButtonClick:(UIButton *)sender {
    
    YDSalesHTMLController *vc = [[YDSalesHTMLController alloc] init];
    vc.type = sender.tag - 1000;
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 查看更多活跃客户按钮点击
- (void)clickMoreActiveCustomer
{
    self.tabBarController.selectedIndex = 1;
//    YDActiveCustomerListController *activeCustListVC = [[YDActiveCustomerListController alloc] init];
//    activeCustListVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:activeCustListVC animated:YES];

}

#pragma mark ----- custom action for UI 界面处理有关

- (void)updateUI{
    
    
    [_myTableView registerNib(@"YDUserInfoCell") ];
    
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, 306);
    _myTableView.tableHeaderView = _headerView;
    
    WEAKSELF
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf homeDataFromNetwork];
    }];
    
    [self.topView addSubview:self.titleButton];
}

#pragma mark 点击顶部的企业名字
- (void)topButtonClick
{
    if (self.orgsArray.count <= 1) return;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSDictionary *dic in self.orgsArray) {
        [sheet addButtonWithTitle:dic[@"orgShortName"]];
    }
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    if (buttonIndex == 0) {
        return;
    }
    _selectOrgIndex = buttonIndex - 1;
    NSDictionary *orgDic = self.orgsArray[_selectOrgIndex];
    [dic setValue:orgDic[@"modelId"] forKey:@"id"];
    
    NSString *url = [NSString stringWithFormat:@"%@sid=%@", kChangeOrgAddress, getNSUser(kCRM_SIDKey)];
    
    [YDDataService startRequest:dic url:url block:^(id result) {
        
        if ([result[@"code"] isEqualToString:@"S_OK"]) {
            
            [self homeDataFromNetwork];
            [MBProgressHUD showTips:@"切换成功" toView:self.view];
        }
        
    } failBlock:^(id error) {
        
    }];
}

- (void)reloadLayer{

    NSArray *arr = @[_followUpcpView, _getCarcpView, _listcpView];
    for (int i = 0; i<arr.count; i++) {
        YDCircleProgressView *cpView = arr[i];
        CGFloat lp = [_salesScale[i] floatValue];
        
        [cpView setUI];
        cpView.progress = lp;
    }
    if (_showData.count > 2) {
        _fLabel.text = [NSString stringWithFormat:@"%@",_showData[0]];
        _gLabel.text = [NSString stringWithFormat:@"%@",_showData[1]];
        _lLabel.text = [NSString stringWithFormat:@"%@",_showData[2]];
    } else {
        _fLabel.text = @"0";
        _gLabel.text = @"0";
        _lLabel.text = @"0";
    }
    
}

#pragma mark ----- custom action for DATA 数据处理有关
#pragma mark 请求首页数据
- (void)homeDataFromNetwork
{
    
    dispatch_group_t group = dispatch_group_create();
    //销售总览
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        
        NSString *url = [NSString stringWithFormat:@"%@t=liveness&sid=%@",kCrmSalesOverview,getNSUser(@"youdao.CRM_SID")];
        
        [YDDataService startSyncRequest:@{} url:url block:^(id result) {
            
            //SID失效选择
            NSString *stateCode = [result valueForKey:@"code"];
            
            if (![stateCode isEqualToString:@"S_OK"]) {
                [self isNeedAgainLoginWithErrorCode:stateCode];
            }
            
            if ([stateCode isEqualToString:@"S_OK"]) {
                
                NSDictionary *d = result[@"var"];
                
                NSDictionary *stayDatas = [d valueForKey:@"stayDatas"];
                //留档总数
                NSInteger addTotalCount = [stayDatas[@"totalCount"] integerValue];
                addTotalCount = MAX(1, addTotalCount);
                //当前销售顾问留档数
                NSInteger memAddCount = [stayDatas[@"currMemRank"] integerValue];
                
                NSDictionary *followDatas = [d valueForKey:@"followDatas"];
                //跟进总数
                NSInteger giveCarCount = [followDatas[@"totalCount"] integerValue];
                giveCarCount = MAX(1, giveCarCount);
                //当前销售顾问月交车客户
                NSInteger memOrderCount = [followDatas[@"currMemRank"] integerValue];
                
                NSDictionary *quotaDatas = [d valueForKey:@"quotaDatas"];
                NSInteger rankCount = [[quotaDatas valueForKey:@"currMemRank"] integerValue];//当前排名
                NSInteger rankTotalCount = [[quotaDatas valueForKey:@"totalCount"] integerValue]; //排名总数量
                
                //
                CGFloat f1 = (CGFloat)memAddCount/addTotalCount - 0.25;
                CGFloat f2 = (CGFloat)memOrderCount/giveCarCount - 0.25;
                CGFloat f3 = (CGFloat)rankCount/MAX(1, rankTotalCount) - 0.25;
                _salesScale = @[@(f1), @(f2), @(f3)];
                _showData = @[@(memAddCount), @(memOrderCount), @(rankCount)];
                
                //待补充客流数量
                _passengerCount = [[d valueForKey:@"waitPassengerCount"] integerValue];
                
                //今日待跟进数量
                _followTodayCount = [[d valueForKey:@"waitFollowCount"] integerValue];
                
                //活跃客户
                _liveness = [NSMutableArray array];
                for (NSDictionary *dic in d[@"livenessList"]) {
                    YDCustListModel *m = [[YDCustListModel alloc] initWithDict:dic];
                    [_liveness addObject:m];
                }
                
                //组织信息
                _orgsArray = [NSMutableArray arrayWithArray:[d valueForKey:@"orgs"]];
                
            }
            
        } failBlock:^(id error) {
            NSLog(@"获取销售总览失败");
        }];
        
    });
    //获取消息3
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        
        NSString *messageUrl = [NSString stringWithFormat:@"%@sid=%@",kCrmGetNotifyMsg,getNSUser(@"youdao.CRM_SID")];
        
        [YDDataService startSyncRequest:@{} url:messageUrl block:^(id result) {
            
            if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
                
                _messages = [NSMutableArray array];
                for (NSDictionary *dic in [result objectForKey:@"var"]) {
                    YDMessageModel *messageModel = [YDMessageModel instanceWithDict:dic];
                    [_messages addObject:messageModel];
                    
                }
            }
        } failBlock:^(id error) {
            NSLog(@"消息获取失败");
        }];
        
    });

    dispatch_group_notify(group, dispatch_get_global_queue(0,0), ^{
        
        // 更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideHud];
            
            NSMutableArray *unreadArray = [NSMutableArray array];
            for (YDMessageModel *messageModel in _messages) {
                if (messageModel.isRead == NO) {
                    [unreadArray addObject:messageModel];
                }
            }
            _messageLabel.text = unreadArray.count>99?@"99":[NSString stringWithFormat:@"%ld",unreadArray.count];
            if (unreadArray.count == 0) {
                _messageLabelBGView.hidden = YES;
            }else
                _messageLabelBGView.hidden = NO;
            
            [self reloadLayer];
            
            _passengerLabel.text = [NSString stringWithFormat:@"%ld",_passengerCount];
            _followupLabel.text = [NSString stringWithFormat:@"%ld",_followTodayCount];
            
            [_myTableView.mj_header endRefreshing];
            [_myTableView reloadData];
            
            if (_orgsArray.count > 1) {
                [self.titleButton setImage:[UIImage imageNamed:@"homePage_topArrow"] forState:UIControlStateNormal];
            } else {
                [self.titleButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
            
            if (_orgsArray.count > 0) {
                NSDictionary *firstOrg = _orgsArray[_selectOrgIndex];
                [self.titleButton setTitle:firstOrg[@"orgShortName"] forState:UIControlStateNormal];
            }
        });
    });
}

#pragma mark - 获取客户等级对应的天数
- (void)getCustomerLevelFormNetwork
{
    NSString *getMessageUrl = [NSString stringWithFormat:@"%@sid=%@",kGetCustomerLevelAddress,getNSUser(@"youdao.CRM_SID")];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:getMessageUrl parameters:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[responseObject valueForKey:@"code"] isEqualToString:@"S_OK"]) {
            NSDictionary *var = [responseObject valueForKey:@"var"];
            NSString *jsonString = [var valueForKey:@"val"];
            NSDictionary *custLevelDic = [NSDictionary dictionaryWithJsonString:jsonString];
            setNSUser(custLevelDic, kCustomerLevelKey);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark ----- xxxxxx delegate 各种delegate回调
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _liveness.count > 5 ? 5 : _liveness.count;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kScreenWidth, 48.0f);
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:kNavigationBackgroundColor forState:UIControlStateNormal];
    [button setTitle:@"更多" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
    lineView.backgroundColor = kTableViewLineColor;
    [button addSubview:lineView];
    
    UIImageView *eyeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye_see_image"]];
    eyeImageView.frame = CGRectMake(kScreenWidth / 2 - 40.0f, 20.0f, 18, 10);
    [button addSubview:eyeImageView];
    
    [button addTarget:self action:@selector(clickMoreActiveCustomer) forControlEvents:UIControlEventTouchUpInside];
    if (_liveness.count > 0) {
        tableView.tableFooterView = button;
        return nil;
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.75f)];
        imageView.image = [UIImage imageNamed:@"not_active_customer"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        return imageView;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_liveness.count > 0) {
        return 0.1f;
    } else {
        return kScreenWidth * 0.75f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUserInfoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.custListModel = _liveness[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YDCustListModel *custListModel = _liveness[indexPath.row];
    
    YDCustomerDetailController *vc = [[YDCustomerDetailController alloc] init];
    vc.customerId = custListModel.customerId;
    [vc setHidesBottomBarWhenPushed:YES];
    vc.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doLogin
{
    
    
    NSString *username = [@"ydtest123" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = @"123456";
    
    NSString *loginAccount = username;
    NSString *loginToken   = [password tokenByPassword];
    
    //NIM SDK 只提供消息通道，并不依赖用户业务逻辑，开发者需要为每个APP用户指定一个NIM帐号，NIM只负责验证NIM的帐号即可(在服务器端集成)
    //用户APP的帐号体系和 NIM SDK 并没有直接关系
    //DEMO中使用 username 作为 NIM 的account ，md5(password) 作为 token
    //开发者需要根据自己的实际情况配置自身用户系统和 NIM 用户系统的关系
    
    
    [[[NIMSDK sharedSDK] loginManager] login:loginAccount
                                       token:loginToken
                                  completion:^(NSError *error) {
                                      
                                      if (error == nil)
                                      {
                                          LoginData *sdkData = [[LoginData alloc] init];
                                          sdkData.account   = loginAccount;
                                          sdkData.token     = loginToken;
                                          [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                          
                                          [[NTESServiceManager sharedManager] start];
                                          
                                      }
                                      
                                  }];
    
    
}

#pragma mark 获取离店短信模版
- (void)loadLeaveMessageFormNetwork
{
    NSDictionary *dic = @{};
    
    NSString *getMessageUrl = [NSString stringWithFormat:@"%@sid=%@",kGetMessageAddress,getNSUser(@"youdao.CRM_SID")];
    
    [YDDataService startRequest:dic url:getMessageUrl block:^(id result) {
        NSString *leaveMessage = nil;
        if ([result[@"code"] isEqualToString:@"S_OK"]) {
            NSDictionary *resultDic = result[@"var"];
            
            if (![resultDic[@"memberconfig"] isKindOfClass:[NSNull class]]) {
                leaveMessage = resultDic[@"memberconfig"][@"val"];
                
            } else {
                leaveMessage = resultDic[@"baseconfig"][@"val"];
            }
            if (leaveMessage == nil) {
                leaveMessage = @"";
            }
            setNSUser(leaveMessage, kLeaveMessageKey);
        }
        
    } failBlock:^(id error) {
        
    }];
}

- (QMUIButton *)titleButton
{
    if (_titleButton == nil) {
        _titleButton = [[QMUIButton alloc] init];
        _titleButton.imagePosition = QMUIButtonImagePositionRight;
        _titleButton.frame = CGRectMake(50, 10, 200, 30);
        _titleButton.center = CGPointMake(kScreenWidth / 2, 20.0f);
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_titleButton setTitleColor:kNavigationBackgroundColor forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(topButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

@end
