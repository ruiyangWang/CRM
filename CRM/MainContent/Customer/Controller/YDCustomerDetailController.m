//
//  YDCustomerDetailController.m
//  CRM
//
//  Created by ios on 16/7/26.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCustomerDetailController.h"
#import "YDTool.h"
#import "YDAddFollowController.h"
#import "YDFollowRecordController.h"
#import <MessageUI/MessageUI.h>
#import "YDCustCellModel.h"
#import "YDCellEditController.h"
#import "YDCustSectionHeaderView.h"

//cell
#import "YDUpdateCusInfoS1Cell.h"
#import "YDUpdateCusInfoS2Cell.h"
#import "YDUpdateCusInfoS3Cell.h"
#import "YDUpdateCusInfoS4Cell.h"
#import "YDUpdateCusInfoS5Cell.h"

#import "YDSearchCarModelTVC.h"
#import "YDBuyCarOptionController.h"
#import "YDCustSearchResultView.h"
#import "YDCustomerModel.h"

//客户信息
#import "YDCustInfoModel.h"
#import "YDIntentionInfoModel.h"
#import "YDDefeatInfoModel.h"
#import "YDCarInfoModel.h"
#import "YDCustDetail2Cell.h"
#import "YDSwith.h"

//跟进记录的模型
#import "YDFollowInfoModel.h"
#import "YDFollowApplyModel.h"
#import "YDFollowArchivesModel.h"
#import "YDFollowTimeSortModel.h"
#import "YDFollowArchivesCell.h"
#import "YDFollowApplyCell.h"
#import "YDConflictApplyController.h"
#import "YDDefeatApplyController.h"

#import "YDUpdateFollowupVC.h"

#import "UINavigationController+QMUI.h"

@interface YDCustomerDetailController () <MFMessageComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)  UIView *topBgView; //顶部蓝色背景
@property (strong, nonatomic)  UIButton *basicInfoButton; //基本信息按钮
@property (strong, nonatomic)  UIButton *otherInfoButton; //其它信息按钮
@property (strong, nonatomic)  UIView *slideBarView; //滑动条
@property (strong, nonatomic)  UITableView *oneTableView;
@property (strong, nonatomic)  UITableView *twoTableView;


@property (nonatomic, strong) NSMutableArray *oneCellArray;

@property (nonatomic, strong) YDCustSectionHeaderView *firstGroupHeaderView;
@property (nonatomic, strong) YDCustSectionHeaderView *secondGroupHeaderView;
@property (nonatomic, assign) BOOL isOpenFirstGroup;
@property (nonatomic, assign) BOOL isOpenSecondGroup;

//记住tableview原来的偏移量，编辑完成后改回来
@property (nonatomic, assign) CGPoint oldOffset;

@property (nonatomic, strong) YDCustomerModel *customerModel;

@property (nonatomic, strong) UIButton *editButton; //编辑按钮

@property (nonatomic, strong) UIButton *addFollowButton; //添加跟进按钮

@property (nonatomic, strong) UIButton *messageButton; //发信息按钮

@property (nonatomic, strong) UIButton *phoneButton;  //打电话按钮

@property (nonatomic, strong) UIView *followHeaderView;//是否查看档案记录
@property (nonatomic, strong) YDUpdateCusInfoS1Cell *headerView;//是否查看档案记录cell

@property (nonatomic, strong) UIButton *doneEditButton; //完成编辑按钮

@property (nonatomic, strong) UIButton *cancelEditButton; //取消编辑按钮

@property (nonatomic, assign) BOOL isEdit; //是否可以编辑

@property (nonatomic, strong) NSMutableArray *archivesDataArray; //包含档案记录的跟进记录数据源
@property (nonatomic, strong) NSMutableArray *notArchivesDataArray; //不包含档案记录的跟进记录数据源
@property (nonatomic, strong) NSMutableArray *followListDataArray; //跟进记录的数据源

//新建的客户的参数
@property (nonatomic, strong) NSMutableDictionary *customerInfoDic; //基本信息
@property (nonatomic, strong) NSMutableDictionary *intentionInfoDic; //意向信息
@property (nonatomic, strong) NSMutableArray *carRelArray; //意向车型


//记录竞争车型的ID(用于修改时上传参数,默认为@"")
@property (nonatomic, copy) NSString *competeCar1PKID;
@property (nonatomic, copy) NSString *competeCar2PKID;

@end

@implementation YDCustomerDetailController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddFollowSuccessNotification object:nil];
}

- (instancetype)init
{
    if (self = [super init]) {
        _isEdit = NO;
        _customerInfoDic = [NSMutableDictionary dictionary];
        _intentionInfoDic = [NSMutableDictionary dictionary];
        _carRelArray = [NSMutableArray array];
        
        _archivesDataArray = [NSMutableArray array];
        _notArchivesDataArray = [NSMutableArray array];
        _followListDataArray = [NSMutableArray array];
        
        _backCountLayer = 1;
        _competeCar1PKID = @"";
        _competeCar2PKID = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavgationBar];
    
    [self createUI];
    
    [self loadDataFromNetwork];
    
    //[self addSlideGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataFromNetwork) name:kAddFollowSuccessNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    //隐藏导航条下的黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [super viewWillAppear:animated];
}

//在页面消失的时候就让navigationbar还原样式
-(void)viewDidlDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

#pragma mark 拦截系统的返回按钮
/// 是否需要拦截系统返回按钮的事件，只有当这里返回YES的时候，才会询问方法：`canPopViewController`
- (BOOL)shouldHoldBackButtonEvent
{
    return YES;
}

