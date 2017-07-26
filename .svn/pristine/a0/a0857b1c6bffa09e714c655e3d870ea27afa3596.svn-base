//
//  YDImportCustomerController.m
//  CRM
//
//  Created by ios on 16/8/1.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDImportCustomerController.h"
#import <AddressBook/AddressBook.h>
#import "YDImportCustModel.h"
#import "YDImportCustCell.h"
#import "YDNavMenuView.h"
#import "NSDictionary+Object.h"
#import "YDIntentionCustomerFMDB.h"
#import "YDOrderCustomerFMDB.h"
#import "YDTool.h"
#import "YDUserInfoFMDB.h"


@interface YDImportCustomerController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

//名字首字母拼音
@property (nonatomic, strong) NSMutableArray *pinYinArray;


@property (nonatomic, strong) UIButton *rightButton;

//选中的对象
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, strong) UIButton *headerButton;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) YDNavMenuView *menuView;

@property (nonatomic, strong) UIImageView *triangleImageView; //三角形

@property (nonatomic, assign) BOOL isShow; //是否显示下拉菜单


@property (nonatomic, strong) NSMutableArray *intentionPhoneArray; //意向客户模块的手机号集合
@property (nonatomic, strong) NSMutableArray *orderPhoneArray; //订单客户模块的手机号集合

@end

@implementation YDImportCustomerController

- (instancetype)init
{
    if (self = [super init]) {
        _dataArray = [NSMutableArray array];
        _pinYinArray = [NSMutableArray array];
        _selectedArray = [NSMutableArray array];
        
        _intentionPhoneArray = [NSMutableArray array];
        _orderPhoneArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupTableView]; //创建tableView
    
    WEAKSELF
    //判断是否有获取通讯录的权限
    [YDTool CheckAddressBookAuthorization:^(bool isAuthorized) {
        STRONGSELF
        if (isAuthorized) {
            [strongSelf loadDataFromNetwork]; //获取意向客户列表
        } else {
            [strongSelf setupAddressBookPowersPromptView];
        }
    }];
    
    
}

#pragma mark - 获取通讯录并展示
- (void)showsAddressBoosk
{
    
    [self loadPerson];//获取通讯录
    
    [self deleteRepeatCustomer];//删除重复
    
    self.dataArray = [self sortObjectsAccordingToInitialWith:self.dataArray];//排序
    
    [self getNamePinYinArray];//分组
    
    [self.tableView reloadData];
}

#pragma mark - 提示到设置里面更改权限的view
- (void)setupAddressBookPowersPromptView
{
    self.title = @"导入客户";
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.size = CGSizeMake(kScreenWidth - 20.0f, 40.0f);
    promptLabel.center = CGPointMake(kScreenWidth / 2, (kScreenHeight - 80.0f) / 2);
    promptLabel.text = @"请在iPhone的\"设置-隐私-通讯录\"中选项中,允许XX访问你的通讯录";
    promptLabel.font = [UIFont systemFontOfSize:14.0f];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 0;
    [self.view addSubview:promptLabel];
}

