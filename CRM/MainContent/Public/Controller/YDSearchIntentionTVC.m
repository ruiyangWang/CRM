//
//  YDSearchIntentionTVC.m
//  CRM
//
//  Created by YD_iOS on 16/8/1.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDSearchIntentionTVC.h"

@interface YDSearchIntentionTVC ()

@property (nonatomic, copy)NSArray *datas;

@end

@implementation YDSearchIntentionTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择意向级别";
        
    if (_showLow) {
        _datas = @[@"H",@"A",@"B",@"C",@"战败"];
    }else{
        _datas = @[@"H",@"A",@"B",@"C"];

    }
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = kViewControllerBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reuseIdentifier"];
        
        //分隔线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 48.5f, kScreenWidth, 0.5f)];
        lineView.backgroundColor = kTableViewLineColor;
        [cell addSubview:lineView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    NSString *titleString = _datas[indexPath.row ];
    if ([titleString isEqualToString:@"战败"]) {
        cell.textLabel.text = titleString;
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@级",titleString];
    }
    
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.ClickCellBlack != nil) {
        NSString *s = [_datas objectAtIndex:indexPath.row];
        self.ClickCellBlack(s);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