/// 是否可以`popViewController`，可以在这个返回里面做一些业务的判断，比如点击返回按钮的时候，如果输入框里面的文本没有满足条件的则可以弹alert并且返回NO
- (BOOL)canPopViewController
{
    if (self.backCountLayer != 1) {
        NSArray *viewVCS = self.navigationController.viewControllers;
        NSInteger currentIndex = [viewVCS indexOfObject:self];
        UIViewController *VC = [viewVCS objectAtIndex:currentIndex - self.backCountLayer];
        [self.navigationController popToViewController:VC animated:YES];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ===========================网络请求部分===============================
#pragma mark 根据客户ID查询客户信息
- (void)loadDataFromNetwork
{
    NSDictionary *dic = @{@"customerId" : self.customerId};
    NSString *getCustUrl = [NSString stringWithFormat:@"%@sid=%@",kGetCustomerInfoAddress,getNSUser(@"youdao.CRM_SID")];
    
    [YDDataService startRequest:dic url:getCustUrl block:^(id result) {
        NSDictionary *resultDic = result;
        if ([resultDic[@"code"] isEqualToString:@"S_OK"]) {
            //客户信息
            NSDictionary *custDic = resultDic[@"var"];
            _customerModel = [YDCustomerModel instanceWithDict:custDic];
            [self setupViewData];
            
            //获取跟进信息
            [self getFollowListFromNetwork];
        }
        
    } failBlock:^(id error) {
        
    }];
}

#pragma mark 获取客户的跟进记录
- (void)getFollowListFromNetwork
{
    NSDictionary *dic = @{@"customerId" : self.customerId};
    NSString *urlString = [NSString stringWithFormat:@"%@type=archive&sid=%@", kFollowListAddress, getNSUser(kCRM_SIDKey)];
    [YDDataService startRequest:dic url:urlString block:^(id result) {
        if ([result[@"code"] isEqualToString:@"S_OK"]) {
            [self followListSortAndGroupingWithVar:result[@"var"]];
        }
        
    } failBlock:^(id error) {
        [MBProgressHUD showTips:@"获取跟进记录失败" toView:kWindow];
    }];
}


#pragma mark - ===========================UI===============================
- (void)setupNavgationBar
{
    self.navigationController.navigationBarHidden = NO;
    
    //发信息按钮
    _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageButton.frame = CGRectMake(0, 0, 20.0f, 20.0f);
    [_messageButton setImage:[UIImage imageNamed:@"message_image"] forState:UIControlStateNormal];
    [_messageButton setImage:[UIImage imageNamed:@"message_image"] forState:UIControlStateHighlighted];
    [_messageButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithCustomView:_messageButton];
    
    //空按钮
    UIButton *spaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    spaceButton.frame = CGRectMake(0, 0, 1.0f, 1.0f);
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithCustomView:spaceButton];
    
    //打电话按钮
    _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneButton.frame = CGRectMake(0, 0, 20.0f, 20.0f);
    [_phoneButton setImage:[UIImage imageNamed:@"phone_image"] forState:UIControlStateNormal];
    [_phoneButton setImage:[UIImage imageNamed:@"phone_image"] forState:UIControlStateHighlighted];
    [_phoneButton addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *phoneItem = [[UIBarButtonItem alloc] initWithCustomView:_phoneButton];
    
    self.navigationItem.rightBarButtonItems = @[messageItem, spaceItem, phoneItem];
}


- (void)createUI
{
    
    //顶部蓝色条
    _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50.0f)];
    _topBgView.backgroundColor = kNavigationBackgroundColor;
    [self.view addSubview:_topBgView];
    
    CGFloat buttonWidth = (kScreenWidth - 40.0f) / 2;
    //基本资料
    _basicInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _basicInfoButton.frame = CGRectMake(20, 0, buttonWidth, 50.0f);
    _basicInfoButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_basicInfoButton setTitle:@"基本资料" forState:UIControlStateNormal];
    [_basicInfoButton addTarget:self action:@selector(basicInfoClick) forControlEvents:UIControlEventTouchUpInside];
    [_topBgView addSubview:_basicInfoButton];
    
    //跟进信息
    _otherInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _otherInfoButton.frame = CGRectMake(kScreenWidth / 2, 0, buttonWidth, 50.0f);
    _otherInfoButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_otherInfoButton setTitle:@"跟进信息" forState:UIControlStateNormal];
    [_otherInfoButton addTarget:self action:@selector(otherInfoClick) forControlEvents:UIControlEventTouchUpInside];
    [_topBgView addSubview:_otherInfoButton];
    
    _slideBarView = [[UIView alloc] init];
    _slideBarView.backgroundColor = [UIColor whiteColor];
    _slideBarView.bounds = CGRectMake(0, 0, 80.0f, 3.0f);
    _slideBarView.center = CGPointMake(_basicInfoButton.center.x, 48.5);
    [_topBgView addSubview:_slideBarView];
    
    
    //左边tableview
    _oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topBgView.maxY, kScreenWidth, kScreenHeight - 108.0f - 54.0f) style:UITableViewStylePlain];
    _oneTableView.dataSource = self;
    _oneTableView.delegate = self;
    _oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _oneTableView.backgroundColor = kViewControllerBackgroundColor;
    _oneTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_oneTableView];
    
    [_oneTableView registerNib(@"YDUpdateCusInfoS1Cell")];
    [_oneTableView registerNib(@"YDUpdateCusInfoS2Cell")];
    [_oneTableView registerNib(@"YDUpdateCusInfoS3Cell")];
    [_oneTableView registerNib(@"YDUpdateCusInfoS4Cell")];
    [_oneTableView registerNib(@"YDUpdateCusInfoS5Cell")];
    _oneCellArray = [NSMutableArray arrayWithArray:[YDTool cellModelArrayWithCellName:@"intertionCustomerDetailOneCell"]];
    
    
    //右边tableview
    _twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, _topBgView.maxY, kScreenWidth, kScreenHeight - 108.0f - 54.0f) style:UITableViewStylePlain];
    _twoTableView.dataSource = self;
    _twoTableView.delegate = self;
    _twoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _twoTableView.backgroundColor = kViewControllerBackgroundColor;
    _twoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _twoTableView.tableHeaderView = self.followHeaderView;
    [self.view addSubview:_twoTableView];
    
    [_twoTableView registerNib(@"YDUpdateCusInfoS1Cell")];
    [_twoTableView registerNib(@"YDUpdateCusInfoS2Cell")];
    [_twoTableView registerNib(@"YDUpdateCusInfoS3Cell")];
    [_twoTableView registerNib(@"YDUpdateCusInfoS4Cell")];
    [_twoTableView registerNib(@"YDUpdateCusInfoS5Cell")];
    [_twoTableView registerNib(@"YDCustDetail2Cell")];
    [_twoTableView registerNib(@"YDFollowApplyCell")];
    //[_twoTableView registerClass:[YDFollowArchivesCell class] forCellReuseIdentifier:@"YDFollowArchivesCell"];
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 54.0f - 64.0f, kScreenWidth * 2, 54.0f)];
    btnBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btnBgView];
    
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editButton.frame = CGRectMake(25.0f, kScreenHeight - 44.0f - 64.0f, kScreenWidth - 50.0f, 34.0f);
    _editButton.layer.cornerRadius = 4.0f;
    _editButton.layer.masksToBounds = YES;
    _editButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_editButton setTitle:@"编辑资料" forState:UIControlStateNormal];
    _editButton.backgroundColor = kNavigationBackgroundColor;
    [_editButton setBackgroundImage:[UIImage imageWithColor:kBlueHeighBackgroundColor size:_editButton.size] forState:UIControlStateHighlighted];
    [_editButton addTarget:self action:@selector(editCustButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editButton];
    
    _addFollowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addFollowButton.frame = CGRectMake(25.0f + kScreenWidth, kScreenHeight - 44.0f - 64.0f, kScreenWidth - 50.0f, 34.0f);
    [_addFollowButton setTitle:@"添加跟进" forState:UIControlStateNormal];
    _addFollowButton.layer.cornerRadius = 4.0f;
    _addFollowButton.layer.masksToBounds = YES;
    _addFollowButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _addFollowButton.backgroundColor = kNavigationBackgroundColor;
    [_addFollowButton setBackgroundImage:[UIImage imageWithColor:kBlueHeighBackgroundColor size:_addFollowButton.size] forState:UIControlStateHighlighted];
    [_addFollowButton addTarget:self action:@selector(addFollow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addFollowButton];
    
    _doneEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneEditButton.frame = CGRectMake(25.0f, _editButton.y, (_editButton.width - 12.0f) / 2, 34.0f);
    _doneEditButton.backgroundColor = [UIColor colorWithRed:82 green:205 blue:181];
    [_doneEditButton setBackgroundImage:[UIImage imageWithColor:kGreenHeighBackgroundColor size:_doneEditButton.size] forState:UIControlStateHighlighted];
    [_doneEditButton setTitle:@"完成编辑" forState:UIControlStateNormal];
    _doneEditButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _doneEditButton.layer.cornerRadius = 4.0f;
    _doneEditButton.layer.masksToBounds = YES;
    _doneEditButton.hidden = YES;
    [_doneEditButton addTarget:self action:@selector(doneEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doneEditButton];
    
    _cancelEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelEditButton.frame = CGRectMake(_doneEditButton.maxX + 12.0f, _editButton.y, _doneEditButton.width, _doneEditButton.height);
    _cancelEditButton.backgroundColor = [UIColor colorWithRed:242 green:110 blue:110];
    [_cancelEditButton setBackgroundImage:[UIImage imageWithColor:kRedHeighBackgroundColor size:_cancelEditButton.size] forState:UIControlStateHighlighted];
    [_cancelEditButton setTitle:@"取消编辑" forState:UIControlStateNormal];
    _cancelEditButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _cancelEditButton.layer.cornerRadius = 4.0f;
    _cancelEditButton.layer.masksToBounds = YES;
    _cancelEditButton.hidden = YES;
    [_cancelEditButton addTarget:self action:@selector(cancelEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelEditButton];
}

#pragma mark 添加滑动手势
- (void)addSlideGesture
{
    UISwipeGestureRecognizer *slideGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewSlide:)];
    [self.view addGestureRecognizer:slideGesture];
}
- (void)viewSlide:(UISwipeGestureRecognizer *)slideGesture
{
    if (slideGesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self otherInfoClick];
    } else if (slideGesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self basicInfoClick];
    }
    
}