#pragma mark -  tableview 表的头部view
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64.0f)  style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kViewControllerBackgroundColor;
    
    //tableview头部添加提示信息
    UILabel *headerView = [[UILabel alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.textColor = kThreeTextColor;
    headerView.text = @"温馨提示:已存在的客户不会显示在此列表中";
    headerView.font = [UIFont systemFontOfSize:12.0f];
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.bounds = CGRectMake(0, 0, kScreenWidth, 30.0f);
    self.tableView.tableHeaderView = headerView;
    
    //设置索引条的属性
    self.tableView.sectionIndexColor = [UIColor colorWithRed:131 green:131 blue:131];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 50, 30);
    [_rightButton setTitle:@"导入" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_rightButton addTarget:self action:@selector(rightImportButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, 200.0f, 35.0f);
    self.navigationItem.titleView = titleView;
    
    _headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerButton.frame = CGRectMake(0, 0, 200.0f, 35.0f);
    _headerButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_headerButton setTitle:@"导入意向客户" forState:UIControlStateNormal];
    [_headerButton addTarget:self action:@selector(headerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //三角形
    if (self.importType == ImportTypeDefult) {
        _triangleImageView = [[UIImageView alloc] init];
        _triangleImageView.frame = CGRectMake(145.0f, 14.0f, 7.0f, 7.0f);
        _triangleImageView.image = [UIImage imageNamed:@"triangle_image"];
        [titleView addSubview:_triangleImageView];
    }
    
    [titleView addSubview:_headerButton];
    
    _menuView = [[YDNavMenuView alloc] initWithMenuArray:@[@"导入意向客户",@"导入订单客户"]];
    WEAKSELF
    _menuView.BackBlock = ^(NSInteger index){
        
        if (index == 0) {
            [weakSelf.headerButton setTitle:@"导入意向客户" forState:UIControlStateNormal];
            
            _isShow = NO;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.triangleImageView.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                
            }];
            
        } else {
            [weakSelf.headerButton setTitle:@"导入订单客户" forState:UIControlStateNormal];
            _isShow = NO;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.triangleImageView.transform = CGAffineTransformMakeRotation(0);
            } completion:^(BOOL finished) {
                
            }];
        }
    };
    [self.view addSubview:_menuView];
    
    if (_importType == ImportTypeDefult) {
        [_headerButton setTitle:@"导入意向客户" forState:UIControlStateNormal];
        _importType = ImportTypeCustomer;
    } else if (_importType == ImportTypeCustomer) {
        [_headerButton setTitle:@"导入意向客户" forState:UIControlStateNormal];
        _headerButton.enabled = NO;
    } else {
        //ImportTypeOrder
        [_headerButton setTitle:@"导入订单客户" forState:UIControlStateNormal];
        _headerButton.enabled = NO;
    }
}

