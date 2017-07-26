//
//  YDCustomerView.h
//  CRM
//
//  Created by ios on 16/8/2.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YDCustListModel;
@protocol YDCustomerListViewDelegate <NSObject>

/**
 *  左边tableView的cell被选中
 *
 *  @param index 选中的下标
 */
- (void)leftTableViewDidSelectCustomer:(YDCustListModel *)customer;

/**
 *  右边的tableview的cell被选中
 *
 *  @param index 选中的下标
 */
- (void)rightTableViewDidSelectCustomer:(YDCustListModel *)customer;

/**
 *  拨打电话
 *
 *  @param phone <#phone description#>
 */
- (void)callPhone:(YDCustListModel *)custModel;

/**
 *  添加跟进
 */
- (void)addFollowWithCustomer:(YDCustListModel *)customer;

/**
 *  删除导入客户
 *
 *  @param customer        客户模型
 *  @param isIntentionCust 是否意向客户（YES表示意向客户，NO表示订单客户）
 */
- (void)deleteImportCustomer:(YDCustListModel *)customer isIntentionCust:(BOOL)isIntentionCust;

@end

@interface YDCustomerListView : UIView

@property (nonatomic, weak) id<YDCustomerListViewDelegate> delegate;

@property (nonatomic, strong) UITableView *oneTableView;
@property (nonatomic, strong) UITableView *twoTableView;

/**
 *  意向客户数据
 */
@property (nonatomic, strong) NSMutableArray *oneDataArray;


/**
 *  订单客户数据
 */
@property (nonatomic, strong) NSMutableArray *twoDataArray;

/**
 *  意向客户索引
 */
@property (nonatomic, strong) NSMutableArray *onePYArray;

/**
 *  订单客户索引
 */
@property (nonatomic, strong) NSMutableArray *twoPYArray;

/**
 *  是否显示第一个表（左边的）
 */
- (void)showOneTableView:(BOOL)isShow;

@end