#pragma mark 获取到客户信息后设置UI数据
- (void)setupViewData
{
    self.title = _customerModel.customerInfo.customerName;
    
    for (NSArray *sectionArray in _oneCellArray) {
        for (YDCustCellModel *cellModel in sectionArray) {
            if ([cellModel.title isEqualToString:@"客户名称"]) {
                cellModel.subTitle = _customerModel.customerInfo.customerName;
                cellModel.onORoff = [_customerModel.customerInfo.gender integerValue] == 1 ? YES : NO;
            } else if ([cellModel.title isEqualToString:@"联系电话"]) {
                cellModel.subTitle = _customerModel.customerInfo.customerPhone;
            } else if ([cellModel.title isEqualToString:@"客户级别"]) {
                cellModel.subTitle = _customerModel.intentionInfo.customerLevel;
            } else if ([cellModel.title isEqualToString:@"意向车型"]) {
                cellModel.subTitle = _customerModel.intentionInfo.carTypeName;
            } else if ([cellModel.title isEqualToString:@"出生日期"]) {
                cellModel.subTitle = [_customerModel.customerInfo.birthday substringToIndex:10];
            } else if ([cellModel.title isEqualToString:@"身份证号"]) {
                cellModel.subTitle = _customerModel.customerInfo.idNumber;
            } else if ([cellModel.title isEqualToString:@"微信／QQ"]) {
                cellModel.subTitle = _customerModel.customerInfo.weixin;
            } else if ([cellModel.title isEqualToString:@"家庭情况"]) {
                
                switch ([_customerModel.customerInfo.familyStatus integerValue]) {
                    case 1:
                        cellModel.subTitle = @"100";
                        break;
                    case 2:
                        cellModel.subTitle = @"010";
                        break;
                    case 3:
                        cellModel.subTitle = @"001";
                        break;
                    default:
                        break;
                }
        
            } else if ([cellModel.title isEqualToString:@"保有车型"]) {
                cellModel.subTitle = _customerModel.customerInfo.carTypeName;
            } else if ([cellModel.title isEqualToString:@"居住地址"]) {
                cellModel.subTitle = _customerModel.customerInfo.address;
            } else if ([cellModel.title isEqualToString:@"竞争车型1"]) {
                for (YDCarInfoModel *carModel in _customerModel.carRel) {
                    if ([carModel.carSortNo integerValue] == 1) {
                        cellModel.subTitle = carModel.carTypeName;
                        _competeCar1PKID = carModel.modelId;
                    }
                }
            } else if ([cellModel.title isEqualToString:@"竞争车型2"]) {
                for (YDCarInfoModel *carModel in _customerModel.carRel) {
                    if ([carModel.carSortNo integerValue] == 2) {
                        cellModel.subTitle = carModel.carTypeName;
                        _competeCar2PKID = carModel.modelId;
                    }
                }
            } else if ([cellModel.title isEqualToString:@"购车用途"]) {
                cellModel.subTitle = _customerModel.intentionInfo.purpose;
            } else if ([cellModel.title isEqualToString:@"购车类型"]) {
                
                switch ([_customerModel.intentionInfo.type integerValue]) {
                    case 1:
                        cellModel.subTitle = @"首次购车";
                        break;
                    case 2:
                        cellModel.subTitle = @"增购";
                        break;
                    case 3:
                        cellModel.subTitle = @"置换";
                        break;
                    default:
                        break;
                }

            } else if ([cellModel.title isEqualToString:@"购车关注点"]) {
                cellModel.subTitle = _customerModel.intentionInfo.concerns;
            } else if ([cellModel.title isEqualToString:@"是否贷款"]) {
                cellModel.onORoff = _customerModel.intentionInfo.isLoan;
            }
        }
    }
    
    [_oneTableView reloadData];
    [_twoTableView reloadData];
}