- (void)headerButtonClick
{
    _isShow = !_isShow;
    [_menuView show];
    
    if (_isShow) {
        [UIView animateWithDuration:0.25 animations:^{
            self.triangleImageView.transform = CGAffineTransformMakeRotation(179*M_PI/180);
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.triangleImageView.transform = CGAffineTransformMakeRotation(0);
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - 右边导入按钮点击
- (void)rightImportButtonClick
{
    //如果选中数组为空
    if (_selectedArray.count == 0) {
        return;
    }
    
    if (_importType == ImportTypeCustomer) {

        for (YDImportCustModel *model in _selectedArray) {
            NSMutableString *phoneStr = [NSMutableString stringWithString:model.phone];
            model.phone = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [[YDIntentionCustomerFMDB sharedYDIntentionCustomerFMDB] insertIntenCustomer:model];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCustListNotification object:nil];
    } else {
        for (YDImportCustModel *model in _selectedArray) {
            NSMutableString *phoneStr = [NSMutableString stringWithString:model.phone];
            model.phone = [phoneStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [[YDOrderCustomerFMDB sharedYDOrderCustomerFMDB] insertIntenCustomer:model];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCustListNotification object:nil];
    }
    
    [MBProgressHUD showTips:@"导入成功" toView:kWindow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    NSString *path = NSHomeDirectory();
    NSLog( @" %@", path);
}

#pragma mark - ========================tableView delegate========================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YDImportCustCell *cell = [YDImportCustCell cellWithTableView:tableView];
    cell.custModel = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDImportCustModel *cellModel = self.dataArray[indexPath.section][indexPath.row];
    cellModel.isSelected = !cellModel.isSelected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    if (cellModel.isSelected) {
        //选中状态
        [_selectedArray addObject:cellModel];
    } else {
        [_selectedArray removeObject:cellModel];
    }
    
    if (_selectedArray.count != 0) {
        [_rightButton setTitle:[NSString stringWithFormat:@"导入(%ld)", _selectedArray.count] forState:UIControlStateNormal];
    } else {
        [_rightButton setTitle:@"导入" forState:UIControlStateNormal];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = self.pinYinArray[section];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.frame = CGRectMake(25.0f, 0, 200.0f, 35.0f);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35.0f)];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.pinYinArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    return index;
}

#pragma mark - ========================获取意向客户、订单客户，并取出手机号========================
#pragma mark 获取意向客户列表
- (void)loadDataFromNetwork
{
    NSDictionary *dic = @{
                          @"customerStatus":@"1",
                          @"customerType":@"1",
                          @"type":@"1",
                          };
    [self showHudInView:kWindow hint:@""];
    NSString *messageUrl = [NSString stringWithFormat:@"%@type=list&sid=%@",kCustomerListAddress,getNSUser(@"youdao.CRM_SID")];
    [YDDataService startRequest:dic url:messageUrl block:^(id result) {
        NSArray *customerArray = [result objectForKey:@"var"][@"list"];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in customerArray) {
            [self.intentionPhoneArray addObject:dic[@"customerPhone"]];
        }
        
       
        NSArray *intentionArray = [[YDIntentionCustomerFMDB sharedYDIntentionCustomerFMDB] queryAllImporeIntentionCustomerWithUserId:getNSUser(kUserInfoKey)];
        
        if (intentionArray.count > 0) {
            for (YDImportCustModel *importModel in intentionArray) {
                [self.intentionPhoneArray addObject:importModel.phone];
            }
            
        }
        
        [self orderCustomerList];
    } failBlock:^(id error) {
        
    }];
    
}

#pragma mark 订单客户列表
- (void)orderCustomerList
{
    NSDictionary *dic = @{
                          @"customerType":@"2",
                          @"type":@"3",
                          };
    NSString *messageUrl = [NSString stringWithFormat:@"%@type=list&sid=%@",kCustomerListAddress,getNSUser(@"youdao.CRM_SID")];
    [YDDataService startRequest:dic url:messageUrl block:^(id result) {
        NSArray *customerArray = [result objectForKey:@"var"][@"list"];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dic in customerArray) {
           [self.orderPhoneArray addObject:dic[@"customerPhone"]];
        }
    
       
        NSArray *orderArray = [[YDOrderCustomerFMDB sharedYDOrderCustomerFMDB] queryAllImporeIntentionCustomerWithUserId:getNSUser(kUserInfoKey)];
        
        if (orderArray.count > 0) {
            for (YDImportCustModel *importModel in orderArray) {
                [self.orderPhoneArray addObject:importModel.phone];
            }
        }
        
        [self showsAddressBoosk];
        [self hideHud];
    } failBlock:^(id error) {
        [self hideHud];
    }];
}


#pragma mark - ========================过滤客户========================
- (void)deleteRepeatCustomer
{
    NSMutableArray *newDataArray = [NSMutableArray array];
    
    NSArray *tempPhoneArray = nil;
    if (self.importType == ImportTypeCustomer) {
        tempPhoneArray = self.intentionPhoneArray;
    } else if (self.importType == ImportTypeOrder){
        tempPhoneArray = self.orderPhoneArray;
    }
    
    for (YDImportCustModel *importCustModel in self.dataArray) {
       //检测导入的客户是否已存在
        if (![tempPhoneArray containsObject:importCustModel.phone]) {
            [newDataArray addObject:importCustModel];
        };
        
    }
    
    self.dataArray = [NSMutableArray arrayWithArray:newDataArray];
    
}


#pragma mark - ========================获取通讯录中的联系人========================
- (void)loadPerson
{

    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    [self copyAddressBook:addressBook];
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    NSString *userId = getNSUser(kUserInfoKey);
    
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addressBook);
    //进行遍历
    for (NSInteger i=0; i<number; i++) {
        
        YDImportCustModel *model = [[YDImportCustModel alloc] init];
    
        //获取联系人对象的引用
        ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
        //获取当前联系人名字
        NSString*firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        //获取当前联系人姓氏
        NSString*lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
       
        //如果姓氏为空返回名字
        model.name = [NSString stringWithFormat:@"%@", lastName.length ? lastName :firstName];
        
        //获取当前联系人的电话 数组
        NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
        ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
        for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
            [phoneArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
        }
        
        model.phone = phoneArr.firstObject;
        for (NSString *phone in phoneArr) {
            
            NSString *trimmedString = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@"(" withString:@""];
            trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@")" withString:@""];
            trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([YDTool valiMobile:trimmedString]) {
                model.phone = trimmedString;
                break;
            };
        }
        
        model.userId = userId;
        
        if ([YDTool valiMobile:model.phone]) {
            [self.dataArray addObject:model];
        }
    }
}

// 按首字母分组排序数组
-(NSMutableArray *)sortObjectsAccordingToInitialWith:(NSArray *)arr {
    
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    //将每个名字分到某个section下
    for (YDImportCustModel *personModel in self.dataArray) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:@selector(name)];
        //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:personModel];
    }
    
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
        }
    }
    return finalArr;
    
    return newSectionsArray;
}

- (void)getNamePinYinArray
{
    for (int i = 0; i < self.dataArray.count; i++) {
        YDImportCustModel *personModel = [self.dataArray[i] lastObject];
        NSString *pinYin = [self firstCharactor:personModel.name];
        [self.pinYinArray addObject:pinYin];
    }
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
