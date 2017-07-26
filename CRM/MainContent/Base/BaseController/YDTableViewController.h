//
//  YDTableViewController.h
//  CRM
//
//  Created by ios on 16/7/19.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , SearchBarType) {
    SearchBarTypeNone             = 0,           //默认无搜索
    SearchBarTypeTableViewHeader  = 1 << 0,      //tableView头部有搜索
    
};

@interface YDTableViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UITableView *tableView;


/**
 *  搜索栏的类型 (默认无搜索栏框)
 */
@property (nonatomic, assign) SearchBarType searchBarType;


@end
