//
//  YDTableViewController.m
//  CRM
//
//  Created by ios on 16/7/19.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import "YDTableViewController.h"
#import "YDSearchController.h"

@interface YDTableViewController () <UISearchControllerDelegate,UISearchBarDelegate>


@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) YDSearchController *searchVC;
@end

@implementation YDTableViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self createTableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.definesPresentationContext = YES;
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    _searchVC = [[YDSearchController alloc] init];

    if (_searchBarType == SearchBarTypeTableViewHeader) {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  ======================tableView模块============================
#pragma mark  tableView 的创建
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.tableView];
}

#pragma mark -Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}


#pragma mark -  ======================搜索模块============================
#pragma mark 搜索控制权
- (UISearchController *) searchController
{
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchVC];
        
        [_searchController setSearchResultsUpdater: self.searchVC];
        [_searchController.searchBar sizeToFit];
        [_searchController.searchBar setDelegate:self];
        [_searchController.searchBar setPlaceholder:@"搜索"];
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [_searchController.searchBar.layer setBorderWidth:0];
        
        // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
        for (UIView *searchbuttons in [_searchController.searchBar.subviews[0] subviews]){
            if ([searchbuttons isKindOfClass:[UIButton class]]) {
                UIButton *cancelButton = (UIButton*)searchbuttons;
                // 修改文字颜色
                [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            }
        }
    }
    return _searchController;
}

#pragma mark 搜索框的代理方法，搜索输入框获得焦点（聚焦）

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    [searchBar setBarTintColor:kNavigationBackgroundColor];
    [searchBar.layer setBorderWidth:0.5];
    [searchBar.layer setBorderColor:kNavigationBackgroundColor.CGColor];
    
    
    [searchBar setShowsCancelButton:YES animated:YES];
    NSArray *array = [[searchBar subviews][0] subviews];
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    for (UIView *searchbuttons in array){
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            // 修改文字颜色
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_searchController.searchBar.layer setBorderWidth:0.5];
    [_searchController.searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
}




@end
