//
//  NTESClientsTableViewController.h
//  NIM
//
//  Created by amao on 6/1/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//  多端登录管理页面

#import <UIKit/UIKit.h>

@interface NTESClientsTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end



@interface NTESClientsTableHeader : UIView

@property (nonatomic,strong) UIImageView *icon;

@end
