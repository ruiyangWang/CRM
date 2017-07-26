//
//  YDCommonSettingsController.m
//  CRM
//
//  Created by ios on 16/9/27.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDCommonSettingsController.h"
#import "YDHelpFeedbackController.h"
#import "YDVersionUpdateController.h"
#import "YDAboutZCBController.h"
#import "ViewController.h"
#import "YDUserInfoFMDB.h"
#import "YDDataService.h"

@interface YDCommonSettingsController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *exitLoginButton; //退出登录按钮

@property (nonatomic, copy) NSString *currentVersion;

@property (nonatomic, copy) NSString *bestNewVersion;

@property (nonatomic, strong) UILabel *versionLabel; //发现新版本的红圈圈

@end

@implementation YDCommonSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];
    
    [self getVersionNumber];
}

#pragma mark － ================界面===================
- (void)createView
{
    self.title = @"通用设置";

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64.0f) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kViewControllerBackgroundColor;
    [self.view addSubview:_tableView];
    
    
    //退出登录按钮
    _exitLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _exitLoginButton.frame = CGRectMake(0, kScreenHeight - 64.0f - 49.0f, kScreenWidth, 49.0f);
    [_exitLoginButton setTitle:@"退出登录" forState:UIControlStateNormal];
    _exitLoginButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _exitLoginButton.backgroundColor = kGetBackgroundColor;
    [_exitLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_exitLoginButton addTarget:self action:@selector(exitLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exitLoginButton];
}

#pragma mark 退出登录
- (void)exitLogin
{
    [[[UIAlertView alloc] initWithTitle:@"是否确定退出登录？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //删除数据
        [kUserDefaults removeObjectForKey:@"youdao.CRM_SID"];
        [[YDUserInfoFMDB sharedYDUserInfoFMDB] deleteUserInfoWithUserID:nil];
        
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *vc = [main instantiateViewControllerWithIdentifier:@"ViewController"];
        [self presentViewController:vc animated:YES completion:^{
            self.view.window.rootViewController = vc;
        }];
    }
}

#pragma mark 获取版本号  
- (void)getVersionNumber
{
    //最新版本号
    //192.168.8.118:8080/admin-webapp/version/getVersion?sid=xxxxx
    
    NSString *urlString = [NSString stringWithFormat:@"%@sid=%@", kGetVersionAddress, getNSUser(kCRM_SIDKey)];
    [YDDataService startRequest:@{} url:urlString block:^(id result) {
        NSDictionary *iOSInfo = [result valueForKey:@"iOS_CRM"];
//        {
//            app = CRM;
//            description = "1.\U4fee\U6539\U4e86123;\n2.\U4fee\U6539\U4e86456;";
//            title = CRM;
//            version = "1.0.4";
//        }
        _bestNewVersion = iOSInfo[@"version"];
        
        [self.tableView reloadData];
    } failBlock:^(id error) {
        [self.tableView reloadData];
    }];
    
    //当前版本
    _currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
}

#pragma mark - ================tableView代理方法===================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"myInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 48.5f, kScreenWidth, 0.5f)];
    lineView.backgroundColor = kTableViewLineColor;
    [cell addSubview:lineView];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"检查更新";
            break;
        case 1:
            cell.textLabel.text = @"帮助与反馈";
            break;
        case 2:
            cell.textLabel.text = @"关于掌车宝";
            break;
        default:
            break;
    }
    
    if (indexPath.row == 0) {
        
        [cell addSubview:self.versionLabel];
        
        if ([_bestNewVersion isEqualToString:_currentVersion]) {
            //最新版本
            self.versionLabel.hidden = YES;
        } else {
            //发现新版本
            self.versionLabel.hidden = NO;
        }
        
        if (_bestNewVersion == nil) {
            self.versionLabel.hidden = YES;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        if ([_bestNewVersion isEqualToString:_currentVersion]) {
            [MBProgressHUD showTips:@"已是最新版本" toView:kWindow];
        } else {
            YDVersionUpdateController *versionUpdateVC = [[YDVersionUpdateController alloc] init];
            [self.navigationController pushViewController:versionUpdateVC animated:YES];
        }
        
    } else if (indexPath.row == 1) {
        YDHelpFeedbackController *helpFeedbackVC = [[YDHelpFeedbackController alloc] init];
        [self.navigationController pushViewController:helpFeedbackVC animated:YES];
    } else if (indexPath.row == 2) {
        YDAboutZCBController *aboutZCBVC = [[YDAboutZCBController alloc] init];
        [self.navigationController pushViewController:aboutZCBVC animated:YES];
    }
}

- (UILabel *)versionLabel
{
    if (_versionLabel == nil) {
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(73.0f, 10.0f, 13.0f, 13.0f)];
        _versionLabel.backgroundColor = [UIColor redColor];
        _versionLabel.text = @"1";
        _versionLabel.textColor = [UIColor whiteColor];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = [UIFont systemFontOfSize:12.0f];
        _versionLabel.layer.cornerRadius = 6.5f;
        _versionLabel.layer.masksToBounds = YES;
    }
    return _versionLabel;
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