#pragma mark - =======================tableview delegate===============================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.oneTableView) {
        return self.oneCellArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.oneTableView) {
        if (section == 1 && !self.isOpenFirstGroup) {
            return 0;
        }
        if (section == 2 && !self.isOpenSecondGroup) {
            return 0;
        }
        return [self.oneCellArray[section] count];
    } else {
        return self.followListDataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.twoTableView) {
        YDFollowTimeSortModel *timeSortModel = self.followListDataArray[indexPath.row];
        if (timeSortModel.followType == FollowTypeArchives) {
            YDFollowArchivesModel *model = timeSortModel.followModel;
            
            return (model.contentExt.count * kOnlyOneCellHeight + 20.0f);
        }
        return 74.0f;
    }
    return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.oneTableView) {
        
        //意向信息
        YDCustCellModel *cellModel = self.oneCellArray[indexPath.section][indexPath.row];
    
        if ([cellModel.cellName isEqualToString:@"YDUpdateCusInfoS1Cell"]) {
            YDUpdateCusInfoS1Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
            if ([cellModel.changeButtonType isEqualToString:@"1"]) {
                cell.cellType = CellTypeMan;
            } else {
                cell.cellType = CellTypeBool;
            }
            
            cell.swithView.userInteractionEnabled = _isEdit;
            cell.name = cellModel.title;
            cell.subString = cellModel.subTitle;
            cell.isMust = cellModel.isMust;
            cell.subT.placeholder = _isEdit ? cellModel.placeholder : @"无";
            cell.onORoff = cellModel.onORoff;
            cell.ChangeBlack = ^(NSString *string){
                [self setupParameterWithTitle:cellModel value:string];
            };
            return cell;
        }
        else if ([cellModel.cellName isEqualToString:@"YDUpdateCusInfoS2Cell"]) {
            YDUpdateCusInfoS2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
            cell.titleString = cellModel.title;
            cell.subTitleString = cellModel.subTitle;
            cell.subTitle.placeholder = _isEdit ? cellModel.placeholder : @"无";
            cell.showNextButton = cellModel.isShowArrow;
            cell.isMust = cellModel.isMust;
            return cell;
        } else if ([cellModel.cellName isEqualToString:@"YDUpdateCusInfoS3Cell"]) {
            YDUpdateCusInfoS3Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
            cell.titleName = cellModel.title;
            return cell;
        } else if ([cellModel.cellName isEqualToString:@"YDUpdateCusInfoS4Cell"]) {
            YDUpdateCusInfoS4Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
            cell.t = cellModel.title;
            cell.eventType = cellModel.subTitle;
            cell.ClickButtonBlock = ^(NSString *eType, BOOL setH, NSString *bS) {
                if ([bS isEqualToString:@"单身"]) {
                    [_customerInfoDic setValue:@(1) forKey:@"familyStatus"];
                } else if ([bS isEqualToString:@"已婚"]) {
                    [_customerInfoDic setValue:@(2) forKey:@"familyStatus"];
                } else if ([bS isEqualToString:@"已育"]) {
                    [_customerInfoDic setValue:@(3) forKey:@"familyStatus"];
                }
            };
            cell.userInteractionEnabled = _isEdit;
            return cell;
        } else if ([cellModel.cellName isEqualToString:@"YDUpdateCusInfoS5Cell"]) {
            YDUpdateCusInfoS5Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellModel.cellName forIndexPath:indexPath];
            return cell;
        }
        
    } else {
        //跟进信息
        YDFollowTimeSortModel *timeSortModel = self.followListDataArray[indexPath.row];
        if (timeSortModel.followType == FollowTypeDefault) {
            YDFollowInfoModel *followInfoModel = (YDFollowInfoModel*)timeSortModel.followModel;
            YDCustDetail2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDCustDetail2Cell"];
            cell.followInfoModel = followInfoModel;
            return cell;
        } else if (timeSortModel.followType == FollowTypeApply) {
            YDFollowApplyModel *model = (YDFollowApplyModel*)timeSortModel.followModel;
            YDFollowApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDFollowApplyCell"];
            cell.followApplyModel = model;
            return cell;
        } else if (timeSortModel.followType == FollowTypeArchives) {
            YDFollowArchivesModel *model = (YDFollowArchivesModel*)timeSortModel.followModel;
            //YDFollowArchivesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDFollowArchivesCell"];
            YDFollowArchivesCell *cell = [[YDFollowArchivesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YDFollowArchivesCell"];
            cell.followArchivesModel = model;
            return cell;
        }
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDCustDetail2Cell" forIndexPath:indexPath];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.oneTableView) {
        if (section == 0) {
            return 5.0f;
        }
    } else {
    
    }
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.oneTableView) {
        if (section == 0) {
            return 0.1f;
        } else {
            return 49.0f;
        }
        
    } else {
        
        
    }
    return 0.1f;
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WEAKSELF
    if (tableView == self.oneTableView) {
        if (section == 1) {
            
            self.firstGroupHeaderView.openCellBlock = ^(BOOL isOpen){
                weakSelf.isOpenFirstGroup = isOpen;
               
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
                [weakSelf.oneTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            };
            return self.firstGroupHeaderView;
        } else if (section == 2) {
            
            self.secondGroupHeaderView.openCellBlock = ^(BOOL isOpen){
                weakSelf.isOpenSecondGroup = isOpen;
                
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
                [weakSelf.oneTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            };
            return self.secondGroupHeaderView;
        }
    }
  
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kViewControllerBackgroundColor;
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *cellArray = nil;
    
    if (tableView == self.oneTableView) {
        cellArray = self.oneCellArray[indexPath.section];
    } else {
       
    }
    
    YDCustCellModel *cellModel = cellArray[indexPath.row];
    
    if (tableView == self.oneTableView) {
        
        if ([cellModel.title isEqualToString:@"联系电话"]) {
            return;
        };
        
        if (!_isEdit) return; //如果不是编辑状态
        
        //基本资料 tableview
        [self clickCustomerInfoWithCellModel:cellModel indexPath:indexPath];
        
    } else if (tableView == self.twoTableView) {
        YDFollowTimeSortModel *timeSortModel = _followListDataArray[indexPath.row];
        if (timeSortModel.followType == FollowTypeDefault) {
            //意向客户查看跟进记录
            [self followRecordDetailWithFollowModel:timeSortModel.followModel];
        } else if (timeSortModel.followType == FollowTypeApply) {
            //申诉记录查看
            [self applyRecordDetailWithApplyModel:timeSortModel.followModel];
        }
        
    }
}

#pragma mark 部分字段变编辑方法重写，主要调整tableView的偏移量
- (void)directEditWithTableView:(UITableView *)tableView cellModel:(YDCustCellModel *)cellModel indexPath:(NSIndexPath *)indexPath chooseBlock:(BackStringBlock)block
{
    [super directEditWithTableView:tableView cellModel:cellModel indexPath:indexPath chooseBlock:block];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGFloat offsetY = cell.y;
    if (indexPath.section == 1) {
        offsetY -= 49.0f;
    }
    [UIView animateWithDuration:0.25f animations:^{
        tableView.contentOffset = CGPointMake(0, offsetY);
    }];
}

- (void)dateChooseWithTableView:(UITableView *)tableView cellModel:(YDCustCellModel *)cellModel indexPath:(NSIndexPath *)indexPath chooseBlock:(BackStringBlock)block
{
    [super dateChooseWithTableView:tableView cellModel:cellModel indexPath:indexPath chooseBlock:block];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGFloat offsetY = cell.y;
    if (indexPath.section == 1) {
        offsetY -= 49.0f;
    }
    [UIView animateWithDuration:0.25f animations:^{
        tableView.contentOffset = CGPointMake(0, offsetY);
    }];
}



#pragma mark - ===================================功能类========================================
- (void)basicInfoClick {
    
    self.oneTableView.hidden = NO;
    self.twoTableView.hidden = NO;
    
    _editButton.hidden = NO;
    _addFollowButton.hidden = NO;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _slideBarView.center = CGPointMake(_basicInfoButton.center.x, 48.5);
        _oneTableView.frame = CGRectMake( 0, _topBgView.maxY, _oneTableView.width, _oneTableView.height);
        _twoTableView.frame = CGRectMake(kScreenWidth, _topBgView.maxY, _twoTableView.width, _twoTableView.height);
        
        _editButton.frame = CGRectMake(25.0f, _editButton.y, _editButton.width, _editButton.height);
        _addFollowButton.frame = CGRectMake(25.0f + kScreenWidth, _addFollowButton.y, _addFollowButton.width, _addFollowButton.height);
        
    } completion:^(BOOL finished) {
        self.twoTableView.hidden = YES;
        _addFollowButton.hidden = YES;
    }];
}

