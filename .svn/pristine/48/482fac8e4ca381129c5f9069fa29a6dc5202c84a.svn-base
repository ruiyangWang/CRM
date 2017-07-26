//
//  YDBuyCarOptionController.m
//  CRM
//
//  Created by ios on 16/8/10.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDBuyCarOptionController.h"
#import "YDBuyCarOptionCell.h"

@interface YDBuyCarOptionController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UITextField *otherTextField;

@property (nonatomic, strong) NSMutableArray *selectArray; //多选

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YDBuyCarOptionController


- (instancetype)init
{
    if (self = [super init]) {
        _selectArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self chooseDataArray];
    
    [self createView];
}

- (void)createView
{
    if (![self.titleString isEqualToString:@"购车类型"]) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
        _rightButton.frame = CGRectMake(0, 0, 40, 40);
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = kViewControllerBackgroundColor;
    [self.view addSubview:_tableView];
    
}

- (void)chooseDataArray
{
    self.title = self.titleString;
    
    if ([self.titleString isEqualToString:@"购车用途"]) {
        _dataArray = [NSMutableArray arrayWithArray:@[@"商务", @"家用", @"休闲", @"其他"]];
    } else if ([self.titleString isEqualToString:@"购车类型"]) {
        _dataArray = [NSMutableArray arrayWithArray:@[@"首次购车", @"增购", @"置换"]];
    } else if ([self.titleString isEqualToString:@"购车关注点"]) {
        _dataArray = [NSMutableArray arrayWithArray:@[@"品牌", @"外形", @"动力", @"操控", @"舒适", @"安全", @"价格", @"其他"]];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.backgroundColor = kViewControllerBackgroundColor;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


- (void)rightButtonClick
{
    if (_selectArray.count > 0) {
        
        NSString *sectelString = @"";
        for (NSString *str in _selectArray) {
            sectelString = [NSString stringWithFormat:@"%@ %@", sectelString, str];
        }
        
        sectelString = [NSString stringWithFormat:@"%@ %@", sectelString, _otherTextField.text.length > 0 ? _otherTextField.text : @""];
        
        if (self.BackBlack) {
            self.BackBlack(sectelString);
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YDBuyCarOptionCell *cell = [YDBuyCarOptionCell cellWithTableView:tableView];
    
    NSString *optionString = self.dataArray[indexPath.row];
    if ([optionString isEqualToString:self.titleString]) {
        _otherTextField = [[UITextField alloc] initWithFrame:CGRectMake(18.0f, 0, kScreenWidth - 36.0f, 48.5f)];
        _otherTextField.placeholder = [NSString stringWithFormat:@"请填写%@", self.titleString];
        _otherTextField.font = [UIFont systemFontOfSize:14.0f];
        [cell addSubview:_otherTextField];
    } else {
        cell.textLabel.text = optionString;
    }
    
    if ([_selectArray containsObject:optionString]) {
        cell.isSelectCell = YES;
    } else {
        cell.isSelectCell = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    NSString *optionString = self.dataArray[indexPath.row];
    NSString *lastString = self.dataArray.lastObject;
    if ([optionString isEqualToString:@"其他"] && [lastString isEqualToString:@"其他"]) {
        [_dataArray addObject:self.titleString];
        [tableView reloadData];
        return;
    } else {
        if ([_selectArray containsObject:optionString]) {
            [_selectArray removeObject:optionString];
        } else {
            [_selectArray addObject:optionString];
        }
    }
    
    [tableView reloadData];
    
    //购车用途是单选
    if ([self.titleString isEqualToString:@"购车类型"]) {
        if (self.BackBlack) {
            self.BackBlack(optionString);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
