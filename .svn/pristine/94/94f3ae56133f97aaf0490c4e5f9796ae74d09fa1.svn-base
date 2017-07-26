//
//  YDNavMenuView.m
//  CRM
//
//  Created by ios on 16/9/20.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDNavMenuView.h"

@interface YDNavMenuView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) CGRect menuFrame;

@property (nonatomic, strong) NSArray *menuArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isHide;

@property (nonatomic, assign) NSInteger selectIndex;

@end
@implementation YDNavMenuView


- (instancetype)initWithMenuArray:(NSArray *)menuArray
{
    if (self = [super init]) {
     
        _menuArray = [NSArray arrayWithArray:menuArray];
        _isHide = YES;
        _selectIndex = 0;
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    NSInteger row = _menuArray.count;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake((kScreenWidth - 120.0f) / 2, 0, 120.0f, 44.0f * row) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    self.frame = CGRectMake(0, 0, kScreenWidth, 0);
    
    self.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
    [self addGestureRecognizer:tap];
}

- (void)viewClick
{
    [self show];
    if (self.BackBlock) {
        self.BackBlock(_selectIndex);
    }
}

- (void)show
{
    if (_isHide) {
    
        CGRect tempFrame = self.frame;
        tempFrame.size.height = kScreenHeight - 64.0f;
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = tempFrame;
        }];

    } else {
        
        [self hide];
    }
    
    _isHide = !_isHide;
}

- (void)hide
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = 0;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = tempFrame;
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"YDNavMenuViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5f, kScreenWidth, 0.5f)];
        lineView.backgroundColor = kTableViewLineColor;
        [cell addSubview:lineView];
    }
    cell.textLabel.text = self.menuArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _selectIndex = indexPath.row;
    
    if (self.BackBlock) {
        self.BackBlock(indexPath.row);
    }
    [self hide];
    _isHide = !_isHide;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