- (void)otherInfoClick {
    
    self.oneTableView.hidden = NO;
    self.twoTableView.hidden = NO;
    
    _editButton.hidden = NO;
    _addFollowButton.hidden = NO;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _slideBarView.center = CGPointMake(_otherInfoButton.center.x, 48.5);
        _oneTableView.frame = CGRectMake( -kScreenWidth, _topBgView.maxY, _oneTableView.width, _oneTableView.height);
        _twoTableView.frame = CGRectMake(0, _topBgView.maxY, _twoTableView.width, _twoTableView.height);
        
        _editButton.frame = CGRectMake(- (kScreenWidth - 25.0f), _editButton.y, _editButton.width, _editButton.height);
        _addFollowButton.frame = CGRectMake(25.0f, _addFollowButton.y, _addFollowButton.width, _addFollowButton.height);
        
    } completion:^(BOOL finished) {
        self.oneTableView.hidden = YES;
        _editButton.hidden = YES;
    }];
}

#pragma mark 编辑资料按钮点击
- (void)editCustButtonClick
{
    _isEdit = YES;
    
    [self.oneTableView reloadData];
    
    [self.navigationItem setHidesBackButton:YES];
    _messageButton.hidden = YES;
    _phoneButton.hidden = YES;
    _doneEditButton.hidden = NO;
    _cancelEditButton.hidden = NO;
    _editButton.hidden = YES;
    [UIView animateWithDuration:0.25f animations:^{
        _oneTableView.frame = CGRectMake(0, 0, _oneTableView.width, _oneTableView.height + 50.0f);
    }];
    
}

#pragma mark 完成编辑按钮点击
- (void)doneEditButtonClick
{
    [self.navigationItem setHidesBackButton:NO];
    _isEdit = NO;
    _messageButton.hidden = NO;
    _phoneButton.hidden = NO;
    _doneEditButton.hidden = YES;
    _cancelEditButton.hidden = YES;
    _editButton.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        _oneTableView.frame = CGRectMake(0, _topBgView.maxY, _oneTableView.width, _oneTableView.height - 50.0f);
    }];
    
    //更新客户信息请求
    [self updateCustomerInfo];
}

