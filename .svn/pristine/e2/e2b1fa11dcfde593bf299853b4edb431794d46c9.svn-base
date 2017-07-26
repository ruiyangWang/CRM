//
//  YDActiveCustomerListController.m
//  CRM
//
//  Created by ios on 16/11/8.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDActiveCustomerListController.h"
#import "YDCustListModel.h"
#import "YDUserInfoCell.h"
#import "YDCustomerDetailController.h"

@interface YDActiveCustomerListController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YDActiveCustomerListController

- (instancetype)init
{
    if (self = [super init]) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createView];
    
    [self loadActiveCustomerFormNetwork];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)createView
{
    self.title = @"活跃客户";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64.0f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kViewControllerBackgroundColor;
    [self.view addSubview:_tableView];
    [self.tableView registerNib(@"YDUserInfoCell")];
}

#pragma mark 获取活跃客户列表
- (void)loadActiveCustomerFormNetwork
{
    NSString *url = [NSString stringWithFormat:@"%@type=liveness&sid=%@",kCustomerListAddress,getNSUser(@"youdao.CRM_SID")];
    [YDDataService startSyncRequest:@{} url:url block:^(id result) {
        if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
            
            for (NSDictionary *dic in result[@"var"][@"livenessList"]) {
                YDCustListModel *customerModel = [YDCustListModel instanceWithDict:dic];
                [_dataArray addObject:customerModel];
            }
        }
        
    } failBlock:^(id error) {
        NSLog(@"获取活跃客户失败");
    }];
}


#pragma mark -=========================tableView 代理方法=========================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUserInfoCell"];
    cell.custListModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDCustListModel *custModel = self.dataArray[indexPath.row];
    YDCustomerDetailController *VC = [[YDCustomerDetailController alloc] init];
    VC.customerId = custModel.customerId;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
