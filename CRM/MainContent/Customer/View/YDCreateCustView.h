//
//  YDCreateCustView.h
//  CRM
//
//  Created by ios on 16/7/25.
//  Copyright © 2016年 YD_iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDCustListModel;
@protocol YDCreateCustViewDelegate <NSObject>

/**
 *  返回上一页
 */
- (void)backFontPage;

/**
 *  下一步按钮点击
 */
- (void)nextStepBtnClickWithPhone:(NSString *)phone;

/**
 *  输入的手机号码
 *
 *  @param phone <#phone description#>
 */
- (void)phoneFromTextField:(NSString *)phone;

/**
 *  查看客户详情
 *
 *  @param model 自己的客户
 */
- (void)seeCustomerDetailWithModel:(YDCustListModel *)model;

/**
 *  撞单申诉
 *
 *  @param custmoerID <#custmoerID description#>
 */
- (void)orderConfictAppealWithCustomerID:(NSString *)custmoerID;


/**
 查询到订单客户，需要带入订单客户基本信息

 @param orderCustomer 订单客户
 */
- (void)addCustomerWithOrderCustomer:(YDCustListModel *)orderCustomer;

@end


@interface YDCreateCustView : UIView


@property (nonatomic, strong) YDCustListModel *customerModel;

@property (nonatomic, weak) id<YDCreateCustViewDelegate> delegate;

/**
 *  成为第一响应者
 */
- (void)phoneTextFieldBecomeFirstResponder;

@end