#pragma mark 取消编辑按钮点击
- (void)cancelEditButtonClick
{
    [self.navigationItem setHidesBackButton:NO];
    _isEdit = NO;
    _messageButton.hidden = NO;
    _phoneButton.hidden = NO;
    _doneEditButton.hidden = YES;
    _cancelEditButton.hidden = YES;
    _editButton.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        _oneTableView.frame = CGRectMake(0, _topBgView.maxY, _oneTableView.width, _oneTableView.height - 50.0f);
    } completion:^(BOOL finished) {
        [_oneTableView reloadData];
    }];
    
}

#pragma mark 修改客户信息上传参数
- (void)updateCustomerInfo
{
    
    for (NSArray *groupArray in self.oneCellArray) {
        for (YDCustCellModel *cellModel in groupArray) {
            if (cellModel.isMust && cellModel.subTitle.length <= 0) {
                [MBProgressHUD showTips:[NSString stringWithFormat:@"%@不能为空", cellModel.title] toView:kWindow];
                return;
            }
        }
    }
    
    [_customerInfoDic setValue:_customerId forKey:@"id"];
    
    if (_customerInfoDic.allKeys.count == 1 && _intentionInfoDic.allKeys.count == 0 && _carRelArray.count == 0) {
        [MBProgressHUD showTips:@"修改成功" toView:kWindow];
        return;
    }
    
    //参数
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setValue:_customerInfoDic forKey:@"customerInfo"];
    [parameterDic setValue:_intentionInfoDic forKey:@"intentionInfo"];
    [parameterDic setValue:_carRelArray forKey:@"carRel"];
    
    //当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate new]];
    [parameterDic setValue:currentDate forKey:@"compareTime"];
    
    //地址
    NSString *addCustUrl = [NSString stringWithFormat:@"%@type=update&sid=%@",kAddCustomerAddress,getNSUser(@"youdao.CRM_SID")];
    
    [YDDataService startRequest:parameterDic url:addCustUrl block:^(id result) {
        
        if ([result[@"code"] isEqualToString:@"S_OK"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCustListNotification object:nil];
            [MBProgressHUD showTips:@"修改成功" toView:kWindow];
            [self loadDataFromNetwork];
        } else {
            [MBProgressHUD showInputErrorTips:@"修改失败" toView:kWindow];
        }
    } failBlock:^(id error) {
        
    }];
}

#pragma mark  cell被点击的方法触发
- (void)clickCustomerInfoWithCellModel:(YDCustCellModel *)cellModel indexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    if ([cellModel.editMode isEqualToString:@"1"]) {
        
        //选择车型
        [self chooseCarWithTableView:self.oneTableView cellModel:cellModel chooseBlock:^(NSMutableDictionary *dic) {
            [weakSelf setupParameterWithTitle:cellModel value:dic];
        }];
        
    } else if ([cellModel.editMode isEqualToString:@"2"]) {
        
        //直接编辑的情况
        [self directEditWithTableView:self.oneTableView cellModel:cellModel indexPath:indexPath chooseBlock:^(NSString *str) {
            cellModel.subTitle = str;
            [weakSelf setupParameterWithTitle:cellModel value:str];
        }];
        
    } else if ([cellModel.editMode isEqualToString:@"3"]) {
        
        //日历选择
        [self calendarPickerWithTableView:self.oneTableView cellModel:cellModel indexPath:indexPath chooseBlock:^(NSString *str) {
            cellModel.subTitle = str;
            [weakSelf setupParameterWithTitle:cellModel value:str];
        }];
        
    } else if ([cellModel.editMode isEqualToString:@"4"]) {
        
        //购车条件选择
        [self buyCarOptionWithTableView:self.oneTableView cellModel:cellModel chooseBlock:^(NSString *str) {
            [weakSelf setupParameterWithTitle:cellModel value:str];
        }];
        
    } else if ([cellModel.editMode isEqualToString:@"5"]) {
        //地址选择
        [self addressChooseWithTableView:self.oneTableView cellModel:cellModel indexPath:indexPath chooseBlock:^(NSString *str) {
            cellModel.subTitle = str;
            [weakSelf setupParameterWithTitle:cellModel value:str];
        }];
        
    } else if ([cellModel.editMode isEqualToString:@"6"]) {
        
        //时间选择
        [self dateChooseWithTableView:self.oneTableView cellModel:cellModel indexPath:indexPath chooseBlock:^(NSString *str) {
            cellModel.subTitle = str;
            [weakSelf setupParameterWithTitle:cellModel value:str];
        }];
        
    } else {
        
        
    }
}

#pragma mark 添加跟进
- (void)addFollow
{
    YDAddFollowController *addFollowController = [[YDAddFollowController alloc] init];
    addFollowController.addFollowType = AddFollowTypeManual;
    addFollowController.customerId = _customerId;
    [self.navigationController pushViewController:addFollowController animated:YES];
}

#pragma mark 查看跟进记录
- (void)followRecordDetailWithFollowModel:(YDFollowInfoModel *)followModel
{
    
    YDFollowRecordController *followRecordController = [[YDFollowRecordController alloc] init];
    followRecordController.followInfoModel = followModel;
    [self.navigationController pushViewController:followRecordController animated:YES];
}

#pragma mark 申诉记录查看
- (void)applyRecordDetailWithApplyModel:(YDFollowApplyModel *)applyModel
{
    if ([applyModel.type integerValue] == 0) {
        //撞单申请
        YDConflictApplyController *VC = [[YDConflictApplyController alloc] init];
        VC.applyModel = applyModel;
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        //战败申请
        YDDefeatApplyController *VC = [[YDDefeatApplyController alloc] init];
        VC.applyModel = applyModel;
        [self.navigationController pushViewController:VC animated:YES];
    }

}

