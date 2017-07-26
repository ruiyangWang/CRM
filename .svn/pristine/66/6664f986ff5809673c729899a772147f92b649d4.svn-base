//
//  YDDefeatApplyController.m
//  CRM
//
//  Created by ios on 16/10/24.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDDefeatApplyController.h"
#import "YDUpdateCusInfoS2Cell.h"
#import "YDFollowApplyModel.h"


@interface YDDefeatApplyController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YDDefeatApplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"战败处理";
    
    [self createView];
}

- (void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64.0f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate =self;
    _tableView.backgroundColor = kViewControllerBackgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerNib(@"YDUpdateCusInfoS2Cell")];
    
}


#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YDUpdateCusInfoS2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUpdateCusInfoS2Cell"];
        cell.titleString = @"申请时间";
        cell.subTitleString = self.applyModel.createTime;
        cell.showNextButton = NO;
        return cell;
    } else if (indexPath.row == 1) {
        YDUpdateCusInfoS2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUpdateCusInfoS2Cell"];
        cell.titleString = @"申请原因";
        cell.subTitleString = self.applyModel.reason;
        cell.showNextButton = NO;
        cell.subTitle.placeholder = @"无";
        return cell;
    } else {
        YDUpdateCusInfoS2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDUpdateCusInfoS2Cell"];
        cell.titleString = @"处理结果";
        cell.showNextButton = YES;
        cell.subTitleString = self.applyModel.result;
        cell.subTitle.placeholder = @"未处理";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        //点击处理结果
        [[[UIAlertView alloc] initWithTitle:self.applyModel.result message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show ];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
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
