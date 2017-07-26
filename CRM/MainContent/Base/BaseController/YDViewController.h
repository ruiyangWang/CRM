//
//  YDViewController.h
//  CRM
//
//  Created by YD_iOS on 16/7/21.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^BackStringBlock)(NSString *str);

typedef void(^CarChooseBlock)(NSMutableDictionary *dic);

@class YDCustCellModel;
@interface YDViewController : UIViewController

/**
 当检测到这个错误码的时候是否需要重新登录
 @param errorCode 错误码
 */
- (void)isNeedAgainLoginWithErrorCode:(NSString *)errorCode;

/**
 *  选择车型
 *
 *  @param tableView 编辑的tableView
 *  @param cellModel 选中的cellModel
 */
- (void)chooseCarWithTableView:(UITableView *)tableView
                     cellModel:(YDCustCellModel *)cellModel
                   chooseBlock:(CarChooseBlock)block;

/**
 *  直接编辑
 *
 *  @param tableView     tableview
 *  @param cellModel     选中的cellModel
 *  @param indexPath     选择的下标
 */
- (void)directEditWithTableView:(UITableView *)tableView
                      cellModel:(YDCustCellModel *)cellModel
                      indexPath:(NSIndexPath *)indexPath
                    chooseBlock:(BackStringBlock)block;

/**
 *  日历选择
 *
 *  @param tableView     tableview
 *  @param cellModel     选中的cellModel
 *  @param indexPath     选择的下标
 */
- (void)calendarPickerWithTableView:(UITableView *)tableView
                          cellModel:(YDCustCellModel *)cellModel
                          indexPath:(NSIndexPath *)indexPath
                        chooseBlock:(BackStringBlock)block;


/**
 *  买车条件选择
 *
 *  @param tableView 编辑的tableView
 *  @param cellModel 选中的cellModel
 */
- (void)buyCarOptionWithTableView:(UITableView *)tableView
                        cellModel:(YDCustCellModel *)cellModel
                      chooseBlock:(BackStringBlock)block;


/**
 *  时间选择（出生日期等、需要选择年份）
 *
 *  @param tableView     tableview
 *  @param cellModel     选中的cellModel
 *  @param indexPath     选择的下标
 */
- (void)dateChooseWithTableView:(UITableView *)tableView
                      cellModel:(YDCustCellModel *)cellModel
                      indexPath:(NSIndexPath *)indexPath
                    chooseBlock:(BackStringBlock)block;


/**
 *  地址选择
 *
 *  @param tableView     tableview
 *  @param cellModel     选中的cellModel
 *  @param indexPath     选择的下标
 */
- (void)addressChooseWithTableView:(UITableView *)tableView
                         cellModel:(YDCustCellModel *)cellModel
                         indexPath:(NSIndexPath *)indexPath
                       chooseBlock:(BackStringBlock)block;

/**
 *  填写备注
 *
 *  @param tableView     tableview
 *  @param cellModel     选中的cellModel
 *  @param indexPath     选择的下标
 */
- (void)remarksWithTableView:(UITableView *)tableView
                   cellModel:(YDCustCellModel *)cellModel
                   indexPath:(NSIndexPath *)indexPath
                 chooseBlock:(BackStringBlock)block;


/**
 *  禁用cell上的textField
 */
- (void)disableCellTextField;


@end