#pragma mark 发信息
- (void)sendMessage
{
    if( [MFMessageComposeViewController canSendText] ){
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        
        controller.recipients = [NSArray arrayWithObject:_customerModel.customerInfo.customerPhone];
        //controller.body = @"测试发短信";
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:^{
            
        }];
        
        //修改短信界面标题
        //[[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];
    }else{
        [[[UIAlertView alloc] initWithTitle:@"提示信息" message:@"设备没有短信功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];//关键的一句   不能为YES
    
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            [[[UIAlertView alloc] initWithTitle:@"信息发送取消" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
            break;
        case MessageComposeResultFailed:
            [[[UIAlertView alloc] initWithTitle:@"信息发送失败" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
            break;
        case MessageComposeResultSent:
            [[[UIAlertView alloc] initWithTitle:@"信息发送成功" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
            break;
        default:
            break;
    }
}

#pragma mark 打电话
- (void)callPhone
{
    //判断设备能不能打电话
    NSString *deviceModel = [UIDevice currentDevice].model;
    if ([deviceModel isEqualToString:@"iPod touch"] || [deviceModel isEqualToString:@"iPad"] || [deviceModel isEqualToString:@"iPhone Simulator"]) {
        
        [[[UIAlertView alloc] initWithTitle:@"您的设备不能打电话" message:nil delegate:nil cancelButtonTitle:@"好的,知道了" otherButtonTitles:nil,nil] show];
        
    } else {
        
        UIWebView *phoneWebView = [[UIWebView alloc] init];
        [self.view addSubview:phoneWebView];
        
        //打电话
        NSString *phoneNum = _customerModel.customerInfo.customerPhone;
        NSString *phoneString = [NSString stringWithFormat:@"tel://%@", phoneNum];
        NSURL *phoneURL = [NSURL URLWithString:phoneString];
        [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
        
        
        YDUpdateFollowupVC *VC = [[YDUpdateFollowupVC alloc] initWithNibName:@"YDUpdateFollowupVC" bundle:nil];
        YDCustListModel *custListModel = [[YDCustListModel alloc] init];
        custListModel.customerLevel = _customerModel.intentionInfo.customerLevel;
        custListModel.carTypeName = _customerModel.intentionInfo.carTypeName;
        for (YDCarInfoModel *carModel in _customerModel.carRel) {
            if ([carModel.type integerValue] == 1) {
                custListModel.brandsId = carModel.brandsId;
                custListModel.carsId = carModel.carsId;
                custListModel.carTypeId = carModel.carTypeId;
            }
        }
        custListModel.customerId = _customerModel.customerInfo.modelId;
        custListModel.own = YES;
        VC.followType = @2;
        VC.cModel = custListModel;
        [self.navigationController pushViewController:VC animated:YES];
    }
}


#pragma mark - 对跟进记录进行排序分组
- (void)followListSortAndGroupingWithVar:(NSDictionary *)var
{
    //清空跟进记录数组
    [_archivesDataArray removeAllObjects];
    [_notArchivesDataArray removeAllObjects];
    
    NSArray *msgsArray = [var valueForKey:@"msgs"];
    NSArray *defeatAppealsArray = [var valueForKey:@"defeatAppeals"];
    NSArray *listArray = [var valueForKey:@"list"];
    
    //档案记录
    for (NSDictionary *dic in msgsArray) {
        YDFollowArchivesModel *model = [YDFollowArchivesModel instanceWithDict:dic];
        YDFollowTimeSortModel *timeSortModel = [[YDFollowTimeSortModel alloc] init];
        timeSortModel.createTime = model.createdAt;
        timeSortModel.followType = FollowTypeArchives;
        timeSortModel.followModel = model;
        
        //有些子段更改后台并不会记录，但返回一条更改记录
        if (model.contentExt.count > 0) {
            [_archivesDataArray addObject:timeSortModel];
        }
    }
    
    //手动添加的跟进记录
    for (NSDictionary *dic in listArray) {
        YDFollowInfoModel *model = [YDFollowInfoModel instanceWithDict:dic];
        YDFollowTimeSortModel *timeSortModel = [[YDFollowTimeSortModel alloc] init];
        timeSortModel.createTime = model.currFollowTime;
        timeSortModel.followType = FollowTypeDefault;
        timeSortModel.followModel = model;
        [_archivesDataArray addObject:timeSortModel];
        [_notArchivesDataArray addObject:timeSortModel];
    }
    
    //申诉记录
    for (NSDictionary *dic in defeatAppealsArray) {
        YDFollowApplyModel *model = [YDFollowApplyModel instanceWithDict:dic];
        YDFollowTimeSortModel *timeSortModel = [[YDFollowTimeSortModel alloc] init];
        timeSortModel.createTime = model.createTime;
        timeSortModel.followType = FollowTypeApply;
        timeSortModel.followModel = model;
        [_archivesDataArray addObject:timeSortModel];
        [_notArchivesDataArray addObject:timeSortModel];
    }
    
    
    //对跟进记录根据时间排序
    NSArray *notArchivesArray = [_notArchivesDataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        YDFollowTimeSortModel *model1 = obj1;
        YDFollowTimeSortModel *model2 = obj2;
        NSComparisonResult result = [model1.createTime compare:model2.createTime];
        return result == NSOrderedAscending;
    }];
    
    [_notArchivesDataArray removeAllObjects];
    [_notArchivesDataArray addObjectsFromArray:notArchivesArray];
    
    
 
    //对跟进记录根据时间排序
    NSArray *array = [_archivesDataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        YDFollowTimeSortModel *model1 = obj1;
        YDFollowTimeSortModel *model2 = obj2;
        NSComparisonResult result = [model1.createTime compare:model2.createTime];
        return result == NSOrderedAscending;
    }];
    
    [_archivesDataArray removeAllObjects];
    [_archivesDataArray addObjectsFromArray:array];
    
    if (_headerView.onORoff) {
        _followListDataArray = _archivesDataArray;
    } else {
        _followListDataArray = _notArchivesDataArray;
    }
    
    [self.twoTableView reloadData];
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
    //上传的格式，只作参考
    NSDictionary *dic = @{@"customerInfo":
                              @{
                                  @"customerName":@"凤凰传奇",
                                  @"customerPhone":@"15555665566",
                                  @"gender":@(1),
                                  @"isDrive":@(0),
                                  @"birthday":@"1991-03-18",
                                  @"idNumber":@"123456999988887777",
                                  @"qq":@"1546353933",
                                  @"weixin":@"1546353933",
                                  @"address":@"中国",
                                  @"familyStatus":@(1)
                                  } ,
                          @"intentionInfo":
                              @{
                                  @"customerLevel":@"H",
                                  @"purpose":@"家用",
                                  @"concerns":@"品牌",
                                  @"type":@(1),
                                  @"isLoan":@(0)
                                  } ,
                          @"followInfo":
                              @{
                                  @"nextFollowTime":@"2016-08-25 00:00:00",
                                  @"remark":@"我只是个备注"
                                  } ,
                          @"carRel":
                              @[
                                  @{
                                      @"brandsId":@"2",
                                      @"carsId":@"2",
                                      @"carTypeId":@"2",
                                      @"type":@(1)
                                      },
                                  @{
                                      @"brandsId":@"3",
                                      @"carsId":@"3",
                                      @"carTypeId":@"3",
                                      @"type":@(2)
                                      },
                                  @{
                                      @"brandsId":@"4",
                                      @"carsId":@"4",
                                      @"carTypeId":@"4",
                                      @"type":@(2)
                                      }
                                  ]
                          
                          };
    
    if ([title isEqualToString:@"客户名称"]) {
        if ([value isEqualToString:@"女士"]) {
            [_customerInfoDic setValue:@(2) forKey:@"gender"];
            cellModel.onORoff = NO;
        } else if ([value isEqualToString:@"男士"]) {
            [_customerInfoDic setValue:@(1) forKey:@"gender"];
            cellModel.onORoff = YES;
        } else {
            [_customerInfoDic setValue:value forKey:@"customerName"];
        }
    } else if ([title isEqualToString:@"联系电话"]) {
        [_customerInfoDic setValue:value forKey:@"customerPhone"];
    } else if ([title isEqualToString:@"客户级别"]) {
        if ([value isEqualToString:@"a级"]) {
            [_intentionInfoDic setValue:@"A" forKey:@"customerLevel"];
        } else if ([value isEqualToString:@"b级"]) {
            [_intentionInfoDic setValue:@"B" forKey:@"customerLevel"];
        } else if ([value isEqualToString:@"c级"]) {
            [_intentionInfoDic setValue:@"C" forKey:@"customerLevel"];
        } else if ([value isEqualToString:@"h级"]) {
            [_intentionInfoDic setValue:@"H" forKey:@"customerLevel"];
        } else if ([value isEqualToString:@"战败"]) {
            
        } else{
            [_intentionInfoDic setValue:@"A" forKey:@"customerLevel"];
        }
    } else if ([title isEqualToString:@"意向车型"]) {
        [value setValue:@(1) forKey:@"type"];
        [_carRelArray addObject:value];
    } else if ([title isEqualToString:@"保有车型"]) {
        [value setValue:@(0) forKey:@"type"];
        [_carRelArray addObject:value];
    } else if ([title isEqualToString:@"出生日期"]) {
        [_customerInfoDic setValue:value forKey:@"birthday"];
    } else if ([title isEqualToString:@"身份证号"]) {
        [_customerInfoDic setValue:value forKey:@"idNumber"];
    } else if ([title isEqualToString:@"微信／QQ"]) {
        [_customerInfoDic setValue:value forKey:@"weixin"];
    } else if ([title isEqualToString:@"家庭情况"]) {
        
    } else if ([title isEqualToString:@"居住地址"]) {
        [_customerInfoDic setValue:value forKey:@"address"];
    } else if ([title isEqualToString:@"竞争车型1"]) {
        [value setValue:@(2) forKey:@"type"];
        [value setValue:_competeCar1PKID forKey:@"id"];
        [_carRelArray addObject:value];
    } else if ([title isEqualToString:@"竞争车型2"]) {
        [value setValue:@(2) forKey:@"type"];
        [value setValue:_competeCar2PKID forKey:@"id"];
        [_carRelArray addObject:value];
    } else if ([title isEqualToString:@"购车用途"]) {
        [_intentionInfoDic setValue:value forKey:@"purpose"];
    } else if ([title isEqualToString:@"购车类型"]) {
        if ([value isEqualToString:@"首次购车"]) {
            [_intentionInfoDic setValue:@(1) forKey:@"type"];
        } else if ([value isEqualToString:@"增购"]) {
            [_intentionInfoDic setValue:@(2) forKey:@"type"];
        } else if ([value isEqualToString:@"置换"]) {
            [_intentionInfoDic setValue:@(3) forKey:@"type"];
        }
    } else if ([title isEqualToString:@"购车关注点"]) {
        [_intentionInfoDic setValue:value forKey:@"concerns"];
    } else if ([title isEqualToString:@"是否贷款"]) {
        if ([value isEqualToString:@"是"]) {
            [_intentionInfoDic setValue:@(1) forKey:@"isLoan"];
        } else {
            [_intentionInfoDic setValue:@(0) forKey:@"isLoan"];
        }
    }
}


#pragma mark - ================懒加载====================
- (YDCustSectionHeaderView *)firstGroupHeaderView
{
    if (!_firstGroupHeaderView) {
        _firstGroupHeaderView = [YDCustSectionHeaderView custSectionHeaderViewWithTitle:@"客户信息"];
    }
    return _firstGroupHeaderView;
}

- (YDCustSectionHeaderView *)secondGroupHeaderView
{
    if (!_secondGroupHeaderView) {
        _secondGroupHeaderView = [YDCustSectionHeaderView custSectionHeaderViewWithTitle:@"意向信息"];
    }
    return _secondGroupHeaderView;
}

- (UIView *)followHeaderView
{
    if (!_followHeaderView) {
        _followHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54.0f)];
        _followHeaderView.backgroundColor = kViewControllerBackgroundColor;
        
        NSArray  *apparray= [[NSBundle mainBundle]loadNibNamed:@"YDUpdateCusInfoS1Cell" owner:nil options:nil];
        _headerView = apparray.firstObject;
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 49.0f);
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.name = @"显示档案记录";
        _headerView.subString = @"";
        _headerView.onORoff = NO;
        WEAKSELF
        _headerView.ChangeBlack = ^(NSString *str) {
            
            YDUpdateCusInfoS1Cell *v = weakSelf.twoTableView.tableHeaderView.subviews[0];
            v.onORoff = !v.onORoff;
            
            if ([str isEqualToString:@"是"]) {
                weakSelf.followListDataArray = weakSelf.archivesDataArray;
            } else {
                weakSelf.followListDataArray = weakSelf.notArchivesDataArray;
            }
            [weakSelf.twoTableView reloadSections:[[NSIndexSet alloc] initWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        };
        [_followHeaderView addSubview:_headerView];

    }
    return _followHeaderView;
}

@end
