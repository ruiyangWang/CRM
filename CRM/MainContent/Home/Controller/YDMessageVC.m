//
//  YDMessageVC.m
//  CRM
//
//  Created by YD_iOS on 16/7/13.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDMessageVC.h"
#import "YDMessageCell.h"
#import "YDMessageModel.h"

#import "NTESSessionListViewController.h"
#import "NTESSessionViewController.h"

@interface YDMessageVC () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation YDMessageVC

#pragma mark ----- vc lift cycle 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息";
    
    [self createView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self updateMessageStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----- get and setter 属性的set和get方法
#pragma mark ----- event Response 事件响应(手势 通知)
- (void)systemMessageButtonClick
{
    NTESSessionViewController *IMVC = [[NTESSessionViewController alloc] initWithSession:[NIMSession session:@"27210290" type:NIMSessionTypeTeam]];
    IMVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:IMVC animated:YES];
}

#pragma mark ----- custom action for UI 界面处理有关
- (void)createView
{
    [_myTableView registerNib(@"YDMessageCell")];
    _myTableView.rowHeight=UITableViewAutomaticDimension;//表示cell的高度自适应
    _myTableView.estimatedRowHeight=65.0f;//cell最小高度
    _myTableView.backgroundColor = kViewControllerBackgroundColor;
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0f)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    _myTableView.tableHeaderView = tableHeaderView;
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableHeaderView addSubview:messageButton];
    messageButton.frame = CGRectMake(0, 0, kScreenWidth, 44.0f);
    [messageButton setTitle:@"系统消息" forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(systemMessageButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ----- custom action for DATA 数据处理有关
- (void)updateMessageStatus{
    
    if (_messages.count >0 ) {
        //更新消息状态
        NSString *messageUrl = [NSString stringWithFormat:@"%@sid=%@",kCrmModifyNotifyMsg,getNSUser(@"youdao.CRM_SID")];
        [YDDataService startRequest:@{} url:messageUrl block:^(id result) {
            
            if ([[result objectForKey:@"code"] isEqualToString:@"S_OK"]) {
                NSLog(@"消息更新成功");
            }
        } failBlock:^(id error) {
            NSLog(@"消息更新失败");
        }];
    }
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YDMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YDMessageCell"];
    YDMessageModel *model = [_messages objectAtIndex:indexPath.row];
    cell.messageModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 137.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end
